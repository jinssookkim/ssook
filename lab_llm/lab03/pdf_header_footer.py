import pymupdf


def main():
    pdf_file = './data/sample.pdf'  # 원본 pdf파일
    txt_file = './output/sample_2.txt'  # pdf에서 헤더와 푸터를 제외한 텍스트를 저장할 파일 경로
    header_height = 80  # pdf 파일 헤더의 높이(세로 길이)
    footer_height = 80  # pdf 파일 푸터의 높이
    full_text = '' # pdf파일에서 추출한 텍스트를 저장하기 위한 문자열 변수
    with pymupdf.open(pdf_file) as doc:
        for page in doc:
            rect = page.rect  # rect(좌상단 x좌표, 좌상단 y좌표, 우하단 x좌표, 우하단 y좌표)
            # print(rect)
            # print(rect.width, rect.height)
            # pdf 파일에서 잘라낼 영역(헤더와 푸터를 제외하고 텍스트를 추출할 영역)
            clip = (0.0, header_height, rect.width, rect.height-footer_height)
            # 잘려진 영역(clip) 안에서만 텍스트 추출
            text = page.get_text(clip=clip)
            # print(text)
            # print('\n' + '-' * 50 + '\n')
            full_text += text  # clip 안에서 추출한 텍스트를 full_text에 append
            full_text += '\n' + '-' * 50 + '\n'

    # clips 안에서 추출한 모든 텍스트를 txt_file에 씀
    with open(txt_file, mode='w', encoding='utf-8') as f:
        f.write(full_text)



if __name__ == '__main__':
    main()