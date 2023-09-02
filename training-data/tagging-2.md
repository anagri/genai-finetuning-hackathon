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
