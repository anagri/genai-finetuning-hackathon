Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, create a tool for our previously created retriever "search_novel", which searches and returns chunks from the novel. Also, use an OpenAI model to create an agent executor for conversational retrieval.

### Response:
```python
from langchain.agents.agent_toolkits import create_retriever_tool
from langchain.chat_models import ChatOpenAI
from langchain.agents.agent_toolkits import create_conversational_retrieval_agent 

# Create the retriever tool
tool = create_retriever_tool(
    retriever, 
    "search_novel",
    "Searches and returns text chunks from the novel."
)
tools = [tool]

# Create an OpenAI model
llm = ChatOpenAI(temperature = 0)

# Create the agent executor
agent_executor = create_conversational_retrieval_agent(llm, tools, verbose=True)
```
---
