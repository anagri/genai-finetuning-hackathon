# Extraction

[![Open In Collab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/langchain-ai/langchain/blob/master/docs/extras/use_cases/extraction.ipynb)

## Use case

Getting structured output from raw LLM generations is hard.

For example, suppose you need the model output formatted with a specific schema for:

- Extracting a structured row to insert into a database 
- Extracting API parameters
- Extracting different parts of a user query (e.g., for semantic vs keyword search)


![Image description](/img/extraction.png)

## Overview 

There are two primary approaches for this:

- `Functions`: Some LLMs can call [functions](https://openai.com/blog/function-calling-and-other-api-updates) to extract arbitrary entities from LLM responses.

- `Parsing`: [Output parsers](/docs/modules/model_io/output_parsers/) are classes that structure LLM responses. 

Only some LLMs support functions (e.g., OpenAI), and they are more general than parsers. 

Parsers extract precisely what is enumerated in a provided schema (e.g., specific attributes of a person).

Functions can infer things beyond of a provided schema (e.g., attributes about a person that you did not ask for).

## Quickstart

OpenAI funtions are one way to get started with extraction.

Define a schema that specifies the properties we want to extract from the LLM output.

Then, we can use `create_extraction_chain` to extract our desired schema using an OpenAI function call.


```python
pip install langchain openai 

# Set env var OPENAI_API_KEY or load from a .env file:
# import dotenv
# dotenv.load_env()
```


```python
from langchain.chat_models import ChatOpenAI
from langchain.chains import create_extraction_chain

# Schema
schema = {
    "properties": {
        "name": {"type": "string"},
        "height": {"type": "integer"},
        "hair_color": {"type": "string"},
    },
    "required": ["name", "height"],
}

# Input 
inp = """Alex is 5 feet tall. Claudia is 1 feet taller Alex and jumps higher than him. Claudia is a brunette and Alex is blonde."""

# Run chain
llm = ChatOpenAI(temperature=0, model="gpt-3.5-turbo")
chain = create_extraction_chain(schema, llm)
chain.run(inp)
```

## Option 1: OpenAI funtions

### Looking under the hood

Let's dig into what is happening when we call `create_extraction_chain`.

The [LangSmith trace](https://smith.langchain.com/public/72bc3205-7743-4ca6-929a-966a9d4c2a77/r) shows that we call the function `information_extraction` on the input string, `inp`.

![Image description](/img/extraction_trace_function.png)

This `information_extraction` function is defined [here](https://github.com/langchain-ai/langchain/blob/master/libs/langchain/langchain/chains/openai_functions/extraction.py) and returns a dict.

We can see the `dict` in the model output:
```
 {
      "info": [
        {
          "name": "Alex",
          "height": 5,
          "hair_color": "blonde"
        },
        {
          "name": "Claudia",
          "height": 6,
          "hair_color": "brunette"
        }
      ]
    }
```

The `create_extraction_chain` then parses the raw LLM output for us using [`JsonKeyOutputFunctionsParser`](https://github.com/langchain-ai/langchain/blob/f81e613086d211327b67b0fb591fd4d5f9a85860/libs/langchain/langchain/chains/openai_functions/extraction.py#L62).

This results in the list of JSON objects returned by the chain above:
```
[{'name': 'Alex', 'height': 5, 'hair_color': 'blonde'},
 {'name': 'Claudia', 'height': 6, 'hair_color': 'brunette'}]
 ```

### Multiple entity types

We can extend this further.

Let's say we want to differentiate between dogs and people.

We can add `person_` and `dog_` prefixes for each property


```python
schema = {
    "properties": {
        "person_name": {"type": "string"},
        "person_height": {"type": "integer"},
        "person_hair_color": {"type": "string"},
        "dog_name": {"type": "string"},
        "dog_breed": {"type": "string"},
    },
    "required": ["person_name", "person_height"],
}

chain = create_extraction_chain(schema, llm)

inp = """Alex is 5 feet tall. Claudia is 1 feet taller Alex and jumps higher than him. Claudia is a brunette and Alex is blonde.
Alex's dog Frosty is a labrador and likes to play hide and seek."""

chain.run(inp)
```

### Unrelated entities

If we use `required: []`, we allow the model to return **only** person attributes or **only** dog attributes for a single entity (person or dog).


```python
schema = {
    "properties": {
        "person_name": {"type": "string"},
        "person_height": {"type": "integer"},
        "person_hair_color": {"type": "string"},
        "dog_name": {"type": "string"},
        "dog_breed": {"type": "string"},
    },
    "required": [],
}

chain = create_extraction_chain(schema, llm)

inp = """Alex is 5 feet tall. Claudia is 1 feet taller Alex and jumps higher than him. Claudia is a brunette and Alex is blonde.
Willow is a German Shepherd that likes to play with other dogs and can always be found playing with Milo, a border collie that lives close by."""

chain.run(inp)
```

### Extra information

The power of functions (relative to using parsers alone) lies in the ability to perform sematic extraction.

In particular, `we can ask for things that are not explictly enumerated in the schema`.

Suppose we want unspecified additional information about dogs. 

We can use add a placeholder for unstructured extraction, `dog_extra_info`.


```python
schema = {
    "properties": {
        "person_name": {"type": "string"},
        "person_height": {"type": "integer"},
        "person_hair_color": {"type": "string"},
        "dog_name": {"type": "string"},
        "dog_breed": {"type": "string"},
        "dog_extra_info": {"type": "string"},
    },
}

chain = create_extraction_chain(schema, llm)
chain.run(inp)
```

This gives us additional information about the dogs.

### Pydantic 

Pydantic is a data validation and settings management library for Python. 

It allows you to create data classes with attributes that are automatically validated when you instantiate an object.

Lets define a class with attributes annotated with types.


```python
from typing import Optional, List
from pydantic import BaseModel, Field
from langchain.chains import create_extraction_chain_pydantic

# Pydantic data class
class Properties(BaseModel):
    person_name: str
    person_height: int
    person_hair_color: str
    dog_breed: Optional[str]
    dog_name: Optional[str]
        
# Extraction
chain = create_extraction_chain_pydantic(pydantic_schema=Properties, llm=llm)

# Run 
inp = """Alex is 5 feet tall. Claudia is 1 feet taller Alex and jumps higher than him. Claudia is a brunette and Alex is blonde."""
chain.run(inp)
```

As we can see from the [trace](https://smith.langchain.com/public/fed50ae6-26bb-4235-a254-e0b7a229d10f/r), we use the function `information_extraction`, as above, with the Pydantic schema. 

## Option 2: Parsing

[Output parsers](/docs/modules/model_io/output_parsers/) are classes that help structure language model responses. 

As shown above, they are used to parse the output of the OpenAI function calls in `create_extraction_chain`.

But, they can be used independent of functions.

### Pydantic

Just as a above, let's parse a generation based on a Pydantic data class.


```python
from typing import Sequence
from langchain.prompts import (
    PromptTemplate,
    ChatPromptTemplate,
    HumanMessagePromptTemplate,
)
from langchain.llms import OpenAI
from pydantic import BaseModel, Field, validator
from langchain.output_parsers import PydanticOutputParser

class Person(BaseModel):
    person_name: str
    person_height: int
    person_hair_color: str
    dog_breed: Optional[str]
    dog_name: Optional[str]

class People(BaseModel):
    """Identifying information about all people in a text."""
    people: Sequence[Person]

        
# Run 
query = """Alex is 5 feet tall. Claudia is 1 feet taller Alex and jumps higher than him. Claudia is a brunette and Alex is blonde."""

# Set up a parser + inject instructions into the prompt template.
parser = PydanticOutputParser(pydantic_object=People)

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

We can see from the [LangSmith trace](https://smith.langchain.com/public/8e3aa858-467e-46a5-aa49-5db65f0a2b9a/r) that we get the same output as above.

![Image description](/img/extraction_trace_function_2.png)

We can see that we provide a two-shot prompt in order to instruct the LLM to output in our desired format.

And, we need to do a bit more work:

* Define a class that holds multiple instances of `Person`
* Explicty parse the output of the LLM to the Pydantic class

We can see this for other cases, too.


```python
from langchain.prompts import (
    PromptTemplate,
    ChatPromptTemplate,
    HumanMessagePromptTemplate,
)
from langchain.llms import OpenAI
from pydantic import BaseModel, Field, validator
from langchain.output_parsers import PydanticOutputParser

# Define your desired data structure.
class Joke(BaseModel):
    setup: str = Field(description="question to set up a joke")
    punchline: str = Field(description="answer to resolve the joke")

    # You can add custom validation logic easily with Pydantic.
    @validator("setup")
    def question_ends_with_question_mark(cls, field):
        if field[-1] != "?":
            raise ValueError("Badly formed question!")
        return field

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

As we can see, we get an output of the `Joke` class, which respects our originally desired schema: 'setup' and 'punchline'.

We can look at the [LangSmith trace](https://smith.langchain.com/public/69f11d41-41be-4319-93b0-6d0eda66e969/r) to see exactly what is going on under the hood.

![Image description](/img/extraction_trace_joke.png)

### Going deeper

* The [output parser](/docs/modules/model_io/output_parsers/) documentation includes various parser examples for specific types (e.g., lists, datetimne, enum, etc).  
* [JSONFormer](/docs/integrations/llms/jsonformer_experimental) offers another way for structured decoding of a subset of the JSON Schema.
* [Kor](https://eyurtsev.github.io/kor/) is another library for extraction where schema and examples can be provided to the LLM.
