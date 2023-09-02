Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, create an extraction model that extracts different parts from a user query related to a short story, specifically the conflicted character, setting, and resolution of the conflict.

### Response:
```python
import os
from langchain.chat_models import ChatOpenAI
from langchain.chains import create_extraction_chain

# Set API Key
os.environ["OPENAI_API_KEY"] = 'your-openai-key'

# Schema
schema = {
    "properties": {
        "conflicted_character": {"type": "string"},
        "setting": {"type": "string"},
        "resolution": {"type": "string"},
    },
    "required": ["conflicted_character", "setting", "resolution"]
}

# Input 
inp = """In a small village in England, John, a kind-hearted farmer was always in conflict with his greed. One day, he found a treasure in his field. He donated all his wealth to the village and lived happily ever after."""

# Run chain
llm = ChatOpenAI(temperature=0, model="gpt-3.5-turbo")
chain = create_extraction_chain(schema, llm)
chain.run(inp)
```
---
