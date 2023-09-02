# SQL

[![Open In Collab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/langchain-ai/langchain/blob/master/docs/extras/use_cases/sql.ipynb)

## Use case

Enterprise data is often stored in SQL databases.

LLMs make it possible to interact with SQL databases using natural langugae.

LangChain offers SQL Chains and Agents to build and run SQL queries based on natural language prompts. 

These are compatible with any SQL dialect supported by SQLAlchemy (e.g., MySQL, PostgreSQL, Oracle SQL, Databricks, SQLite).

They enable use cases such as:

- Generating queries that will be run based on natural language questions
- Creating chatbots that can answer questions based on database data
- Building custom dashboards based on insights a user wants to analyze

## Overview

LangChain provides tools to interact with SQL Databases:

1. `Build SQL queries` based on natural language user questions
2. `Query a SQL database` using chains for query creation and execution
3. `Interact with a SQL database` using agents for robust and flexible querying 

![sql_usecase.png](/img/sql_usecase.png)

## Quickstart

First, get required packages and set environment variables:


```python
! pip install langchain langchain-experimental openai

# Set env var OPENAI_API_KEY or load from a .env file
# import dotenv

# dotenv.load_env()
```

The below example will use a SQLite connection with Chinook database. 
 
Follow [installation steps](https://database.guide/2-sample-databases-sqlite/) to create `Chinook.db` in the same directory as this notebook:

* Save [this file](https://raw.githubusercontent.com/lerocha/chinook-database/master/ChinookDatabase/DataSources/Chinook_Sqlite.sql) to the directory as `Chinook_Sqlite.sql`
* Run `sqlite3 Chinook.db`
* Run `.read Chinook_Sqlite.sql`
* Test `SELECT * FROM Artist LIMIT 10;`

Now, `Chinhook.db` is in our directory.

Let's create a `SQLDatabaseChain` to create and execute SQL queries.


```python
from langchain.utilities import SQLDatabase
from langchain.llms import OpenAI
from langchain_experimental.sql import SQLDatabaseChain

db = SQLDatabase.from_uri("sqlite:///Chinook.db")
llm = OpenAI(temperature=0, verbose=True)
db_chain = SQLDatabaseChain.from_llm(llm, db, verbose=True)
```


```python
db_chain.run("How many employees are there?")
```

Note that this both creates and executes the query. 

In the following sections, we will cover the 3 different use cases mentioned in the overview.

### Go deeper

You can load tabular data from other sources other than SQL Databases.
For example:
- [Loading a CSV file](/docs/integrations/document_loaders/csv)
- [Loading a Pandas DataFrame](/docs/integrations/document_loaders/pandas_dataframe)
Here you can [check full list of Document Loaders](/docs/integrations/document_loaders/)

## Case 1: Text-to-SQL query



```python
from langchain.chat_models import ChatOpenAI
from langchain.chains import create_sql_query_chain
```

Let's create the chain that will build the SQL Query:



```python
chain = create_sql_query_chain(ChatOpenAI(temperature=0), db)
response = chain.invoke({"question":"How many employees are there"})
print(response)
```

After building the SQL query based on a user question, we can execute the query:


```python
db.run(response)
```

As we can see, the SQL Query Builder chain **only created** the query, and we handled the **query execution separately**.

### Go deeper

**Looking under the hood**

We can look at the [LangSmith trace](https://smith.langchain.com/public/c8fa52ea-be46-4829-bde2-52894970b830/r) to unpack this:

[Some papers](https://arxiv.org/pdf/2204.00498.pdf) have reported good performance when prompting with:
 
* A `CREATE TABLE` description for each table, which include column names, their types, etc
* Followed by three example rows in a `SELECT` statement

`create_sql_query_chain` adopts this the best practice (see more in this [blog](https://blog.langchain.dev/llms-and-sql/)).  
![sql_usecase.png](/img/create_sql_query_chain.png)

**Improvements**

The query builder can be improved in several ways, such as (but not limited to):

- Customizing database description to your specific use case
- Hardcoding a few examples of questions and their corresponding SQL query in the prompt
- Using a vector database to include dynamic examples that are relevant to the specific user question

All these examples involve customizing the chain's prompt. 

For example, we can include a few examples in our prompt like so:


```python
from langchain.prompts import PromptTemplate

TEMPLATE = """Given an input question, first create a syntactically correct {dialect} query to run, then look at the results of the query and return the answer.
Use the following format:

Question: "Question here"
SQLQuery: "SQL Query to run"
SQLResult: "Result of the SQLQuery"
Answer: "Final answer here"

Only use the following tables:

{table_info}.

Some examples of SQL queries that corrsespond to questions are:

{few_shot_examples}

Question: {input}"""

CUSTOM_PROMPT = PromptTemplate(
    input_variables=["input", "few_shot_examples", "table_info", "dialect"], template=TEMPLATE
)
```

## Case 2: Text-to-SQL query and execution

We can use `SQLDatabaseChain` from `langchain_experimental` to create and run SQL queries.


```python
from langchain.llms import OpenAI
from langchain_experimental.sql import SQLDatabaseChain

llm = OpenAI(temperature=0, verbose=True)
db_chain = SQLDatabaseChain.from_llm(llm, db, verbose=True)
```


```python
db_chain.run("How many employees are there?")
```

As we can see, we get the same result as the previous case.

Here, the chain **also handles the query execution** and provides a final answer based on the user question and the query result.

**Be careful** while using this approach as it is susceptible to `SQL Injection`:

* The chain is executing queries that are created by an LLM, and weren't validated
* e.g. records may be created, modified or deleted unintentionally_

This is why we see the `SQLDatabaseChain` is inside `langchain_experimental`.

### Go deeper

**Looking under the hood**

We can use the [LangSmith trace](https://smith.langchain.com/public/7f202a0c-1e35-42d6-a84a-6c2a58f697ef/r) to see what is happening under the hood:

* As discussed above, first we create the query:

```
text: ' SELECT COUNT(*) FROM "Employee";'
```

* Then, it executes the query and passes the results to an LLM for synthesis.

![sql_usecase.png](/img/sqldbchain_trace.png)

**Improvements**

The performance of the `SQLDatabaseChain` can be enhanced in several ways:

- [Adding sample rows](#adding-sample-rows)
- [Specifying custom table information](/docs/integrations/tools/sqlite#custom-table-info)
- [Using Query Checker](/docs/integrations/tools/sqlite#use-query-checker) self-correct invalid SQL using parameter `use_query_checker=True`
- [Customizing the LLM Prompt](/docs/integrations/tools/sqlite#customize-prompt) include specific instructions or relevant information, using parameter `prompt=CUSTOM_PROMPT`
- [Get intermediate steps](/docs/integrations/tools/sqlite#return-intermediate-steps) access the SQL statement as well as the final result using parameter `return_intermediate_steps=True`
- [Limit the number of rows](/docs/integrations/tools/sqlite#choosing-how-to-limit-the-number-of-rows-returned) a query will return using parameter `top_k=5`

You might find [SQLDatabaseSequentialChain](/docs/integrations/tools/sqlite#sqldatabasesequentialchain)
useful for cases in which the number of tables in the database is large.

This `Sequential Chain` handles the process of:

1. Determining which tables to use based on the user question
2. Calling the normal SQL database chain using only relevant tables

**Adding Sample Rows**

Providing sample data can help the LLM construct correct queries when the data format is not obvious. 

For example, we can tell LLM that artists are saved with their full names by providing two rows from the Track table.



```python
db = SQLDatabase.from_uri(
    "sqlite:///Chinook.db",
    include_tables=['Track'], # we include only one table to save tokens in the prompt :)
    sample_rows_in_table_info=2)
```

The sample rows are added to the prompt after each corresponding table's column information.

We can use `db.table_info` and check which sample rows are included:


```python
print(db.table_info)
```

## Case 3: SQL agents

LangChain has an SQL Agent which provides a more flexible way of interacting with SQL Databases than the `SQLDatabaseChain`.

The main advantages of using the SQL Agent are:

- It can answer questions based on the databases' schema as well as on the databases' content (like describing a specific table)
- It can recover from errors by running a generated query, catching the traceback and regenerating it correctly

To initialize the agent, we use `create_sql_agent` function. 

This agent contains the `SQLDatabaseToolkit` which contains tools to: 

* Create and execute queries
* Check query syntax
* Retrieve table descriptions
* ... and more


```python
from langchain.agents import create_sql_agent
from langchain.agents.agent_toolkits import SQLDatabaseToolkit
# from langchain.agents import AgentExecutor
from langchain.agents.agent_types import AgentType

db = SQLDatabase.from_uri("sqlite:///Chinook.db")
llm = OpenAI(temperature=0, verbose=True)

agent_executor = create_sql_agent(
    llm=OpenAI(temperature=0),
    toolkit=SQLDatabaseToolkit(db=db, llm=OpenAI(temperature=0)),
    verbose=True,
    agent_type=AgentType.ZERO_SHOT_REACT_DESCRIPTION,
)
```

### Agent task example #1 - Running queries



```python
agent_executor.run(
    "List the total sales per country. Which country's customers spent the most?"
)
```

Looking at the [LangSmith trace](https://smith.langchain.com/public/a86dbe17-5782-4020-bce6-2de85343168a/r), we can see:

* The agent is using a ReAct style prompt
* First, it will look at the tables: `Action: sql_db_list_tables` using tool `sql_db_list_tables`
* Given the tables as an observation, it `thinks` and then determinates the next `action`:

```
Observation: Album, Artist, Customer, Employee, Genre, Invoice, InvoiceLine, MediaType, Playlist, PlaylistTrack, Track
Thought: I should query the schema of the Invoice and Customer tables.
Action: sql_db_schema
Action Input: Invoice, Customer
```

* It then formulates the query using the schema from tool `sql_db_schema`

```
Thought: I should query the total sales per country.
Action: sql_db_query
Action Input: SELECT Country, SUM(Total) AS TotalSales FROM Invoice INNER JOIN Customer ON Invoice.CustomerId = Customer.CustomerId GROUP BY Country ORDER BY TotalSales DESC LIMIT 10
```

* It finally executes the generated query using tool `sql_db_query`

![sql_usecase.png](/img/SQLDatabaseToolkit.png)

### Agent task example #2 - Describing a Table


```python
agent_executor.run("Describe the playlisttrack table")
```

### Go deeper

To learn more about the SQL Agent and how it works we refer to the [SQL Agent Toolkit](/docs/integrations/toolkits/sql_database) documentation.

You can also check Agents for other document types:
- [Pandas Agent](/docs/integrations/toolkits/pandas.html)
- [CSV Agent](/docs/integrations/toolkits/csv.html)

## Elastic Search

Going beyond the above use-case, there are integrations with other databases.

For example, we can interact with Elasticsearch analytics database. 

This chain builds search queries via the Elasticsearch DSL API (filters and aggregations).

The Elasticsearch client must have permissions for index listing, mapping description and search queries.

See [here](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html) for instructions on how to run Elasticsearch locally.

Make sure to install the Elasticsearch Python client before:

```sh
pip install elasticsearch
```


```python
from elasticsearch import Elasticsearch
from langchain.chat_models import ChatOpenAI
from langchain.chains.elasticsearch_database import ElasticsearchDatabaseChain
```


```python
# Initialize Elasticsearch python client.
# See https://elasticsearch-py.readthedocs.io/en/v8.8.2/api.html#elasticsearch.Elasticsearch
ELASTIC_SEARCH_SERVER = "https://elastic:pass@localhost:9200"
db = Elasticsearch(ELASTIC_SEARCH_SERVER)
```

Uncomment the next cell to initially populate your db.


```python
# customers = [
#     {"firstname": "Jennifer", "lastname": "Walters"},
#     {"firstname": "Monica","lastname":"Rambeau"},
#     {"firstname": "Carol","lastname":"Danvers"},
#     {"firstname": "Wanda","lastname":"Maximoff"},
#     {"firstname": "Jennifer","lastname":"Takeda"},
# ]
# for i, customer in enumerate(customers):
#     db.create(index="customers", document=customer, id=i)
```


```python
llm = ChatOpenAI(model_name="gpt-4", temperature=0)
chain = ElasticsearchDatabaseChain.from_llm(llm=llm, database=db, verbose=True)
```


```python
question = "What are the first names of all the customers?"
chain.run(question)
```

We can customize the prompt.


```python
from langchain.chains.elasticsearch_database.prompts import DEFAULT_DSL_TEMPLATE
from langchain.prompts.prompt import PromptTemplate

PROMPT_TEMPLATE = """Given an input question, create a syntactically correct Elasticsearch query to run. Unless the user specifies in their question a specific number of examples they wish to obtain, always limit your query to at most {top_k} results. You can order the results by a relevant column to return the most interesting examples in the database.

Unless told to do not query for all the columns from a specific index, only ask for a the few relevant columns given the question.

Pay attention to use only the column names that you can see in the mapping description. Be careful to not query for columns that do not exist. Also, pay attention to which column is in which index. Return the query as valid json.

Use the following format:

Question: Question here
ESQuery: Elasticsearch Query formatted as json
"""

PROMPT = PromptTemplate.from_template(
    PROMPT_TEMPLATE,
)
chain = ElasticsearchDatabaseChain.from_llm(llm=llm, database=db, query_prompt=PROMPT)
```
