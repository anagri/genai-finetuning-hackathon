Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Build a chat application that fetches relevant data from the "Results" subsection of the document when asked for information relevant to results using langchain.

### Response:
```python
from langchain.chains import RetrievalQA
from langchain.chat_models import ChatOpenAI

llm = ChatOpenAI(model_name="gpt-3.5-turbo", temperature=0)
qa_chain = RetrievalQA.from_chain_type(llm, retriever=retriever)
qa_chain.run("Give me information from the Results subsection of the document")
```