Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Create and run a SQL query using SQLDatabaseChain, for the question "What is the total sales amount?"

### Response:
```python
llm = OpenAI(temperature=0, verbose=True)
db_chain = SQLDatabaseChain.from_llm(llm, db, verbose=True)
db_chain.run("What is the total sales amount?")
```