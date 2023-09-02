Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Add "hi!" and "what's up?" to the ConversationBufferMemory.

### Response:
```python
from langchain.memory import ConversationBufferMemory

memory = ConversationBufferMemory()
memory.chat_memory.add_user_message("hi!")
memory.chat_memory.add_ai_message("whats up?")
```