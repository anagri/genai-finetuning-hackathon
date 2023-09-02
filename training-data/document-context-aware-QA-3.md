Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Build a vector store and keep the metadata of each subsection document using an alternative language model embeddings, such as from Transformers library.

### Response:
```python
from langchain.embeddings import TransformerEmbeddings
from langchain.vectorstores import Chroma

vectorstore = Chroma.from_documents(documents=subsection_splits, embedding=TransformerEmbeddings('bert-base-uncased'))
```