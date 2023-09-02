Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Create a model called Tags using Pydantic schema with similar properties as before. Enum variable and description variables should also be part of the schema fields.

### Response:
```python
from pydantic import BaseModel, Field

class Tags(BaseModel):
    sentiment: str = Field(..., enum=["happy", "neutral", "sad"])
    aggressiveness: int = Field(
        ...,
        description="describes how aggressive the statement is, the higher the number the more aggressive",
        enum=[1, 2, 3, 4, 5],
    )
    language: str = Field(
        ..., enum=["spanish", "english", "french", "german", "italian"]
    )
```