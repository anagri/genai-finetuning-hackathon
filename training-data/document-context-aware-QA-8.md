Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Run an interactive session with the chat application, querying the document structure using langchain.

### Response:
```python
from langchain.chains import RetrievalQAInteractive

interactive_chat = RetrievalQAInteractive.from_chain_type(llm, retriever=retriever)
interactive_chat.run()
```