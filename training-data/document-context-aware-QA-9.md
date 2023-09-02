### Instruction:
Build a vector store using documents segmented by top headers in a Markdown document.

### Response:
```python
from langchain.text_splitter import MarkdownHeaderTextSplitter

headers_to_split_on = [
    ("#", "MainHeader"),
]
markdown_splitter = MarkdownHeaderTextSplitter(headers_to_split_on=headers_to_split_on)
md_mainheader_splits = markdown_splitter.split_text(md_file)

from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma

vectorstore = Chroma.from_documents(documents=md_mainheader_splits, embedding=OpenAIEmbeddings())
```