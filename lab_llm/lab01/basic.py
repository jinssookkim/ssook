from openai import OpenAI

from src.utils import get_openai_api_key  # utils\__init__에 명시되어 있기 때문에 이렇게만 사용해도 됨

if __name__ == '__main__':
    # 환경 변수에 저장된 OpenAI API 키를 읽어 옴
    api_key = get_openai_api_key()

    # OpenAI 클라이언트: GPT로 요청(질문)을 보내고, 그에 대한 응답(답변)을 전달받는 객체
    # OpenAI 클라이언트 생성
    client = OpenAI(api_key=api_key)

    # OpenAI 클라이언트를 사용해서 GPT에 chat completions 요청을 보냄
    response = client.chat.completions.create(
        # GPT 모델(버전) 지정: gpt-4o-mini($0.15), gpt-5-mini($0.25), gpt-5.4-mini($0.75)
        model='gpt-5.4-mini',
        temperature=0.9,
        messages=[
            {
                'role': 'system',
                'content': '너는 나를 도와주는 인공지능 비서야.'
            },
            {
                'role': 'user',
                'content': '2026 한국의 헬스케어/웰니스 트렌드를 알려줘.'
            }
        ]
    )
    print(response)    #> ChatCompletion 클래스의 객체
    print('-' * 30)
    print(response.choices)  #> list. 그 안에 있는 변수(field)들을 보여줌.
    print(len(response.choices))  #> list의 아이템 개수 1개
    print(response.choices[0])  #> Choice 객체
    print(response.choices[0].message)  #> ChatCompletionMessage 객체
    print('-' * 30)
    print(response.choices[0].message.content)  #> GPT 서버에서 보내준 답변