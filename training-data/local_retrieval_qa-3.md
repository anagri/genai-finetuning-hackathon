Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction: 
Perform a similarity search using the local embeddings and a sample query.

### Response:
```python
question = "What are the different types of Natural language processing?"
docs = vectorstore.similarity_search(question)
```