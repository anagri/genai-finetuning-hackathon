### Instruction:
Create an instance of ConversationChain and translate "I love programming" from English to French and then to German.

### Response:
```python
from langchain.chains import ConversationChain 

conversation = ConversationChain(llm=chat)
conversation.run("Translate this sentence from English to French: I love programming.")
conversation.run("Translate it to German.")
```