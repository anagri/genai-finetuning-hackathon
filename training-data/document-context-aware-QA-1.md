Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, create a vectorstore from the markdown documents and store the indexes and metadata for faster retrieval.

### Response:
```python
# Import the required classes
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma

# Create the vectorstore and build the index with metadata
vectorstore = Chroma.from_documents(documents=all_splits, embedding=OpenAIEmbeddings())
```
---
