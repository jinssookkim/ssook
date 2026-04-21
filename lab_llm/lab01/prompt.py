
from openai import OpenAI
from src.utils import get_openai_api_key


def chat(client, messages):
    response = client.chat.completions.create(
        model='gpt-5.4-mini',
        temperature=0.9,
        messages=messages
    )
    print(response.choices[0].message.content)


def main():
    client = OpenAI(api_key=get_openai_api_key())

    # no prompting: messages에 assistant prompt를 제공하지 않는 것
    no_prompt_msg = [
        {
            'role': 'system',
            'content': '유치원생처럼 대답해줘.'
        },
        {
            'role': 'user',
            'content': '오리'}
    ]
    chat(client=client, messages=no_prompt_msg)

    print('-' * 30)

    # one-shot prompting: user-assistant 프롬프트를 한 개 작성하고 질문을 작성.
    # GPT가 사용자가 원하는 패턴에 맞춰서 답변을 생성하도록 예시를 한 번 제시해서 답변을 유도
    one_shot_prompt_msg = [
        {'role': 'system', 'content': '유치원생처럼 대답해줘.'},
        {'role': 'user', 'content': '참새'},
        {'role': 'assistant', 'content': '짹짹'},   # one-shot prompting
        {'role': 'user', 'content': '오리'}
    ]

    chat(client=client, messages=one_shot_prompt_msg)

    print('-' * 30)

    # few-shot prompting: 원하는 답변을 유도하기 위해서 예시를 user-assistant로 이루어진 프롬프트 예시를 여러 개 전달.
    few_shot_prompt_msg = [
        {'role': 'system', 'content': '유치원생처럼 대답해줘.'},
        {'role': 'user', 'content': '참새'},
        {'role': 'assistant', 'content': '짹짹'},
        {'role': 'user', 'content': '개구리'},
        {'role': 'assistant', 'content': '개굴개굴'},
        {'role': 'user', 'content': '소'},
        {'role': 'assistant', 'content': '음메'},
        {'role': 'user', 'content': '오리'}
    ]
    chat(client=client, messages=few_shot_prompt_msg)



if __name__ == '__main__':
    main()