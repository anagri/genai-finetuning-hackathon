### Instruction:
Extract information about a car, such as the make, model, and color using the langchain library

### Response:
```python
schema = {
    "properties": {
        "car_make": {"type": "string"},
        "car_model": {"type": "string"},
        "car_color": {"type": "string"}
    },
    "required": ["car_make", "car_model", "car_color"],
}

# Input 
inp = "The car is a red Ferrari Enzo."

# Run chain
chain = create_extraction_chain(schema, llm)
chain.run(inp)
```