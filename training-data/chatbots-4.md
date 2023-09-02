Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Extend your memory system from the LangChain library to create a summary of the conversation over time using ConversationSummaryMemory.

### Response:
```python
from langchain.llms import OpenAI
from langchain.memory import ConversationSummaryMemory

llm = OpenAI(temperature=0)
memory = ConversationSummaryMemory(llm=llm)
memory.save_context({"input": "hi"},{"output": "whats up"})
memory.save_context({"input": "im working on better docs for chatbots"},{"output": "oh, that sounds like a lot of work"})
memory.save_context({"input": "yes, but it's worth the effort"},{"output": "agreed, good docs are important!"})
memory.load_memory_variables({})
```
---
