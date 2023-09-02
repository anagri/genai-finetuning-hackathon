Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Execute a "refine" type summarization chain using the ChatOpenAI model.

### Response:
```python
chain = load_summarize_chain(llm, chain_type="refine")
result = chain.run(split_docs)
```