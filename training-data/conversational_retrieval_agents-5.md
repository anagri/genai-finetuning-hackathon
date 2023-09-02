Below is an instruction that describes a task. Write a response that appropriately completes the request.

6.
### Instruction:
Create a conversational retrieval agent with the language model and tools, and test it with 'Hello LangChain'.

### Response:
```python
agent_executor = create_conversational_retrieval_agent(llm, tools, verbose=True)
result = agent_executor({"input": "Hello LangChain"})
print(result["output"])
```