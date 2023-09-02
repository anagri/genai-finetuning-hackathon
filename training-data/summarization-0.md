Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the Python langchain library, download a blog post from a given URL and use the library to summarize the blog post using the 'stuff' method.

### Response:
```python
!pip install openai tiktoken chromadb

from langchain.chat_models import ChatOpenAI
from langchain.document_loaders import WebBaseLoader
from langchain.chains.summarize import load_summarize_chain

loader = WebBaseLoader("https://your_blog_URL")
docs = loader.load()

llm = ChatOpenAI(temperature=0, model_name="gpt-3.5-turbo-16k")
chain = load_summarize_chain(llm, chain_type="stuff")

summary = chain.run(docs)
print(summary)
```
---
