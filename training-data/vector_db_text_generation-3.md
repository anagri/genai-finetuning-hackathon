Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Use the python langchain library to set up a vector index from a list of documents.

### Response:
```python
from langchain.vectorstores import Chroma
from langchain.embeddings.openai import OpenAIEmbeddings

# Assuming 'source_chunks' is a list of documents
search_index = Chroma.from_documents(source_chunks, OpenAIEmbeddings())
```
---
