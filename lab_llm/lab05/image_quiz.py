import base64   # 이미지 바이너리 데이터를 텍스트로 인코딩하기 위한 모듈
from glob import glob  # 폴더 안의 파일 리스트를 쉽게 가져옴

from src.utils import openai_client


def base64encode_image(image_path):
    with open(image_path, mode='rb') as f:
        data = f.read()

        return base64.b64encode(data).decode(encoding='utf-8')


def make_image_quiz(image_path):
    # 이미지 한 개를 gpt 서버로 전송해서 퀴즈 문제와 정답/해설을 만들도록 요청을 보내고 응답을 리턴
    prompt = '''
    제공한 이미지를 사용해서 다음과 같은 형식으로 퀴즈를 만들어줘.
    정답은 (1) ~ (4) 중 하나만 해당하도록 만들어줘. 아래는 문제 예시야.
    === 예시 ===
    Q. 다음 이미지에 대한 설명으로 옳지 않은 것은?
    (1) 카페에는 커피를 마시고 있는 사람들이 있다.
    (2) 맨 앞 사람은 노트북을 사용하고 있다.
    (3) 맨 앞 사람은 빨간 셔츠를 입고 있다.
    (4) 점원이 커피를 만들고 있다.
    
    A. (2) - 맨 앞 사람은 독서를 하고 있다.
    
    
    주의: 정답은 (1) ~ (4) 중에서 오직 하나만 선택되도록 문제를 만들어줘.
    '''
    b64_encoded = base64encode_image(image_path)

    messages =    [
        {
            'role': 'user',
            'content': [
                {'type': 'text', 'text': prompt},
                {'type': 'image_url', 'image_url': {'url': f'data:image/jpg;base64,{b64_encoded}'}}
        ]
        }
    ]

    response = openai_client.chat.completions.create(
        model = 'gpt-5.4-mini',
        messages=messages,
        temperature=0.9
    )

    return response.choices[0].message.content




def main():
    full_text = ''  # 각각의 이미지 퀴즈들을 하나의 문자열로 합치기 위한 변수
    for i, path in enumerate(glob('./images/*.jpg')): # 현재 폴더 아래의 images 폴더에 저장된 모든 jpg 파일을 찾음
        try:
            # GPT에게 퀴즈/정답/해설 생성하라는 요청
            quiz = make_image_quiz(path)
            print(quiz)
            full_text += f'![image]({path})\n\n'
            seperator = f'\n\n## 문제 {i + 1}\n\n'
            full_text += seperator
            full_text += quiz + '\n\n'
        except Exception as e:
            # GPT 응답 요청 과정에서 에러가 발생하더라도, 다음 이미지의 퀴즈를 계속 만들도록 하기 위해
            print(e)  # 에러 메시지 출력
            continue  # for 반복을 계속 수행

    full_text = full_text.replace('\n', '\n\n')
    # 확장자가 md인 파일(markdown)을 작성
    with open('./image_quiz.md', mode='wt', encoding='utf-8') as f:
        f.write(full_text)
        print('Markdown 문서 생성 성공!')


if __name__ == '__main__':
    main()