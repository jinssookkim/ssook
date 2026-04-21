from openai import OpenAI, api_key
import streamlit as st
from pyexpat.errors import messages
from streamlit import session_state

from src.utils import get_openai_api_key


def initialize_client():
    # OpenAI 객체를 생성하고 리턴하는 함수
    client = OpenAI(api_key=get_openai_api_key())
    return client


def get_gpt_response(client, msg):
    response = client.chat.completions.create(
        model='gpt-5.4-mini',
        messages=msg,
        temperature=0.9
    )
    return response.choices[0].message.content



def main():  # 화면이 갱신될 때마다 무한 반복되면서 실행
    client = initialize_client()

    # title 위젯 생성
    st.title("💗✨MIRROR-BOT🪞🎀 \n\n  ❤🤍for PRINCESS🤍❤ \n\n made by #1 princess: **:rainbow[jskim]**", text_alignment='center')


    # st.session_state: streamlit 앱이 실행될 때 계속 유지되어야 할 값들을 저장하는 객체
    # 일반적인 지역 변수들은 화면이 갱신될 때마다 초기화 됨. 따라서, 값들이 계속 유지되지 않음.
    # st.session_state는 값들을 마치 dict처럼 key-value 아이템으로 저장.
    # st.session_state['key'] = value 가능.
    # st.session_state.key = value 가능.
    # 'messages' 키가 st.session_state에 저장되어 있지 않으면, 메시지 프롬프트를 초기화
    if 'messages' not in st.session_state:
        # st.session_state['messages'] = [
        #     {'role': 'assistant', 'content': '무엇을 도와드릴까요?'}
        #     ]

        st.session_state.messages = [
            {'role': 'system', 'content': '너는 백설공주에 나오는 거울이야. 거울처럼 답변 해줘.'},
            {'role': 'assistant', 'content': '어서오세요, 공주님.'}
        ]

    # st.session_state에 저장된 리스트 messages에서 메시지(dict)를 하나씩 반복:
    for msg in st.session_state.messages:
        if msg['role'] == 'assistant':
        # 채팅 메시지 위젯 아이콘 설정, 내용을 markdown으로 출력
            st.chat_message(msg['role']).markdown(msg['content'])
        if msg['role'] == 'user':
            st.chat_message(msg['role']).markdown(msg['content'])
        else:
            pass

    # 사용자 입력창 위젯을 출력
    # user_input = st.chat_input('공주만 입력 가능')
    if user_input := st.chat_input('🎀공주(‍💃🏻)만 입력 가능🎀'):
        st.chat_message('user').markdown(user_input)

        st.session_state.messages.append({'role': 'user', 'content': user_input})

        # 메시지 리스트를 GPT 서버로 보내서 생성된 답변을 응답으로 받음
        answer = get_gpt_response(client=client, msg=st.session_state.messages)

        # AI 답변 채팅 메시지 위젯으로 출력
        st.chat_message('assistant').markdown(answer)

        # 리스트에 저장
        st.session_state.messages.append({'role': 'assistant', 'content': answer})



if __name__ == '__main__':
    main()

