Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, interact with ListenNotes API for retrieving podcast information. The requirement is to search for 'AI in the Wild' podcast episodes, the episode audio length is more than 30 minutes and return only 3 results.

### Response:
```python
import os 
from langchain.llms import OpenAI
from langchain.chains.api import podcast_docs
from langchain.chains import APIChain

listen_api_key = 'your_listen_api_key' # Get api key here: https://www.listennotes.com/api/pricing/
headers = {"X-ListenAPI-Key": listen_api_key}
chain = APIChain.from_llm_and_api_docs(OpenAI(temperature=0), podcast_docs.PODCAST_DOCS, headers=headers, verbose=True)
result = chain("Search for 'AI in the Wild' podcast episodes, audio length is more than 30 minutes, return only 3 results")
print(result)
```
---
