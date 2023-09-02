# Chatbots

[![Open In Collab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/langchain-ai/langchain/blob/master/docs/extras/use_cases/chatbots.ipynb)

## Use case

Chatbots are one of the central LLM use-cases. The core features of chatbots are that they can have long-running conversations and have access to information that users want to know about.

Aside from basic prompting and LLMs, memory and retrieval are the core components of a chatbot. Memory allows a chatbot to remember past interactions, and retrieval provides a chatbot with up-to-date, domain-specific information.

![Image description](/img/chat_use_case.png)

## Overview

The chat model interface is based around messages rather than raw text. Several components are important to consider for chat:

* `chat model`: See [here](/docs/integrations/chat) for a list of chat model integrations and [here](/docs/modules/model_io/models/chat) for documentation on the chat model interface in LangChain. You can use `LLMs` (see [here](/docs/modules/model_io/models/llms)) for chatbots as well, but chat models have a more conversational tone and natively support a message interface.
* `prompt template`: Prompt templates make it easy to assemble prompts that combine default messages, user input, chat history, and (optionally) additional retrieved context.
* `memory`: [See here](/docs/modules/memory/) for in-depth documentation on memory types
* `retriever` (optional): [See here](/docs/modules/data_connection/retrievers) for in-depth documentation on retrieval systems. These are useful if you want to build a chatbot with domain-specific knowledge.

## Quickstart

Here's a quick preview of how we can create chatbot interfaces. First let's install some dependencies and set the required credentials:


```python
!pip install langchain openai 

# Set env var OPENAI_API_KEY or load from a .env file:
# import dotenv
# dotenv.load_env()
```

With a plain chat model, we can get chat completions by [passing one or more messages](/docs/modules/model_io/models/chat) to the model.

The chat model will respond with a message.


```python
from langchain.schema import (
    AIMessage,
    HumanMessage,
    SystemMessage
)
from langchain.chat_models import ChatOpenAI

chat = ChatOpenAI()
chat([HumanMessage(content="Translate this sentence from English to French: I love programming.")])
```

And if we pass in a list of messages:


```python
messages = [
    SystemMessage(content="You are a helpful assistant that translates English to French."),
    HumanMessage(content="I love programming.")
]
chat(messages)
```

We can then wrap our chat model in a `ConversationChain`, which has built-in memory for remembering past user inputs and model outputs.


```python
from langchain.chains import ConversationChain  
  
conversation = ConversationChain(llm=chat)  
conversation.run("Translate this sentence from English to French: I love programming.")  
```


```python
conversation.run("Translate it to German.")  
```

## Memory 

As we mentioned above, the core component of chatbots is the memory system. One of the simplest and most commonly used forms of memory is `ConversationBufferMemory`:
* This memory allows for storing of messages in a `buffer`
* When called in a chain, it returns all of the messages it has stored

LangChain comes with many other types of memory, too. [See here](/docs/modules/memory/) for in-depth documentation on memory types.

For now let's take a quick look at ConversationBufferMemory. We can manually add a few chat messages to the memory like so:


```python
from langchain.memory import ConversationBufferMemory

memory = ConversationBufferMemory()
memory.chat_memory.add_user_message("hi!")
memory.chat_memory.add_ai_message("whats up?")
```

And now we can load from our memory. The key method exposed by all `Memory` classes is `load_memory_variables`. This takes in any initial chain input and returns a list of memory variables which are added to the chain input. 

Since this simple memory type doesn't actually take into account the chain input when loading memory, we can pass in an empty input for now:


```python
memory.load_memory_variables({})
```

We can also keep a sliding window of the most recent `k` interactions using `ConversationBufferWindowMemory`.


```python
from langchain.memory import ConversationBufferWindowMemory

memory = ConversationBufferWindowMemory(k=1)
memory.save_context({"input": "hi"}, {"output": "whats up"})
memory.save_context({"input": "not much you"}, {"output": "not much"})
memory.load_memory_variables({})
```

`ConversationSummaryMemory` is an extension of this theme.

It creates a summary of the conversation over time. 

This memory is most useful for longer conversations where the full message history would consume many tokens.


```python
from langchain.llms import OpenAI
from langchain.memory import ConversationSummaryMemory

llm = OpenAI(temperature=0)
memory = ConversationSummaryMemory(llm=llm)
memory.save_context({"input": "hi"},{"output": "whats up"})
memory.save_context({"input": "im working on better docs for chatbots"},{"output": "oh, that sounds like a lot of work"})
memory.save_context({"input": "yes, but it's worth the effort"},{"output": "agreed, good docs are important!"})
```


```python
memory.load_memory_variables({})
```

`ConversationSummaryBufferMemory` extends this a bit further:

It uses token length rather than number of interactions to determine when to flush interactions.


```python
from langchain.memory import ConversationSummaryBufferMemory
memory = ConversationSummaryBufferMemory(llm=llm, max_token_limit=10)
memory.save_context({"input": "hi"}, {"output": "whats up"})
memory.save_context({"input": "not much you"}, {"output": "not much"})
```

## Conversation 

We can unpack what goes under the hood with `ConversationChain`. 

We can specify our memory, `ConversationSummaryMemory` and we can specify the prompt. 


```python
from langchain.prompts import (
    ChatPromptTemplate,
    MessagesPlaceholder,
    SystemMessagePromptTemplate,
    HumanMessagePromptTemplate,
)
from langchain.chains import LLMChain

# LLM
llm = ChatOpenAI()

# Prompt 
prompt = ChatPromptTemplate(
    messages=[
        SystemMessagePromptTemplate.from_template(
            "You are a nice chatbot having a conversation with a human."
        ),
        # The `variable_name` here is what must align with memory
        MessagesPlaceholder(variable_name="chat_history"),
        HumanMessagePromptTemplate.from_template("{question}")
    ]
)

# Notice that we `return_messages=True` to fit into the MessagesPlaceholder
# Notice that `"chat_history"` aligns with the MessagesPlaceholder name
memory = ConversationBufferMemory(memory_key="chat_history",return_messages=True)
conversation = LLMChain(
    llm=llm,
    prompt=prompt,
    verbose=True,
    memory=memory
)

# Notice that we just pass in the `question` variables - `chat_history` gets populated by memory
conversation({"question": "hi"})
```


```python
conversation({"question": "Translate this sentence from English to French: I love programming."})
```


```python
conversation({"question": "Now translate the sentence to German."})
```

We can see the chat history preserved in the prompt using the [LangSmith trace](https://smith.langchain.com/public/dce34c57-21ca-4283-9020-a8e0d78a59de/r).

![Image description](/img/chat_use_case_2.png)

## Chat Retrieval

Now, suppose we want to [chat with documents](https://twitter.com/mayowaoshin/status/1640385062708424708?s=20) or some other source of knowledge.

This is popular use case, combining chat with [document retrieval](/docs/use_cases/question_answering).

It allows us to chat with specific information that the model was not trained on.


```python
!pip install tiktoken chromadb
```

Load a blog post.


```python
from langchain.document_loaders import WebBaseLoader

loader = WebBaseLoader("https://lilianweng.github.io/posts/2023-06-23-agent/")
data = loader.load()
```

Split and store this in a vector.


```python
from langchain.text_splitter import RecursiveCharacterTextSplitter

text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=0)
all_splits = text_splitter.split_documents(data)

from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma

vectorstore = Chroma.from_documents(documents=all_splits, embedding=OpenAIEmbeddings())
```

Create our memory, as before, but's let's use `ConversationSummaryMemory`.


```python
memory = ConversationSummaryMemory(llm=llm,memory_key="chat_history",return_messages=True)
```


```python
from langchain.chat_models import ChatOpenAI
from langchain.chains import ConversationalRetrievalChain

llm = ChatOpenAI()
retriever = vectorstore.as_retriever()
qa = ConversationalRetrievalChain.from_llm(llm, retriever=retriever, memory=memory)
```


```python
qa("How do agents use Task decomposition?")
```


```python
qa("What are the various ways to implemet memory to support it?")
```

Again, we can use the [LangSmith trace](https://smith.langchain.com/public/18460363-0c70-4c72-81c7-3b57253bb58c/r) to explore the prompt structure.

### Going deeper 

* Agents, such as the [conversational retrieval agent](/docs/use_cases/question_answering/how_to/conversational_retrieval_agents), can be used for retrieval when necessary while also holding a conversation.



```python

```
