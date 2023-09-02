### Instruction:
Add a placeholder to the schema for unstructured extraction, extra_movie_info.

### Response:
```python
schema = {
    "properties": {
        "movie_name": {"type": "string"},
        "director": {"type": "string"},
        "actors": {"type": "array"},
        "release_date": {"type": "string"},
        "extra_movie_info": {"type": "string"},
    },
}

chain = create_extraction_chain(schema, llm)
chain.run(inp)
```