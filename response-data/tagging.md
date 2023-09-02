---
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, analyze the sentiment and language of a given text.

### Response:

```python
from langchain.chat_models import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from langchain.chains import create_tagging_chain

# Schema
schema = {
    "properties": {
        "sentiment": {"type": "string"},
        "language": {"type": "string"},
    }
}

# LLM
llm = ChatOpenAI(temperature=0, model="gpt-3.5-turbo-0613")
chain = create_tagging_chain(schema, llm)

inp = "I am extremely happy to have met you! I think we will be very good friends!"
result = chain.run(inp)
print(result)
```

--- 

---
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

---
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, make use of Pydantic schema to specify the required properties and types for tagging a given text.

### Response:

```python
from langchain.chat_models import ChatOpenAI
from langchain.chains import create_tagging_chain_pydantic
from pydantic import BaseModel, Field

class Tags(BaseModel):
    sentiment: str = Field(..., enum=["happy", "neutral", "sad"])
    language: str = Field(..., enum=["english", "french", "german", "italian", "spanish"])

# LLM
llm = ChatOpenAI(temperature=0, model="gpt-3.5-turbo-0613")
chain = create_tagging_chain_pydantic(Tags, llm)

inp = "Je suis très content de t'avoir rencontré! Je pense que nous serons de très bons amis!"
result = chain.run(inp)
print(result)
```

--- 

(Note: Above steps are based on earlier use case documents and can be repeated with different instruction details and entity values)
