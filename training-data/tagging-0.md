### Instruction:
Install the 'langchain' and 'openai' libraries and create an instance of a large language model for interaction, setting temperature to 0. 

### Response:
```python
!pip install langchain openai
from langchain.chat_models import ChatOpenAI

# LLM
llm = ChatOpenAI(temperature=0, model="gpt-3.5-turbo-0613")
```