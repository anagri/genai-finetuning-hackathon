Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Modify the previous chat interface from langchain library to remember past user inputs and model outputs by wrapping the chat model in a ConversationChain.

### Response:
```python
from langchain.chains import ConversationChain

conversation = ConversationChain(llm=chat)
conversation.run("Translate this sentence from English to French: I love programming.")
```
---
