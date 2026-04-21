from openai import OpenAI
from src.utils import get_openai_api_key



def chat_response(client, messages):
    response = client.chat.completions.create(
        model='gpt-5.4-mini',
        messages=messages,
        temperature=0.9
    )

    return response.choices[0].message.content



def main():
    # 콘솔 창에서 사용자 입력을 받아서 질문 내용으로 사용
    # 사용자가 exit을 입력하면 프로그램 종료
    client = OpenAI(api_key=get_openai_api_key())

    msg = [
        {
            'role': 'system',
            'content': '넌 아주 똑똑한 나의 인공지능 비서야.'
        }
    ]


    while True:   # 무한 반복문
        # 콘솔 창에서 사용자 입력을 받음
        user_input = input('user>> ')
        if user_input == 'exit':
            print('프로그램을 종료합니다..')
            break  # 반복문 종료

        msg.append({'role': 'user', 'content': user_input})

        response = chat_response(client, msg)

        print('GPT>>', response)

        msg.append({'role': 'assistant', 'content': response})
        # print(msg)



if __name__ == '__main__':
    main()