import src.myutil1.addition  # addition 모듈을 import
import src.myutil1.addition as addition

# from ... import 구문
from src.myutil1.subtraction import minus
#> src.myutil1.subtraction 모듈(파일)에서 함수 minus를 import

# myutil2 패키지를 import
import src.myutil2 as util  # __init__에 함수 import가 작성되어 있기 때문에 패키지 폴더까지 짧게 import 가능

# __name__ 변수: 모든 파이썬 모듈(*.py 파일)이 가지고 있는 특별한 변수
# (1) 현재 작업중인 파일에서 실행할 때는 '__main__' 문자열이 할당됨.
# (2) 다른 파일에서 import될 때는 파일 (directory 경로) 이름이 할당됨.
# (목적) 단독으로 실행할 코드와 import될 때 실행할 코드를 구분하기 위해서

print(__name__)

# def minus(x):    # 현재 파일에서 같은 이름의 함수 만들면 import한 함수가 의미 없어지고 대체됨.
#     return -x

# def plus(x):   # 현재 파일에서 생성된 plus 함수
#     return x + 1

if __name__ == '__main__':
    print('hi')
    #result = src.myutil1.addition.plus(2, 3)  # 작성이 길어져 불편함
    result = addition.plus(3, 4)  # addition 파일의 plus 함수. 현재 파일에서 생성된 plus 함수와 이용 방법이 다름
    print(result)


    result = minus(3, 4)
    print(result)

    result = util.multiply(3, 4)  # util.multiplication.multiply()  <--- src.myutil까지만 import했을 경우 써야 하는 패키지 함수
    print(result)

    result = util.divide(1, 5)
    print(result)