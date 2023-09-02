Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Install required packages for document retrieval and load a sample document.

### Response:
```python
!pip install tiktoken chromadb

from langchain.document_loaders import WebBaseLoader

loader = WebBaseLoader("https://en.wikipedia.org/wiki/Machine_learning")
data = loader.load()
```