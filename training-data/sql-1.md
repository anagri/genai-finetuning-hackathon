Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, create a SQL query from a user question in natural language, "How many employees are there in the organization?".

### Response:
```python
from langchain.chat_models import ChatOpenAI
from langchain.chains import create_sql_query_chain
from langchain.utilities import SQLDatabase

# Initialize the database 
db = SQLDatabase.from_uri("sqlite:///Chinook.db")

# Create query chain
chain = create_sql_query_chain(ChatOpenAI(temperature=0), db)

# User question 
question = "How many employees are there in the organization?"

# Building the SQL query based on a user question
response = chain.invoke({"question": question})
sql_query = response
```
---
