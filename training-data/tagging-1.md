Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Create a tagging chain that will analyze a text based on three properties: sentiment, language, and aggressiveness level.

### Response:
```python
from langchain.chains import create_tagging_chain

# Schema
schema = {
    "properties": {
        "sentiment": {"type": "string"},
        "aggressiveness": {"type": "integer"},
        "language": {"type": "string"},
    }
}
chain = create_tagging_chain(schema, llm)
```