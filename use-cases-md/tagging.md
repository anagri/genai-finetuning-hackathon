# Tagging

[![Open In Collab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/langchain-ai/langchain/blob/master/docs/extras/use_cases/tagging.ipynb)

## Use case

Tagging means labeling a document with classes such as:

- sentiment
- language
- style (formal, informal etc.)
- covered topics
- political tendency

![Image description](/img/tagging.png)

## Overview

Tagging has a few components:

* `function`: Like [extraction](/docs/use_cases/extraction), tagging uses [functions](https://openai.com/blog/function-calling-and-other-api-updates) to specify how the model should tag a document
* `schema`: defines how we want to tag the document

## Quickstart

Let's see a very straightforward example of how we can use OpenAI functions for tagging in LangChain.


```python
!pip install langchain openai 

# Set env var OPENAI_API_KEY or load from a .env file:
# import dotenv
# dotenv.load_env()
```


```python
from langchain.chat_models import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from langchain.chains import create_tagging_chain, create_tagging_chain_pydantic
```

We specify a few properties with their expected type in our schema.


```python
# Schema
schema = {
    "properties": {
        "sentiment": {"type": "string"},
        "aggressiveness": {"type": "integer"},
        "language": {"type": "string"},
    }
}

# LLM
llm = ChatOpenAI(temperature=0, model="gpt-3.5-turbo-0613")
chain = create_tagging_chain(schema, llm)
```


```python
inp = "Estoy increiblemente contento de haberte conocido! Creo que seremos muy buenos amigos!"
chain.run(inp)
```


```python
inp = "Estoy muy enojado con vos! Te voy a dar tu merecido!"
chain.run(inp)
```

As we can see in the examples, it correctly interprets what we want.

The results vary so that we get, for example, sentiments in different languages ('positive', 'enojado' etc.).

We will see how to control these results in the next section.

## Finer control

Careful schema definition gives us more control over the model's output. 

Specifically, we can define:

- possible values for each property
- description to make sure that the model understands the property
- required properties to be returned

Here is an example of how we can use `_enum_`, `_description_`, and `_required_` to control for each of the previously mentioned aspects:


```python
schema = {
    "properties": {
        "aggressiveness": {
            "type": "integer",
            "enum": [1, 2, 3, 4, 5],
            "description": "describes how aggressive the statement is, the higher the number the more aggressive",
        },
        "language": {
            "type": "string",
            "enum": ["spanish", "english", "french", "german", "italian"],
        },
    },
    "required": ["language", "sentiment", "aggressiveness"],
}
```


```python
chain = create_tagging_chain(schema, llm)
```

Now the answers are much better!


```python
inp = "Estoy increiblemente contento de haberte conocido! Creo que seremos muy buenos amigos!"
chain.run(inp)
```


```python
inp = "Estoy muy enojado con vos! Te voy a dar tu merecido!"
chain.run(inp)
```


```python
inp = "Weather is ok here, I can go outside without much more than a coat"
chain.run(inp)
```

The [LangSmith trace](https://smith.langchain.com/public/311e663a-bbe8-4053-843e-5735055c032d/r) lets us peek under the hood:

* As with [extraction](/docs/use_cases/extraction), we call the `information_extraction` function [here](https://github.com/langchain-ai/langchain/blob/269f85b7b7ffd74b38cd422d4164fc033388c3d0/libs/langchain/langchain/chains/openai_functions/extraction.py#L20) on the input string.
* This OpenAI funtion extraction information based upon the provided schema.

![Image description](/img/tagging_trace.png)

## Pydantic

We can also use a Pydantic schema to specify the required properties and types. 

We can also send other arguments, such as `enum` or `description`, to each field.

This lets us specify our schema in the same manner that we would a new class or function in Python with purely Pythonic types.


```python
from enum import Enum
from pydantic import BaseModel, Field
```


```python
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


```python
chain = create_tagging_chain_pydantic(Tags, llm)
```


```python
inp = "Estoy muy enojado con vos! Te voy a dar tu merecido!"
res = chain.run(inp)
```


```python
res
```

### Going deeper

* You can use the [metadata tagger](https://python.langchain.com/docs/integrations/document_transformers/openai_metadata_tagger) document transformer to extract metadata from a LangChain `Document`. 
* This covers the same basic functionality as the tagging chain, only applied to a LangChain `Document`.
