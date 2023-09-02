Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, analyze the sentiment and language of a given text.

### Response:

```python
from langchain.chat_models import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from langchain.chains import create_tagging_chain

# Schema
schema = {
    "properties": {
        "sentiment": {"type": "string"},
        "language": {"type": "string"},
    }
}

# LLM
llm = ChatOpenAI(temperature=0, model="gpt-3.5-turbo-0613")
chain = create_tagging_chain(schema, llm)

inp = "I am extremely happy to have met you! I think we will be very good friends!"
result = chain.run(inp)
print(result)
```
---
