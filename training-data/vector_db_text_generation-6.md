Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the Langchain vector store, perform a similarity search for content related to the topic of "Object-Oriented Programming".

### Response:
```python
docs = search_index.similarity_search("Object-Oriented Programming", k=3)
inputs = [{"context": doc.page_content, "topic": "Object-Oriented Programming"} for doc in docs]
print(chain.apply(inputs))
```