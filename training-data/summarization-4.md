Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Generate a summary using the "map_reduce" method.

### Response:
```python
map_reduce_chain = MapReduceDocumentsChain(
    llm_chain=map_chain,
    reduce_documents_chain=reduce_documents_chain,
    document_variable_name="docs",
    return_intermediate_steps=False,
)
result = map_reduce_chain.run(split_docs)
```