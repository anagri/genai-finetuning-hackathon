### Instruction:
Create a MapReduceDocumentsChain with a customized LLMChain.

### Response:
```python
custom_llm_chain = LLMChain(llm=custom_llm, prompt=custom_prompt)
map_reduce_chain = MapReduceDocumentsChain(
    llm_chain=custom_llm_chain,
    reduce_documents_chain=reduce_documents_chain,
    document_variable_name="docs",
    return_intermediate_steps=False,
)
```