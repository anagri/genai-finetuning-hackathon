Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Load a url "https://example.com/article-2.0.html" using the WebBaseLoader and summarize it using the "stuff" method.

### Response:
```python
loader = WebBaseLoader("https://example.com/article-2.0.html")
docs = loader.load()
chain = load_summarize_chain(llm, chain_type="stuff")
result = chain.run(docs)
```