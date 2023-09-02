Below is an instruction that describes a task. Write a response that appropriately completes the request.

8.
### Instruction:
Setup a memory key 'history' and create a memory for the agent using langchain's `AgentTokenBufferMemory`.

### Response:
```python
memory_key = "history"
from langchain.agents.openai_functions_agent.agent_token_buffer_memory import AgentTokenBufferMemory
memory = AgentTokenBufferMemory(memory_key=memory_key, llm=llm)
```