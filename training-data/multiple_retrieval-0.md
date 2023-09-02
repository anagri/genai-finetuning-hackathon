Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Retrieve specified data simultaneously from a MongoDB database and a local JSON file using LangChain, then combine the retrieved results to form a response.

### Response:
```python
from langchain.chat_models import ChatOpenAI
from langchain.utilities import MongoDBDatabase
from langchain.chains import create_mongo_query_chain
from langchain.indexes import VectorstoreIndexCreator
from langchain.schema.document import Document
from langchain.prompts import ChatPromptTemplate

# Mongo Database setup
db = MongoDBDatabase.from_uri("your mongoDB uri")
query_chain = create_mongo_query_chain(ChatOpenAI(temperature=0), db)

# VectorStore Setup
index_creator = VectorstoreIndexCreator()
index = index_creator.from_json('example.json')
retriever = index.vectorstore.as_retriever()

# Prompt setup
system_message = """
Use the information from the below two sources to answer any questions.

Source 1: a MongoDB database about customer data
<source1>
{source1}
</source1>

Source 2: a JSON database of product data
<source2>
{source2}
</source2>
"""
prompt = ChatPromptTemplate.from_messages([("system", system_message), ("human", "{question}")])

# Chaining_prompt_setup_and_execution
full_chain = {
    "source1": {"question": lambda x: x["question"]} | query_chain | db.run,
    "source2": (lambda x: x['question']) | retriever,
    "question": lambda x: x['question'],
} | prompt | ChatOpenAI()

response = full_chain.invoke({"question":"Who is the customer with the highest purchase?"})
print(response)
```