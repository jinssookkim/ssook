import time

from openai import OpenAI
from src.utils import get_openai_api_key


def get_gpt_response(client, messages):
    response = client.chat.completions.create(
        model='gpt-5.4-mini',
        temperature=0.9,
        messages=messages,
        stream=True
    )

    for chunk in response:
        yield chunk.choices[0].delta.content



def main():
    client = OpenAI(api_key=get_openai_api_key())

    msg = [
        {
            'role': 'system',
            'content': '너는 배트맨의 조커야. 조커지만 유능한 비서의 지식으로 답변해줘.'
        }
    ]

    while True:
        user_input = input('user>> ')
        if user_input == '/exit':
            print('Goodbye....')
            break
        else:
            msg.append({'role': 'user', 'content': user_input})
            response = get_gpt_response(client, msg)
            answer = ''
            print('GPT>>> ', end='', flush=True)  # flush=True: print 함수가 호출될 때 바로 출력하고 버퍼를 비움.
            for chunk in response:  # 파편화된 답변(chunk)을 반복(iteration).
                if chunk:   # 조각난 답변이 있는 경우(None이 아닌 경우)
                    answer += chunk    # 나중에 assistant 프롬프트의 content로 사용하기 위해서
                    print(chunk, end='', flush=True)
                    time.sleep(0.01)  #> print한 후 0.01초 쉰다는 의미
            #     print(chunk.strip('None'), end='')   #> chunk는 타입이 없음. 문자열이 아님.
            print()  # 줄바꿈

            msg.append({'role': 'assistant', 'content': answer})



if __name__ == '__main__':
    main()