from openai import OpenAI

from src.utils import get_openai_api_key

openai_client = OpenAI(api_key=get_openai_api_key())
