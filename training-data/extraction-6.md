### Instruction:
Use the langchain library to extract specific attributes of a book, such as the book title, author, and number of pages.

### Response:
```python
schema = {
    "properties": {
        "title": {"type": "string"},
        "author": {"type": "string"},
        "pages": {"type": "integer"},
    },
    "required": ["title", "author", "pages"],
}

# Input 
inp = "The book 'To Kill a Mockingbird' was written by Harper Lee and has 324 pages."

# Run chain
chain = create_extraction_chain(schema, llm)
chain.run(inp)
```