Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Use the python langchain library to generate an informative blog post on a given topic using past articles as context.

### Response:
```python
def generate_blog_post(topic):
    docs = search_index.similarity_search(topic, k=4)
    inputs = [{"context": doc.page_content, "topic": topic} for doc in docs]
    return chain.apply(inputs)

generate_blog_post("python web scraping")
```
---
