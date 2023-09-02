Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Create a query using langchain library to find podcast episodes related to 'OpenAI' that are more than 20 minutes long from ListenNotes API.

### Response:
```python
import os
from langchain.llms import OpenAI
from langchain.chains.api import podcast_docs
from langchain.chains import APIChain
 
listen_api_key = 'xxx' # Your ListenNotes API Key
llm = OpenAI(temperature=0)
headers = {"X-ListenAPI-Key": listen_api_key}
chain = APIChain.from_llm_and_api_docs(llm, podcast_docs.PODCAST_DOCS, headers=headers, verbose=True)
chain.run("Search for 'OpenAI' podcast episodes, audio length is more than 20 minutes, return only 1 results")
```