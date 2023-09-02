Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Create a query using langchain library to know the temperature in London, UK using the Open Météo API.

### Response:
```python
from langchain.llms import OpenAI
from langchain.chains import APIChain
from langchain.chains.api import open_meteo_docs
llm = OpenAI(temperature=0)
chain = APIChain.from_llm_and_api_docs(llm, open_meteo_docs.OPEN_METEO_DOCS, verbose=True)
chain.run('What is the weather like right now in London, UK in degrees Fahrenheit?')
```