4.
### Instruction:
Create a retriever tool for langchain with a name 'search_my_document' and a description 'This searches and returns documents from my own document'

### Response:
```python
retriever = db.as_retriever()
tool = create_retriever_tool(retriever, 'search_my_document', 'This searches and returns documents from my own document')
tools = [tool]
```