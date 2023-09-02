Below is an instruction that describes a task. Write a response that appropriately completes the request.

3.
### Instruction:
Embed the split texts for retrieving using langchain's OpenAIEmbeddings and create a database using FAISS from these texts and embeddings.

### Response:
```python
from langchain.vectorstores import FAISS
from langchain.embeddings import OpenAIEmbeddings

embeddings = OpenAIEmbeddings()
db = FAISS.from_documents(texts, embeddings)
```