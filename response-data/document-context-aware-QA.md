---
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, split a markdown file content into sections based on the specified headers and store these sections for later retrieval.

### Response:
```python
# Import required dependencies
from langchain.document_loaders import NotionDirectoryLoader
from langchain.text_splitter import MarkdownHeaderTextSplitter, RecursiveCharacterTextSplitter

# Load Markdown File
path = "../Markdown_Files_Path/"
loader = NotionDirectoryLoader(path)
docs = loader.load()
md_file = docs[0].page_content

# Define headers to split on
headers_to_split_on = [("###", "Section")]
markdown_splitter = MarkdownHeaderTextSplitter(headers_to_split_on=headers_to_split_on)

# Split the text based on headers
md_header_splits = markdown_splitter.split_text(md_file)

# Split the text into chunks
chunk_size = 500
chunk_overlap = 0
text_splitter = RecursiveCharacterTextSplitter(chunk_size=chunk_size, chunk_overlap=chunk_overlap)
all_splits = text_splitter.split_documents(md_header_splits)
```

---

---
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

---
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, initialise a SelfQueryRetriever that can filter based on the metadata of the document.

### Response:
```python
# Import required dependencies
from langchain.llms import OpenAI
from langchain.retrievers.self_query.base import SelfQueryRetriever
from langchain.chains.query_constructor.base import AttributeInfo

# Define the metadata for the retriever
metadata_field_info = [
    AttributeInfo(
        name="Section",
        description="Part of the document that the text comes from",
        type="string or list[string]",
    ),
]
document_content_description = "Major sections of the document"

# Initialise the retriever
llm = OpenAI(temperature=0)
retriever = SelfQueryRetriever.from_llm(
    llm, vectorstore, document_content_description, metadata_field_info, verbose=True
)
```

---
