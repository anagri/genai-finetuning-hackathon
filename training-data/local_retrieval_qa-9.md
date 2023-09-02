### Instruction:
Use RetrievalQA chain for a simpler operation.

### Response:
```python
from langchain.chains import RetrievalQA

qa_chain = RetrievalQA.from_chain_type(
    llm,
    retriever=vectorstore.as_retriever(),
    chain_type_kwargs={"prompt": QA_CHAIN_PROMPT},
)

qa_chain({"query": question})
```