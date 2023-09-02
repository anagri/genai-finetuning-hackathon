Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Use ConversationSummaryMemory to store a brief summary of a conversation, and then load this memory.

### Response:
```python
from langchain.llms import OpenAI
from langchain.memory import ConversationSummaryMemory

llm = OpenAI(temperature=0)
memory = ConversationSummaryMemory(llm=llm)
memory.save_context({"input": "hi"}, {"output": "whats up"})
memory.save_context({"input": "im working on better docs for chatbots"}, {"output": "oh, that sounds like a lot of work"})
memory.load_memory_variables({})
```