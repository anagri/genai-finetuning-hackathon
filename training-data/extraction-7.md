Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Use a Pydantic data class to parse information about a pizza, such as size, type, and extra toppings.

### Response:
```python
class Pizza(BaseModel):
    pizza_size: str
    pizza_type: str
    extra_toppings: Optional[List[str]]

class Pizzas(BaseModel):
    """Identifying information about pizza orders in a text."""
    pizzas: Sequence[Pizza]

# Run 
order = "The customer ordered a large pepperoni pizza with extra cheese and olives."

# Set up a parser + inject instructions into the prompt template.
parser = PydanticOutputParser(pydantic_object=Pizzas)

# Prompt
prompt = PromptTemplate(
    template="Answer the user query.\n{format_instructions}\n{query}\n",
    input_variables=["query"],
    partial_variables={"format_instructions": parser.get_format_instructions()},
)

# Run
_input = prompt.format_prompt(query=order)
model = OpenAI(temperature=0)
output = model(_input.to_string())
parser.parse(output)
```