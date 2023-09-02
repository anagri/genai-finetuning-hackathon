### Instruction:
Load a local Markdown file using langchain's document loader and print the contents of the file.

### Response:
```python
from langchain.document_loaders import LocalFileLoader

path = "../local_files/"
loader = LocalFileLoader(path)
docs = loader.load()
md_file = docs[0].page_content
print(md_file)
```