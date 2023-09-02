Below is an instruction that describes a task. Write a response that appropriately completes the request.

2.
### Instruction:
Split the loaded documents into chunks of size 500 with an overlap of 50 characters between chunks with the help of langchain's text splitter.

### Response:
```python
from langchain.text_splitter import CharacterTextSplitter
text_splitter = CharacterTextSplitter(chunk_size=500, chunk_overlap=50)
texts = text_splitter.split_documents(documents)
```