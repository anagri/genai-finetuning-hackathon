Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, interact with the XKCD API for retrieving comic information. The requirement is to use the Klarna API documentation provided at 'https://www.klarna.com/us/shopping/public/openai/v0/api-docs/' to specify to `get_openapi_chain`.

### Response:
```python
import openai  
from langchain.chains.openai_functions.openapi import get_openapi_chain
# Set env var OPENAI_API_KEY or load from a .env file:
openai.api_key = "your-api-key"  
chain = get_openapi_chain("https://www.klarna.com/us/shopping/public/openai/v0/api-docs/")
result = chain("Fetch the XKCD comic number 327")
print(result)
```
---
