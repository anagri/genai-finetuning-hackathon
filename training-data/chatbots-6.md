Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Combine chat with document retrieval from the LangChain library to chat with specific information that the model was not trained on.

### Response:
```python
!pip install tiktoken chromadb
from langchain.document_loaders import WebBaseLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter

loader = WebBaseLoader("https://lilianweng.github.io/posts/2023-06-23-agent/")
data = loader.load()
text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=0)
all_splits = text_splitter.split_documents(data)
```
---
