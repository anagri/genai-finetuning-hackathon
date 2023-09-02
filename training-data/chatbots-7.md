### Instruction:
Create a ConversationalRetrievalChain with loaded documents and ask a domain specific question to chatbot.

### Response:
```python
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.chains import ConversationalRetrievalChain

text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=0)
all_splits = text_splitter.split_documents(data)
vectorstore = Chroma.from_documents(documents=all_splits, embedding=OpenAIEmbeddings())
retriever = vectorstore.as_retriever()

qa = ConversationalRetrievalChain.from_llm(llm, retriever=retriever, memory=memory)

qa("What is supervised learning in machine learning?")
```