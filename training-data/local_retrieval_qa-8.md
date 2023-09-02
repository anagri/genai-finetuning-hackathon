Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, create a vectorstore instance with documents for similarity search.

### Response:
```python
from langchain.vectorstores import MatrixStore
from langchain.embeddings import HNSWeddings

vectorstore = MatrixStore.from_documents(documents=all_splits, embedding=HNSWeddings())
```
---
