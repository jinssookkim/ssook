from multiprocessing.connection import answer_challenge

from openai import OpenAI

from src.utils import get_openai_api_key

def get_gpt_response(client, messages):
    response = client.chat.completions.create(
        model='gpt-5.4-mini',
        messages=messages,
        temperature=0.9
    )
    return response.choices[0].message.content


def main():
    # 신문기사가 저장된 텍스트 파일의 경로
    # 절대 경로(absolute path)
    article_file = 'C:\\workspaces\\lab_llm\\src\\lab03\\data\\article.txt'
    # 상대 경로(relative path)  # 현재 작업 디렉토리를 기준으로 파일을 찾아 가는 방법
    # article_file = './data/article.txt'   .: 현재 directory
    with open(article_file, encoding='utf-8') as f:
        txt = f.read()  # 파일 전체를 읽음


    prompt = f'''
    너는 문서를 요약하는 비서야.
    아래의 글을 읽고 저자의 주장과 근거를 요약해줘.
    작성해야 하는 포맷은 다음과 같아.
    # 제목
    ## 부제목
    ## 저자의 주장과 근거(10문장 이내)
    ## 저자 소개
    ## 참고문헌
    
    ===== 이하 텍스트 =====
    
    {txt}
    '''

    message = [
        {'role': 'system', 'content': prompt}
    ]

    client = OpenAI(api_key=get_openai_api_key())

    answer = get_gpt_response(client=client, messages=message)
    print(answer)


if __name__ == '__main__':
    main()