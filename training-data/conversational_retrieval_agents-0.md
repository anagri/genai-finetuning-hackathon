Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, load a text document "novel.txt" and split it into chunks of size 5000 with an overlap of 1000. Then, create an OpenAI embeddings for these chunks and store these embeddings in a FAISS vectorstore. Finally, convert it into a retriever.

### Response:
```python
from langchain.document_loaders import TextLoader
from langchain.text_splitter import CharacterTextSplitter
from langchain.vectorstores import FAISS
from langchain.embeddings import OpenAIEmbeddings

# Load novel.txt
loader = TextLoader('novel.txt')
documents = loader.load()

# Split documents into chunks
text_splitter = CharacterTextSplitter(chunk_size=5000, chunk_overlap=1000)
texts = text_splitter.split_documents(documents)

# Create OpenAI embeddings and FAISS vector-store
embeddings = OpenAIEmbeddings()
db = FAISS.from_documents(texts, embeddings)

# Convert to retriever
retriever = db.as_retriever()
```
---
