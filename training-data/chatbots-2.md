Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Setup a memory system using ConversationBufferMemory from the langchain library for your chatbot.

### Response:
```python
from langchain.memory import ConversationBufferMemory

memory = ConversationBufferMemory()
memory.chat_memory.add_user_message("hi!")
memory.chat_memory.add_ai_message("whats up?")
memory.load_memory_variables({})
```
---
