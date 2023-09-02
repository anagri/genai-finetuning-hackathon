Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Expand the schema to differentiate between different types of movies such as action, romance etc.

### Response:
```python
schema = {
    "properties": {
        "action_movie_name": {"type": "string"},
        "action_director": {"type": "string"},
        "romance_movie_name": {"type": "string"},
        "romance_director": {"type": "string"},
    },
    "required": [],
}

chain = create_extraction_chain(schema, llm)

inp = "The action movie Mission Impossible was directed by Brian De Palma. The Notebook, a romance movie was directed by Nick Cassavetes."

chain.run(inp)
```