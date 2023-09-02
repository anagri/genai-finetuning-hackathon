### Instruction:
Perform text splitting on the subsection grouped documents, with a chunk size of 300 and no chunk overlap, using langchain.

### Response:
```python
from langchain.text_splitter import RecursiveCharacterTextSplitter

chunk_size = 300
chunk_overlap = 0
text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=chunk_size, chunk_overlap=chunk_overlap
)
subsection_splits = text_splitter.split_documents(md_subsection_splits)
```