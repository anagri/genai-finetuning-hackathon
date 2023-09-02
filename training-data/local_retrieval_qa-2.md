Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, run a similarity search on a given question using the previously initialized `Chroma` instance.

### Response:
```python
question = "What are Python decorators and how are they used?"
docs = vectorstore.similarity_search(question)
```
---
