import streamlit as st
import pandas as pd
import numpy as np
from numpy.random import default_rng as rng


# 웹 페이지에 텍스트 출력
st.write("""Streamlit supports a wide range of data visualizations, 
including [Plotly, Altair, and Bokeh charts](https://docs.streamlit.io/develop/api-reference/charts).
📊 And with over 20 input widgets, you can easily make your data interactive!""")

# 문자열(이름) 4개를 가지고 있는 list
all_users = ["숙진", "Alice", "Bob", "Charly"]

# container(box) 생성
with st.container(border=True):
    # container가 포함하는 요소들 생성
    users = st.multiselect("Users", all_users, default=all_users)
    rolling_average = st.toggle("Rolling average")  # 토글(on/off) 버튼

np.random.seed(42)

# 데이터프레임 생성
data = pd.DataFrame(np.random.randn(20, len(users)), columns=users)


# 토글 버튼의 동작 설정
if rolling_average:   # 토글 버튼이 on 상태일 때
    data = data.rolling(7).mean().dropna()

# 2개의 탭을 생성
tab1, tab2 = st.tabs(["Chart", "Dataframe"])

# 첫 번째 탭의 line chart를 출력
tab1.line_chart(data, height=250)
# 두 번째 탭의 dataframe을 출력
tab2.dataframe(data, height=250, width='stretch')  # width='stretch': tab크기만큼 가로길이를 전부 사용하겠다는 의미

