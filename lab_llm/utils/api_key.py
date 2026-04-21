import os
from dotenv import load_dotenv

def get_openai_api_key():
    # 프로젝트 폴더 아래에 있는 .env 파일의 내용을 읽어서 OS(운영체제) 환경 변수로 저장.
    load_dotenv()
    # OS 환경 변수에 저장된 값을 읽어옴
    api_key = os.getenv('OPENAI_API_KEY')

    return api_key



if __name__ == '__main__':
    key = get_openai_api_key()
    print(key)