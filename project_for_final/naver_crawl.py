import requests
from bs4 import BeautifulSoup
import pandas as pd
import time
import re
from tqdm import tqdm
from konlpy.tag import Okt
from collections import Counter

CLIENT_ID = "c8HDryBJTdZ2Yd0LQQGg"
CLIENT_SECRET = "hmEEgqCeOo"

KEYWORDS = ["서울러닝코스", "서울러닝", "서울러닝코스추천", "서울달리기코스", "서울달리기코스추천"]

# 불용어
STOPWORDS = {
    "러닝", "코스", "서울", "추천", "운동", "달리기", "마라톤",
    "훈련", "페이스", "거리", "공원", "길", "구간", "방향",
    "근처", "주변", "오늘", "신발", "라이프",
    "생각", "이번", "지난", "우리", "저희", "사람", "친구",
    "혼자", "같이", "때문", "정도", "시간", "네이버", "블로그",
    "포스팅", "이웃", "클릭", "구독", "댓글", "공감", "스크랩",
    "사진", "영상", "내용", "정보", "후기", "리뷰", "소개",
    "이상", "이하", "기준", "방법", "준비", "완료", "시작",
    "종료", "도착", "출발", "코스트", "데이터", "앱", "지도"
}

# 시작 위치 패턴
START_PATTERNS = [
    r'([가-힣]{2,6})(역|입구)에서',
    r'([가-힣]{2,6})앞에서\s*만나',
    r'([가-힣]{2,6})에서\s*(출발|시작|스타트|집합|모여서)',
    r'([가-힣]{2,6})(부터)\s*(달리|뛰|러닝|출발|모여서)',
    r'출발지[:\s]*([가-힣]{2,6})',
    r'스타트[:\s]*([가-힣]{2,6})',
    r'([가-힣]{2,6})\s*출발',
    r'([가-힣]{2,6})을\s*시작점으로',
]

# 시간대 패턴
TIME_PATTERNS = {
    "새벽": r'새벽',
    "아침": r'아침|오전\s*[6-9]시|[6-9]시\s*오전',
    "오전": r'오전|[10-11]시',
    "오후": r'오후\s*[12]시|점심',
    "저녁": r'저녁|오후\s*[6-9]시|퇴근\s*후',
    "밤": r'밤|야간|오후\s*[10-11]시|[10-11]시\s*이후',
}

okt = Okt()

def search_naver(keyword, display=100, start=1, source="blog"):
    url = f"https://openapi.naver.com/v1/search/{source}.json"
    headers = {
        "X-Naver-Client-Id": CLIENT_ID,
        "X-Naver-Client-Secret": CLIENT_SECRET,
        "Accept": "application/json; charset=UTF-8"
    }
    params = {
        "query": keyword,
        "display": display,
        "start": start,
        "sort": "sim"
    }
    res = requests.get(url, headers=headers, params=params, timeout=10)
    if res.status_code == 200:
        res.encoding = "utf-8"
        return res.json().get("items", [])
    else:
        print(f"에러: {res.status_code}")
        return []

def get_blog_content(url):
    try:
        match = re.search(r'blog\.naver\.com/([^/]+)/(\d+)', url)
        if match:
            blog_id = match.group(1)
            log_no = match.group(2)
            url = f"https://blog.naver.com/PostView.naver?blogId={blog_id}&logNo={log_no}"
        headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
            "Referer": "https://blog.naver.com"
        }
        res = requests.get(url, headers=headers, timeout=5)
        res.encoding = "utf-8"
        soup = BeautifulSoup(res.text, "html.parser")
        content = soup.find("div", {"class": "se-main-container"})
        if not content:
            content = soup.find("div", {"id": "postViewArea"})
        if content:
            return content.get_text(separator=" ", strip=True)[:3000]
        return ""
    except:
        return ""

def extract_nouns(text):
    try:
        nouns = okt.nouns(text)
        filtered = [n for n in nouns if len(n) >= 2 and n not in STOPWORDS]
        return filtered
    except:
        return []

def extract_start_places(text):
    places = []
    for pattern in START_PATTERNS:
        matches = re.findall(pattern, text)
        for match in matches:
            place = match[0] if isinstance(match, tuple) else match
            if len(place) >= 2 and place not in STOPWORDS:
                places.append(place)
    return list(set(places))

def extract_time(text):
    found_times = []
    for time_label, pattern in TIME_PATTERNS.items():
        if re.search(pattern, text):
            found_times.append(time_label)
    return found_times if found_times else ["시간미상"]

def crawl_all():
    all_results = []
    all_nouns = []
    all_start_places = []

    for keyword in KEYWORDS:
        print(f"\n키워드: [{keyword}] 수집 중...")

        # 페이지네이션으로 최대 300개 수집
        for start in range(1, 301, 100):
            items = search_naver(keyword, display=100, start=start, source="blog")
            if not items:
                break

            for item in tqdm(items, desc=f"start={start}"):
                title = re.sub(r"<[^>]+>", "", item.get("title", ""))
                description = re.sub(r"<[^>]+>", "", item.get("description", ""))
                link = item.get("link", "")

                text_preview = title + " " + description

                # 본문 크롤링
                content = ""
                if "blog.naver.com" in link:
                    content = get_blog_content(link)
                    time.sleep(0.3)

                full_text = text_preview + " " + content

                # 전체 명사 추출
                nouns = extract_nouns(full_text)
                all_nouns.extend(nouns)

                # 시작 위치 추출
                start_places = extract_start_places(full_text)
                all_start_places.extend(start_places)

                # 시간대 추출
                times = extract_time(full_text)

                all_results.append({
                    "keyword": keyword,
                    "title": title,
                    "description": description,
                    "link": link,
                    "start_places": ",".join(start_places),
                    "time_of_day": ",".join(times),
                    "nouns": ",".join(nouns[:20])
                })

            time.sleep(1)

    # 전체 결과 저장
    df = pd.DataFrame(all_results)
    df.to_csv("naver_running.csv", index=False, encoding="utf-8-sig")
    print(f"\n수집 완료! 총 {len(df)}개 문서")

    # 1. 전체 명사 빈도
    noun_freq = Counter(all_nouns)
    df_noun = pd.DataFrame(noun_freq.most_common(200), columns=["noun", "frequency"])
    df_noun.to_csv("noun_frequency.csv", index=False, encoding="utf-8-sig")

    # 2. 시작 위치 빈도
    start_freq = Counter(all_start_places)
    df_start = pd.DataFrame(start_freq.most_common(100), columns=["place", "frequency"])
    df_start.to_csv("start_place_frequency.csv", index=False, encoding="utf-8-sig")

    # 3. 장소 x 시간대 교차표
    place_time = []
    for _, row in df.iterrows():
        places = row["start_places"].split(",") if row["start_places"] else []
        times = row["time_of_day"].split(",") if row["time_of_day"] else []
        for p in places:
            if p:
                for t in times:
                    place_time.append({"place": p, "time": t})

    if place_time:
        df_pt = pd.DataFrame(place_time)
        crosstab = pd.crosstab(df_pt["place"], df_pt["time"])
        crosstab.to_csv("place_time_crosstab.csv", encoding="utf-8-sig")

    # 결과 출력
    print("\n=== 전체 명사 빈도 TOP 20 ===")
    print(df_noun.head(20).to_string())
    print("\n=== 러닝 시작 위치 TOP 20 ===")
    print(df_start.head(20).to_string())

    return df, df_noun, df_start

if __name__ == "__main__":
    df, df_noun, df_start = crawl_all()