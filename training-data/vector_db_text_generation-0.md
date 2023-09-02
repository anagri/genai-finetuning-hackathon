### Instruction:
Pull the Python documentation from the Langchain GitHub repository and split them into smaller data chunks.

### Response:
```python
sources = get_github_docs("Langchain", "Python-Docs")
source_chunks = []
for source in sources:
    for chunk in splitter.split_text(source.page_content):
        source_chunks.append(Document(page_content=chunk, metadata=source.metadata))
```