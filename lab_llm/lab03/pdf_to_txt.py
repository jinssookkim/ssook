import pymupdf
import os


def main():
    print('현재 작업 디렉토리:', os.getcwd())  # CWD(Current Working Directory)
    # 원본 pdf 파일의 경로
    pdf_file = './data/sample.pdf'   # 상대 경로
    print('절대 경로:', os.path.abspath(pdf_file))  # abspath: 절대 경로(absolute path)
    print('폴더 이름:', os.path.dirname(pdf_file))  # 파일이 있는 폴더의 상대 경로
    print('파일 이름:', os.path.basename(pdf_file))  # 파일 이름

    # PDF 파일에서 추출한 텍스트를 저장할 파일 경로
    txt_file = './output/sample_1.txt'

    # PyMuPDF 패키지의 기능을 이용해서 pdf 파일에서 텍스트를 추출
    with pymupdf.open(pdf_file) as doc:
        # pdf 문서에서 한 페이지씩 추출한 텍스트를 저장할 변수
        full_text = ''
        for page in doc:  # PyMuPDF 모듈의 document 객체를 for 반복문에서 사용하면 page의 데이터를 긁어옴
            full_text  += page.get_text()  # 페이지 객체에서 텍스트만 추출
            full_text += '\n\n' + '-' * 50 + '\n'   # 페이지 구분 위한 문자열
        print(full_text)

    # pdf에서 추출한 텍스트를 txt 파일로 저장
    with open(txt_file, mode='w', encoding='utf-8') as f:
        f.write(full_text)


if __name__ == '__main__':
    main()