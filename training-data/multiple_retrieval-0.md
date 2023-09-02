Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, write a Python code to do a retrieval over two information sources, an SQL database, and a Vectorstore, concerning employee data and random text information respectively. You also need to parallelize this retrieval followed by a ChatOpenAI model invocation using the retrieved info.

### Response:
```python
# Importing necessary classes
from langchain.chat_models import ChatOpenAI
from langchain.utilities import SQLDatabase
from langchain.chains import create_sql_query_chain
from langchain.indexes import VectorstoreIndexCreator
from langchain.schema.document import Document
from langchain.prompts import ChatPromptTemplate

# Setup SQL query
db = SQLDatabase.from_uri("sqlite:///../../../../../notebooks/Chinook.db")
query_chain = create_sql_query_chain(ChatOpenAI(temperature=0), db)

# Setup vectorstore
index_creator = VectorstoreIndexCreator()
index = index_creator.from_documents([Document(page_content="Foo")])
retriever = index.vectorstore.as_retriever()

# Combine the sources
system_message = """Use the information from the below two sources to answer any questions.

Source 1: a SQL database about employee data
<source1>
{source1}
</source1>

Source 2: a text database of random information
<source2>
{source2}
</source2>
"""

prompt = ChatPromptTemplate.from_messages([("system", system_message), ("human", "{question}")])

# Link the chains and invoke the model
full_chain = {
    "source1": {"question": lambda x: x["question"]} | query_chain | db.run,
    "source2": (lambda x: x['question']) | retriever,
    "question": lambda x: x['question'],
} | prompt | ChatOpenAI()

response = full_chain.invoke({"question": "How many Employees are there"})
print(response)
```
---
