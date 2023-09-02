# Perform context-aware text splitting

Text splitting for vector storage often uses sentences or other delimiters [to keep related text together](https://www.pinecone.io/learn/chunking-strategies/). 

But many documents (such as `Markdown` files) have structure (headers) that can be explicitly used in splitting. 

The `MarkdownHeaderTextSplitter` lets a user split `Markdown` files files based on specified headers. 

This results in chunks that retain the header(s) that it came from in the metadata.

This works nicely w/ `SelfQueryRetriever`.

First, tell the retriever about our splits.

Then, query based on the doc structure (e.g., "summarize the doc introduction"). 

Chunks only from that section of the Document will be filtered and used in chat / Q+A.

Let's test this out on an [example Notion page](https://rlancemartin.notion.site/Auto-Evaluation-of-Metadata-Filtering-18502448c85240828f33716740f9574b?pvs=4)!

First, I download the page to Markdown as explained [here](https://python.langchain.com/docs/ecosystem/integrations/notion).


```python
# Load Notion page as a markdownfile file
from langchain.document_loaders import NotionDirectoryLoader

path = "../Notion_DB/"
loader = NotionDirectoryLoader(path)
docs = loader.load()
md_file = docs[0].page_content
```


```python
# Let's create groups based on the section headers in our page
from langchain.text_splitter import MarkdownHeaderTextSplitter

headers_to_split_on = [
    ("###", "Section"),
]
markdown_splitter = MarkdownHeaderTextSplitter(headers_to_split_on=headers_to_split_on)
md_header_splits = markdown_splitter.split_text(md_file)
```

Now, perform text splitting on the header grouped documents. 


```python
# Define our text splitter
from langchain.text_splitter import RecursiveCharacterTextSplitter

chunk_size = 500
chunk_overlap = 0
text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=chunk_size, chunk_overlap=chunk_overlap
)
all_splits = text_splitter.split_documents(md_header_splits)
```

This sets us up well do perform metadata filtering based on the document structure.

Let's bring this all togther by building a vectorstore first.


```python
! pip install chromadb
```


```python
# Build vectorstore and keep the metadata
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma

vectorstore = Chroma.from_documents(documents=all_splits, embedding=OpenAIEmbeddings())
```

Let's create a `SelfQueryRetriever` that can filter based upon metadata we defined.


```python
# Create retriever
from langchain.llms import OpenAI
from langchain.retrievers.self_query.base import SelfQueryRetriever
from langchain.chains.query_constructor.base import AttributeInfo

# Define our metadata
metadata_field_info = [
    AttributeInfo(
        name="Section",
        description="Part of the document that the text comes from",
        type="string or list[string]",
    ),
]
document_content_description = "Major sections of the document"

# Define self query retriver
llm = OpenAI(temperature=0)
retriever = SelfQueryRetriever.from_llm(
    llm, vectorstore, document_content_description, metadata_field_info, verbose=True
)
```

We can see that we can query *only for texts* in the `Introduction` of the document!


```python
# Test
retriever.get_relevant_documents("Summarize the Introduction section of the document")
```


```python
# Test
retriever.get_relevant_documents("Summarize the Introduction section of the document")
```

We can also look at other parts of the document.


```python
retriever.get_relevant_documents("Summarize the Testing section of the document")
```

Now, we can create chat or Q+A apps that are aware of the explict document structure. 

The ability to retain document structure for metadata filtering can be helpful for complicated or longer documents.


```python
from langchain.chains import RetrievalQA
from langchain.chat_models import ChatOpenAI

llm = ChatOpenAI(model_name="gpt-3.5-turbo", temperature=0)
qa_chain = RetrievalQA.from_chain_type(llm, retriever=retriever)
qa_chain.run("Summarize the Testing section of the document")
```
