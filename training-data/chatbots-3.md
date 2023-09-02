Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the Langchain library, extend your memory system to keep a sliding window of the most recent `k` interactions using `ConversationBufferWindowMemory`.

### Response:
```python
from langchain.memory import ConversationBufferWindowMemory

memory = ConversationBufferWindowMemory(k=1)
memory.save_context({"input": "hi"}, {"output": "whats up"})
memory.save_context({"input": "not much you"}, {"output": "not much"})
memory.load_memory_variables({})
```
---
