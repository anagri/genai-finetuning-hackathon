Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, parse the output of language model for a joke including setup and punchline fields by creating a custom pydantic class.

### Response:
```python
from typing import Optional, List
from pydantic import BaseModel, Field
from langchain.prompts import PromptTemplate
from langchain.llms import OpenAI
from langchain.output_parsers import PydanticOutputParser

# Pydantic data class
class JokeSchema(BaseModel):
    setup: str = Field(description="setup of the joke")
    punchline: str = Field(description="punchline of the joke")
    
# Parser
parser = PydanticOutputParser(pydantic_object=JokeSchema)

# Prompt
prompt = PromptTemplate(
    template="Tell a joke.\n{format_instructions}\n",
    partial_variables={"format_instructions": parser.get_format_instructions()},
)

# Run model
joke_query = "Tell me a joke."
_input = prompt.format_prompt(query=joke_query)
model = OpenAI(temperature=0)
output = model(_input.to_string())
parser.parse(output)
```
---
