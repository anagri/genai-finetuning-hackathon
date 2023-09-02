Below is an instruction that describes a task. Write a response that appropriately completes the request.

5.
### Instruction:
Setup a language model for your agent with a temperature setting of 0.8.

### Response:
```python
from langchain.chat_models import ChatOpenAI
llm = ChatOpenAI(temperature = 0.8)
```