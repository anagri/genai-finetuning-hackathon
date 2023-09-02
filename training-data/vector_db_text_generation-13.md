Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Use python's langchain library to index document chunks using a vector store.

### Response:
```python
from langchain.vectorstores import Chroma
from langchain.embeddings.openai import OpenAIEmbeddings

# Assuming 'source_chunks' is a list of document chunks
search_index = Chroma.from_documents(source_chunks, OpenAIEmbeddings())
```
---
