### Instruction:
Use the langchain library to make a function that will parse a generation based on a Pydantic data class.

### Response:
```python
from typing import Sequence
from pydantic import BaseModel, Field, validator
from langchain.output_parsers import PydanticOutputParser

class Movie(BaseModel):
    movie_name: str
    director: str
    actors: List[str]
    release_date: str

class Movies(BaseModel):
    """Identifying information about all movies in a text."""
    movies: Sequence[Movie]

# Run 
query = "The movie The Dark Knight was directed by Christopher Nolan with actors including Christian Bale, Heath Ledger, and Aaron Eckhart and was released in 2008."

# Set up a parser + inject instructions into the prompt template.
parser = PydanticOutputParser(pydantic_object=Movies)

# Prompt
prompt = PromptTemplate(
    template="Answer the user query.\n{format_instructions}\n{query}\n",
    input_variables=["query"],
    partial_variables={"format_instructions": parser.get_format_instructions()},
)

# Run
_input = prompt.format_prompt(query=query)
model = OpenAI(temperature=0)
output = model(_input.to_string())
parser.parse(output)
```