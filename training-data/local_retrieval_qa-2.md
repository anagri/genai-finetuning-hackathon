Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Download and set up embeddings locally.

### Response:
```python
from langchain.vectorstores import Chroma
from langchain.embeddings import GPT4AllEmbeddings

vectorstore = Chroma.from_documents(documents=all_splits, embedding=GPT4AllEmbeddings())
```