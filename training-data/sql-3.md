Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Create a query based on a user question "How many products are there"

### Response:
```python
from langchain.chat_models import ChatOpenAI
from langchain.chains import create_sql_query_chain

chain = create_sql_query_chain(ChatOpenAI(temperature=0), db)
response = chain.invoke({"question":"How many products are there"})
print(response)
```