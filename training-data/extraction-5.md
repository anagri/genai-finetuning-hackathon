### Instruction:
Create a Pydantic class for a single joke with 'setup' and 'punchline', then use the langchain library to parse the joke.

### Response:
```python
class Joke(BaseModel):
    setup: str = Field(description="question to set up a joke")
    punchline: str = Field(description="answer to resolve the joke")

# And a query intented to prompt a language model to populate the data structure.
joke_query = "Tell me a joke."

# Set up a parser + inject instructions into the prompt template.
parser = PydanticOutputParser(pydantic_object=Joke)

# Prompt
prompt = PromptTemplate(
    template="Answer the user query.\n{format_instructions}\n{query}\n",
    input_variables=["query"],
    partial_variables={"format_instructions": parser.get_format_instructions()},
)

# Run
_input = prompt.format_prompt(query=joke_query)
model = OpenAI(temperature=0)
output = model(_input.to_string())
parser.parse(output)
```