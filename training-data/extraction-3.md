Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Create a Pydantic data class for movie properties then create an extraction chain using the create_extraction_chain_pydantic function.

### Response:
```python
from typing import Optional, List
from pydantic import BaseModel, Field

# Pydantic data class
class MovieProperties(BaseModel):
    movie_name: str
    director: str
    actors: List[str]
    release_date: str
        
# Extraction
chain = create_extraction_chain_pydantic(pydantic_schema=MovieProperties, llm=llm)

# Run 
inp = "The movie The Dark Knight was directed by Christopher Nolan with actors including Christian Bale, Heath Ledger, and Aaron Eckhart and was released in 2008."

chain.run(inp)
```