import streamlit as st
from src.utils import openai_client


def get_gpt_response(messages):
    # 스트리밍 방식으로 응답받기
    response = openai_client.chat.completions.create(
        model='gpt-5.4-mini',
        temperature=0.9,
        messages=messages,
        stream=True
    )

    for chunk in response:
        yield chunk.choices[0].delta.content


def main():
    st.title("🌿Good Morning, 또 오셨네요🌸")

    # st.session_state에 messages 키가 없는 경우, 새로 생성
    if 'messages' not in st.session_state:
        st.session_state.messages = [{'role': 'assistant', 'content': '안녕하세요! 무엇을 도와드릴까요?'}]

    # st.session_state에 저장된 대화 목록을 화면에 아이콘과 함께 출력
    for msg in st.session_state.messages:
        st.chat_message(msg['role']).markdown(msg['content'])

    # 사용자 입력창 출력, 입력됐을 때 할 일을 작성
    if user_prompt := st.chat_input('오늘 어떤 도움을 드릴까요?🌼'):
        st.chat_message('user').markdown(user_prompt)
        st.session_state.messages.append({'role': 'user', 'content': user_prompt})


    # GPT API를 사용해서 질문-답변 받고 출력
    response = get_gpt_response(st.session_state.messages)
    answer = ''
    with st.chat_message('assistant').empty():  # 아이콘만 있고, 대화 내용은 없는(비어있는) 채팅 메시지 생성
        for chunk in response:
            if chunk:
                answer += chunk
                st.markdown(answer)
    st.session_state.messages.append({'role': 'assistant', 'content': answer})



if __name__ == '__main__':
    main()