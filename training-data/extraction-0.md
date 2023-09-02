### Instruction:
Use the langchain library to create a schema for extracting information about a movie like the director's name, actors, and release date from a large language model.

### Response:
```python
schema = {
    "properties": {
        "movie_name": {"type": "string"},
        "director": {"type": "string"},
        "actors": {"type": "array"},
        "release_date": {"type": "string"},
    },
    "required": ["movie_name", "director"],
}

chain = create_extraction_chain(schema, llm)

inp = "The movie The Dark Knight was directed by Christopher Nolan with actors including Christian Bale, Heath Ledger, and Aaron Eckhart and was released in 2008."

chain.run(inp)
```