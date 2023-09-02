Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, query a SQLite database named `Chinook.db` and get the total number of employees in the database.

### Response:
```python
from langchain.utilities import SQLDatabase
from langchain.llms import OpenAI
from langchain_experimental.sql import SQLDatabaseChain

# Initializing the SQLite database
db = SQLDatabase.from_uri("sqlite:///Chinook.db")

# Initializing the OpenAI model
llm = OpenAI(temperature=0, verbose=True)

# Creating an SQLDatabaseChain instance
db_chain = SQLDatabaseChain.from_llm(llm, db, verbose=True)

# Querying the database
result = db_chain.run("How many employees are there?")
```
---
