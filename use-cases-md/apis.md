# Interacting with APIs

[![Open In Collab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/langchain-ai/langchain/blob/master/docs/extras/use_cases/apis.ipynb)

## Use case 

Suppose you want an LLM to interact with external APIs.

This can be very useful for retrieving context for the LLM to utilize.

And, more generally, it allows us to interact with APIs using natural langugage! 
 

## Overview

There are two primary ways to interface LLMs with external APIs:
 
* `Functions`: For example, [OpenAI functions](https://platform.openai.com/docs/guides/gpt/function-calling) is one popular means of doing this.
* `LLM-generated interface`: Use an LLM with access to API documentation to create an interface.

![Image description](/img/api_use_case.png)

## Quickstart 

Many APIs are already compatible with OpenAI function calling.

For example, [Klarna](https://www.klarna.com/international/press/klarna-brings-smoooth-shopping-to-chatgpt/) has a YAML file that describes its API and allows OpenAI to interact with it:

```
https://www.klarna.com/us/shopping/public/openai/v0/api-docs/
```

Other options include:

* [Speak](https://api.speak.com/openapi.yaml) for translation
* [XKCD](https://gist.githubusercontent.com/roaldnefs/053e505b2b7a807290908fe9aa3e1f00/raw/0a212622ebfef501163f91e23803552411ed00e4/openapi.yaml) for comics

We can supply the specification to `get_openapi_chain` directly in order to query the API with OpenAI functions:


```python
pip install langchain openai 

# Set env var OPENAI_API_KEY or load from a .env file:
# import dotenv
# dotenv.load_env()
```


```python
from langchain.chains.openai_functions.openapi import get_openapi_chain
chain = get_openapi_chain("https://www.klarna.com/us/shopping/public/openai/v0/api-docs/")
chain("What are some options for a men's large blue button down shirt")
```

## Functions 

We can unpack what is hapening when we use the functions to calls external APIs.

Let's look at the [LangSmith trace](https://smith.langchain.com/public/76a58b85-193f-4eb7-ba40-747f0d5dd56e/r):

* See [here](https://github.com/langchain-ai/langchain/blob/7fc07ba5df99b9fa8bef837b0fafa220bc5c932c/libs/langchain/langchain/chains/openai_functions/openapi.py#L279C9-L279C19) that we call the OpenAI LLM with the provided API spec:

```
https://www.klarna.com/us/shopping/public/openai/v0/api-docs/
```

* The prompt then tells the LLM to use the API spec wiith input question:

```
Use the provided API's to respond to this user query:
What are some options for a men's large blue button down shirt
```

* The LLM returns the parameters for the function call `productsUsingGET`, which is [specified in the provided API spec](https://www.klarna.com/us/shopping/public/openai/v0/api-docs/):
```
function_call:
  name: productsUsingGET
  arguments: |-
    {
      "params": {
        "countryCode": "US",
        "q": "men's large blue button down shirt",
        "size": 5,
        "min_price": 0,
        "max_price": 100
      }
    }
 ```
 
![Image description](/img/api_function_call.png)
 
* This `Dict` above split and the [API is called here](https://github.com/langchain-ai/langchain/blob/7fc07ba5df99b9fa8bef837b0fafa220bc5c932c/libs/langchain/langchain/chains/openai_functions/openapi.py#L215).

## API Chain 

We can also build our own interface to external APIs using the `APIChain` and provided API documentation.


```python
from langchain.llms import OpenAI
from langchain.chains import APIChain
from langchain.chains.api import open_meteo_docs
llm = OpenAI(temperature=0)
chain = APIChain.from_llm_and_api_docs(llm, open_meteo_docs.OPEN_METEO_DOCS, verbose=True)
chain.run('What is the weather like right now in Munich, Germany in degrees Fahrenheit?')
```

Note that we supply information about the API:


```python
open_meteo_docs.OPEN_METEO_DOCS[0:500]
```

Under the hood, we do two things:
    
* `api_request_chain`: Generate an API URL based on the input question and the api_docs
* `api_answer_chain`: generate a final answer based on the API response

We can look at the [LangSmith trace](https://smith.langchain.com/public/1e0d18ca-0d76-444c-97df-a939a6a815a7/r) to inspect this:

* The `api_request_chain` produces the API url from our question and the API documentation:

![Image description](/img/api_chain.png)

* [Here](https://github.com/langchain-ai/langchain/blob/bbd22b9b761389a5e40fc45b0570e1830aabb707/libs/langchain/langchain/chains/api/base.py#L82) we make the API request with the API url.
* The `api_answer_chain` takes the response from the API and provides us with a natural langugae response:

![Image description](/img/api_chain_response.png)

### Going deeper

**Test with other APIs**


```python
import os
os.environ['TMDB_BEARER_TOKEN'] = ""
from langchain.chains.api import tmdb_docs
headers = {"Authorization": f"Bearer {os.environ['TMDB_BEARER_TOKEN']}"}
chain = APIChain.from_llm_and_api_docs(llm, tmdb_docs.TMDB_DOCS, headers=headers, verbose=True)
chain.run("Search for 'Avatar'")
```


```python
import os
from langchain.llms import OpenAI
from langchain.chains.api import podcast_docs
from langchain.chains import APIChain
 
listen_api_key = 'xxx' # Get api key here: https://www.listennotes.com/api/pricing/
llm = OpenAI(temperature=0)
headers = {"X-ListenAPI-Key": listen_api_key}
chain = APIChain.from_llm_and_api_docs(llm, podcast_docs.PODCAST_DOCS, headers=headers, verbose=True)
chain.run("Search for 'silicon valley bank' podcast episodes, audio length is more than 30 minutes, return only 1 results")
```

**Web requests**

URL requets are such a common use-case that we have the `LLMRequestsChain`, which makes a HTTP GET request. 


```python
from langchain.llms import OpenAI
from langchain.prompts import PromptTemplate
from langchain.chains import LLMRequestsChain, LLMChain
```


```python
template = """Between >>> and <<< are the raw search result text from google.
Extract the answer to the question '{query}' or say "not found" if the information is not contained.
Use the format
Extracted:<answer or "not found">
>>> {requests_result} <<<
Extracted:"""

PROMPT = PromptTemplate(
    input_variables=["query", "requests_result"],
    template=template,
)
```


```python
chain = LLMRequestsChain(llm_chain=LLMChain(llm=OpenAI(temperature=0), prompt=PROMPT))
question = "What are the Three (3) biggest countries, and their respective sizes?"
inputs = {
    "query": question,
    "url": "https://www.google.com/search?q=" + question.replace(" ", "+"),
}
chain(inputs)
```
