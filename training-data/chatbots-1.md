Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Make an API call to the chat model to translate "I love programming" from English to French.

### Response:
```python
from langchain.schema import HumanMessage
from langchain.chat_models import ChatOpenAI

chat = ChatOpenAI()
chat([HumanMessage(content="Translate this sentence from English to French: I love programming.")])
```