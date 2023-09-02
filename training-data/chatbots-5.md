Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Derive a more complex chat interface using the Langchain library, which includes a memory, ConversationSummaryMemory, and a custom prompt.

### Response:
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
        MessagesPlaceholder(variable_name="chat_history"),
        HumanMessagePromptTemplate.from_template("{question}")
    ]
)

# Memory
memory = ConversationSummaryMemory(llm=llm, memory_key="chat_history", return_messages=True)

conversation = LLMChain(llm=llm, prompt=prompt, verbose=True, memory=memory)

conversation({"question": "hi"})
conversation({"question": "Translate this sentence from English to French: I love programming."})
```
---
