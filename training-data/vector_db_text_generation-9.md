Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the langchain library, fetch a certain topic from the vector index and generate a document using the retrieved documents as context.

### Response:
```python
def generate_document(topic):
    docs = search_index.similarity_search(topic, k=3)
    inputs = [{"context": doc.page_content, "topic": topic} for doc in docs]
    return chain.apply(inputs)

generate_document("socket programming")
```
---
