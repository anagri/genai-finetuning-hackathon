Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Write a function using the python langchain library to apply inputs of context and topic to the LLM chain for text generation.

### Response:
```python
def generate_text(topic):
    docs = search_index.similarity_search(topic, k=4)
    inputs = [{"context": doc.page_content, "topic": topic} for doc in docs]
    return chain.apply(inputs)
```
---
