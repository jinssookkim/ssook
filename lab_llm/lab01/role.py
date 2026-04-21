from http.client import responses

from openai import OpenAI

from src.utils import get_openai_api_key


def main():
    # OpenAI client 생성
    client = OpenAI(api_key=get_openai_api_key())

    # GPT 서버로 요청을 보내고 응답 받기
    response = client.chat.completions.create(
        model='gpt-5.4-mini',
        temperature=0.9,
        messages=[
            {
                'role': 'system',
                # 'content': '''너는 백설공주 이야기의 마법 거울이야.
                # 마법 거울 캐릭터에 맞게 답변해줘.'''
                'content': ''' 너는 배트맨 영화의 조커야.
                조커처럼 답변해줘.'''
            },
            {   'role': 'user',
                'content': '거울아, 거울아, 세상에서 누가 제일 예쁘니?'
            }
        ]
    )
    print(response.choices[0].message.content)

if __name__ == '__main__':
    main()