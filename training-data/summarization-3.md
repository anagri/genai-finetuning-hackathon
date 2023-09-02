### Instruction:
Create a StuffDocumentsChain for summarizing the documents.

### Response:
```python
stuff_chain = StuffDocumentsChain(
    llm_chain=llm_chain, document_variable_name="text"
)
result = stuff_chain.run(docs)
```