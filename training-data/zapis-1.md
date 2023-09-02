### Instruction:
Use the langchain library to fetch product details from 'https://www.amazon.com/' for the query 'men's large blue button down shirt'.
### Response:
```python
from langchain.chains.openai_functions.openapi import get_openapi_chain
chain = get_openapi_chain("https://www.amazon.com/")
chain("What are some options for a men's large blue button down shirt")
```

### Instruction:
Generate interface to interact with the external API for 'https://weather.com' and get current temperature in Munich, Germany in Fahrenheit.
### Response:
```python
from langchain.llms import OpenAI
from langchain.chains import APIChain
llm = OpenAI(temperature=0)
chain = APIChain.from_llm_and_api_docs(llm, weather_com_docs, verbose=True)
chain.run('What is the weather like right now in Munich, Germany in degrees Fahrenheit?')
```

### Instruction:
Interact with 'https://www.wikipedia.org/' API using OpenAPI functions to fetch information about 'Albert Einstein'.
### Response:
```python
from langchain.chains.openai_functions.openapi import get_openapi_chain
chain = get_openapi_chain("https://www.wikipedia.org/")
chain("Get information about Albert Einstein")
```

### Instruction:
Generate an API request in natural language using langchain for the API 'https://newsapi.org/' to return latest news articles about 'Python Programming'.
### Response:
```python
from langchain.llms import OpenAI
from langchain.chains import APIChain
llm = OpenAI(temperature=0)
chain = APIChain.from_llm_and_api_docs(llm, newsapi_docs, verbose=True)
chain.run("Get the latest news articles about 'Python Programming'")
```

### Instruction:
Use langchain to interact with 'https://api.nasa.gov/' to get information about latest discoveries.
### Response:
```python
from langchain.chains.openai_functions.openapi import get_openapi_chain
chain = get_openapi_chain("https://api.nasa.gov/")
chain("Latest discoveries by NASA")
```

### Instruction:
Interact with 'https://api.coinbase.com/' API using the langchain library to get current price of Bitcoin.
### Response:
```python
from langchain.llms import OpenAI
from langchain.chains import APIChain
llm = OpenAI(temperature=0)
chain = APIChain.from_llm_and_api_docs(llm, coinbase_api_docs, verbose=True)
chain.run('What is the current price of Bitcoin?')
```

### Instruction:
Generate an interface to fetch weather details from 'https://api.weatherapi.com/' for the city 'New York'.
### Response:
```python
from langchain.llms import OpenAI
from langchain.chains import APIChain
llm = OpenAI(temperature=0)
chain = APIChain.from_llm_and_api_docs(llm, weatherapi_docs, verbose=True)
chain.run('What is the weather like right now in New York, USA in degrees Fahrenheit?')
```

### Instruction:
Fetch the current time for the timezone 'America/Los_Angeles' using langchain from 'https://worldtimeapi.org/'.
### Response:
```python
from langchain.chains.openai_functions.openapi import get_openapi_chain
chain = get_openapi_chain("https://worldtimeapi.org/")
chain("Current time for the timezone 'America/Los_Angeles'")
```

### Instruction:
Use langchain library to fetch details about 'Interstellar' movie from 'https://www.themoviedb.org/'.
### Response:
```python
from langchain.llms import OpenAI
from langchain.chains import APIChain
llm = OpenAI(temperature=0)
chain = APIChain.from_llm_and_api_docs(llm, tmdb_docs, verbose=True)
chain.run("Search for 'Interstellar' movie")
```

### Instruction:
Fetch profile details of the user named 'johndoe' from 'https://api.github.com/' using langchain.
### Response:
```python
from langchain.chains.openai_functions.openapi import get_openapi_chain
chain = get_openapi_chain("https://api.github.com/")
chain("Profile details for user 'johndoe'")
```