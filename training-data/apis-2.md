Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Interact with The Movie Database (TMDb) API to search for movies related to 'Interstellar' using langchain.

### Response:
```python
import os
os.environ['TMDB_BEARER_TOKEN'] = "" # Your TMDb Bearer Token
from langchain.chains.api import tmdb_docs
headers = {"Authorization": f"Bearer {os.environ['TMDB_BEARER_TOKEN']}"}
chain = APIChain.from_llm_and_api_docs(llm, tmdb_docs.TMDB_DOCS, headers=headers, verbose=True)
chain.run("Search for 'Interstellar'")
```