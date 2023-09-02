# Multiple Retrieval Sources

Often times you may want to do retrieval over multiple sources. These can be different vectorstores (where one contains information about topic X and the other contains info about topic Y). They could also be completely different databases altogether!

A key part is is doing as much of the retrieval in parrelel as possible. This will keep the latency as low as possible. Luckily, [LangChain Expression Language](../../) supports parrellism out of the box.

Let's take a look where we do retrieval over a SQL database and a vectorstore.


```python
from langchain.chat_models import ChatOpenAI
```

## Set up SQL query


```python
from langchain.utilities import SQLDatabase
from langchain.chains import create_sql_query_chain

db = SQLDatabase.from_uri("sqlite:///../../../../../notebooks/Chinook.db")
query_chain = create_sql_query_chain(ChatOpenAI(temperature=0), db)
```

## Set up vectorstore


```python
from langchain.indexes import VectorstoreIndexCreator
from langchain.schema.document import Document
index_creator = VectorstoreIndexCreator()
index = index_creator.from_documents([Document(page_content="Foo")])
retriever = index.vectorstore.as_retriever()
```

## Combine


```python
from langchain.prompts import ChatPromptTemplate

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
```


```python
full_chain = {
    "source1": {"question": lambda x: x["question"]} | query_chain | db.run,
    "source2": (lambda x: x['question']) | retriever,
    "question": lambda x: x['question'],
} | prompt | ChatOpenAI()
```


```python
response = full_chain.invoke({"question":"How many Employees are there"})
print(response)
```
