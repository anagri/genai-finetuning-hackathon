# Conversational Retrieval Agent

This is an agent specifically optimized for doing retrieval when necessary and also holding a conversation.

To start, we will set up the retriever we want to use, and then turn it into a retriever tool. Next, we will use the high level constructor for this type of agent. Finally, we will walk through how to construct a conversational retrieval agent from components.

## The Retriever

To start, we need a retriever to use! The code here is mostly just example code. Feel free to use your own retriever and skip to the section on creating a retriever tool.


```python
from langchain.document_loaders import TextLoader
loader = TextLoader('../../../../../docs/extras/modules/state_of_the_union.txt')
```


```python
from langchain.text_splitter import CharacterTextSplitter
from langchain.vectorstores import FAISS
from langchain.embeddings import OpenAIEmbeddings

documents = loader.load()
text_splitter = CharacterTextSplitter(chunk_size=1000, chunk_overlap=0)
texts = text_splitter.split_documents(documents)
embeddings = OpenAIEmbeddings()
db = FAISS.from_documents(texts, embeddings)
```


```python
retriever = db.as_retriever()
```

## Retriever Tool

Now we need to create a tool for our retriever. The main things we need to pass in are a name for the retriever as well as a description. These will both be used by the language model, so they should be informative.


```python
from langchain.agents.agent_toolkits import create_retriever_tool
```


```python
tool = create_retriever_tool(
    retriever, 
    "search_state_of_union",
    "Searches and returns documents regarding the state-of-the-union."
)
tools = [tool]
```

## Agent Constructor

Here, we will use the high level `create_conversational_retrieval_agent` API to construct the agent.

Notice that beside the list of tools, the only thing we need to pass in is a language model to use.
Under the hood, this agent is using the OpenAIFunctionsAgent, so we need to use an ChatOpenAI model.


```python
from langchain.agents.agent_toolkits import create_conversational_retrieval_agent 
```


```python
from langchain.chat_models import ChatOpenAI
llm = ChatOpenAI(temperature = 0)
```


```python
agent_executor = create_conversational_retrieval_agent(llm, tools, verbose=True)
```

We can now try it out!


```python
result = agent_executor({"input": "hi, im bob"})
```


```python
result["output"]
```

Notice that it remembers your name


```python
result = agent_executor({"input": "whats my name?"})
```


```python
result["output"]
```

Notice that it now does retrieval


```python
result = agent_executor({"input": "what did the president say about kentaji brown jackson in the most recent state of the union?"})
```


```python
result["output"]
```

Notice that the follow up question asks about information previously retrieved, so no need to do another retrieval


```python
result = agent_executor({"input": "how long ago did he nominate her?"})
```


```python
result["output"]
```

## Creating from components

What actually is going on underneath the hood? Let's take a look so we can understand how to modify going forward.

There are a few components:

- The memory
- The prompt template
- The agent
- The agent executor


```python
# This is needed for both the memory and the prompt
memory_key = "history"
```

### The Memory

In this example, we want the agent to remember not only previous conversations, but also previous intermediate steps. For that, we can use `AgentTokenBufferMemory`. Note that if you want to change whether the agent remembers intermediate steps, or how the long the buffer is, or anything like that you should change this part.


```python
from langchain.agents.openai_functions_agent.agent_token_buffer_memory import AgentTokenBufferMemory

memory = AgentTokenBufferMemory(memory_key=memory_key, llm=llm)
```

## The Prompt Template

For the prompt template, we will use the `OpenAIFunctionsAgent` default way of creating one, but pass in a system prompt and a placeholder for memory.


```python
from langchain.agents.openai_functions_agent.base import OpenAIFunctionsAgent
from langchain.schema.messages import SystemMessage
from langchain.prompts import MessagesPlaceholder
```


```python
system_message = SystemMessage(
        content=(
            "Do your best to answer the questions. "
            "Feel free to use any tools available to look up "
            "relevant information, only if neccessary"
        )
)
```


```python
prompt = OpenAIFunctionsAgent.create_prompt(
        system_message=system_message,
        extra_prompt_messages=[MessagesPlaceholder(variable_name=memory_key)]
    )
```

## The Agent

We will use the OpenAIFunctionsAgent


```python
agent = OpenAIFunctionsAgent(llm=llm, tools=tools, prompt=prompt)
```

## The Agent Executor

Importantly, we pass in `return_intermediate_steps=True` since we are recording that with our memory object


```python
from langchain.agents import AgentExecutor
```


```python
agent_executor = AgentExecutor(agent=agent, tools=tools, memory=memory, verbose=True,
                                   return_intermediate_steps=True)
```


```python
result = agent_executor({"input": "hi, im bob"})
```


```python
result = agent_executor({"input": "whats my name"})
```


```python

```
