Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Store the document into a vector using the Chroma method from the langchain library.

### Response:
```python
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma

vectorstore = Chroma.from_documents(documents=all_splits, embedding=OpenAIEmbeddings())
```
---
