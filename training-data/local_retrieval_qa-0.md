Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, install the packages needed for local embeddings and vector storage, and then load and split an example document using the WebBaseLoader.

### Response:
```python
!pip install gpt4all
!pip install chromadb

from langchain.document_loaders import WebBaseLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter

loader = WebBaseLoader("https://wikipedia.org/wiki/Python_(programming_language)")
data = loader.load()

text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=0)
all_splits = text_splitter.split_documents(data)
```
---
