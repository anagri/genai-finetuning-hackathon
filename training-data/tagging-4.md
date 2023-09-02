### Instruction:
Enhance your schema by defining possible values (enum), a description, and required properties for each of the properties: aggressiveness and language.

### Response:
```python
schema = {
    "properties": {
        "aggressiveness": {
            "type": "integer",
            "enum": [1, 2, 3, 4, 5],
            "description": "describes how aggressive the statement is, the higher the number the more aggressive",
        },
        "language": {
            "type": "string",
            "enum": ["spanish", "english", "french", "german", "italian"],
        },
     },
    "required": ["language", "sentiment", "aggressiveness"],
}

chain = create_tagging_chain(schema, llm)
```