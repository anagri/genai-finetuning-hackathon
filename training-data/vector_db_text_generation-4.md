Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Retrieve documents from the vector database that match a keyword and generate a short blog post about the keyword.

### Response:
```python
def generate_blog_post(topic):
    docs = search_index.similarity_search(topic, k=3)
    inputs = [{"context": doc.page_content, "topic": topic} for doc in docs]
    print(chain.apply(inputs))

generate_blog_post("function decorators")
```