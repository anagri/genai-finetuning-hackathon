Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Connect to the SQLite database 'Test.db' and create an instance of the LangChain database object and its chain.

### Response:
```python
from langchain.utilities import SQLDatabase
from langchain.llms import OpenAI
from langchain_experimental.sql import SQLDatabaseChain

db = SQLDatabase.from_uri("sqlite:///Test.db")
llm = OpenAI(temperature=0, verbose=True)
db_chain = SQLDatabaseChain.from_llm(llm, db, verbose=True)
```