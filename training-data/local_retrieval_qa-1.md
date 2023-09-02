Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, download the embeddings locally and initialize `Chroma` from these documents.

### Response:
```python
from langchain.vectorstores import Chroma
from langchain.embeddings import GPT4AllEmbeddings

vectorstore = Chroma.from_documents(documents=all_splits, embedding=GPT4AllEmbeddings())
```
---
