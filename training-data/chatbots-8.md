Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Use the langchain library to add intelligence to your chatbot so it can retrieve accurate information while holding a conversation.

### Response:
```python
from langchain.chat_models import ChatOpenAI
from langchain.chains import ConversationalRetrievalChain

llm = ChatOpenAI()
retriever = vectorstore.as_retriever()
qa = ConversationalRetrievalChain.from_llm(llm, retriever=retriever, memory=memory)
qa("How do agents use Task decomposition?")
```
---
