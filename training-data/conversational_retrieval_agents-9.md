Below is an instruction that describes a task. Write a response that appropriately completes the request.

10.
### Instruction:
Create a new agent with the previously defined language model, tools and prompt using the OpenAIFunctionsAgent.

### Response:
```python
agent = OpenAIFunctionsAgent(llm=llm, tools=tools, prompt=prompt)
```