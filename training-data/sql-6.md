### Instruction:
Initialize the SQL agent with temperature 0 and run the agent with the question "List the total sales per region. Which region's customers spent the most?"

### Response:
```python
db = SQLDatabase.from_uri("sqlite:///Chinook.db")
llm = OpenAI(temperature=0, verbose=True)

agent_executor = create_sql_agent(
    llm=OpenAI(temperature=0),
    toolkit=SQLDatabaseToolkit(db=db, llm=OpenAI(temperature=0)),
    verbose=True,
    agent_type=AgentType.ZERO_SHOT_REACT_DESCRIPTION,
)

agent_executor.run(
    "List the total sales per region. Which region's customers spent the most?"
)
```