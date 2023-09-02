Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, interact with a SQL Database using sql agents created with the 'ChatOpenAI' model and get description of specific 'playlisttrack' table.

### Response:
```python
from langchain.agents import create_sql_agent
from langchain.agents.agent_toolkits import SQLDatabaseToolkit
from langchain.llms import OpenAI
from langchain.utilities import SQLDatabase

# Initialize the database 
db = SQLDatabase.from_uri("sqlite:///Chinook.db")

# Create sql agent
agent_executor = create_sql_agent(
    llm=OpenAI(temperature=0),
    toolkit=SQLDatabaseToolkit(db=db, llm=OpenAI(temperature=0)),
    verbose=True,
)

# Obtaining description of the 'playlisttrack' table
response = agent_executor.run("Describe the playlisttrack table")
```
---
