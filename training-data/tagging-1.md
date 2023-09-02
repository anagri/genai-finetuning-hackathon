Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, control tagging results by defining possible values for each property.

### Response:

```python
from langchain.chat_models import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from langchain.chains import create_tagging_chain

# Schema
schema = {
    "properties": {
        "sentiment": {"type": "string", "enum": ["happy", "neutral", "sad"]},
        "language": {"type": "string", "enum": ["english", "french", "german", "italian", "spanish"]},
    },
    "required": ["sentiment", "language"],
}

# LLM
llm = ChatOpenAI(temperature=0, model="gpt-3.5-turbo-0613")
chain = create_tagging_chain(schema, llm)

inp = "Estoy increiblemente contento de haberte conocido! Creo que seremos muy buenos amigos!"
result = chain.run(inp)
print(result)
```
---
