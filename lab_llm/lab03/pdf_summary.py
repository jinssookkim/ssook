# pdf 파일에서 헤더/푸터를 제외한 텍스트를 추출하고, GPT API를 이용해서 요약하기

import pymupdf
import os
from openai import OpenAI
from src.utils import get_openai_api_key


def pdf_to_txt(pdf_file, *, x=0.0, y=0.0, header_height=80, footer_height=80):
    with pymupdf.open(pdf_file) as doc:
        full_txt = ''
        for page in doc:
            rect = page.rect
            clip = (x, y+header_height, rect.width, rect.height-footer_height)

            text = page.get_text(clip=clip)
            full_txt += text
            full_txt += '\n' + '-' * 50 + '\n'

    # full_text에 저장된 문자열을 txt 파일에 저장
    base_name = os.path.basename(pdf_file)  # 폴더(디렉토리) 경로를 제외한 파일 이름만 리턴
    file_name = os.path.splitext(base_name)[0]  # 파일 이름을 원소로 갖는 리스트 (ex. ['sample', 'pdf'])
    txt_file = f'./output/{file_name}.txt'  # 추출한 텍스트를 저장할 파일 경로

    with open(txt_file, mode='w', encoding='utf-8') as f:
        f.write(full_txt)

    return txt_file


def summarize_txt(txt_file):
    """
    txt 파일을 읽고, GPT API를 이용해서 텍스트 요약을 수행. GPT의 답변을 리턴
    """
    with open(txt_file, mode='r', encoding='utf-8') as f:
        txt = f.read()

    prompt = f'''
        너는 문서를 요약하는 비서야.
        아래의 글을 읽고 저자의 주장과 근거를 요약해줘.
        작성해야 하는 포맷은 다음과 같아.
        # 제목
        ## 논문의 목적(5문장 이내)
        ## 논문 요약(10문장 이내)
        ## 저자 소개
        ## 참고문헌

        ========= 이하 텍스트 ========

        {txt}
        '''

    client = OpenAI(api_key=get_openai_api_key())

    answer = client.chat.completions.create(
        model='gpt-5.4-mini',
        messages=[{'role': 'system', 'content': prompt}],
        temperature=0.5
    )

    return answer.choices[0].message.content


def main():
    file_path = './data/sample.pdf'
    txt_file = pdf_to_txt(file_path)
    response = summarize_txt(txt_file)
    print(response)


if __name__ == '__main__':
    main()

