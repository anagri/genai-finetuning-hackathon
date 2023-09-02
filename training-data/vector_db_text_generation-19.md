Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Write a function to generate detailed product tutorials from a given topic and past tutorials as context, by employing the python langchain library.

### Response:
```python
def generate_tutorial(topic):
    docs = search_index.similarity_search(topic, k=3)
    inputs = [{"context": doc.page_content, "topic": topic} for doc in docs]
    return tutorial_chain.apply(inputs)

generate_tutorial("how to use language models")
```
---
