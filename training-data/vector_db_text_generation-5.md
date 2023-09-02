Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, set up a simple LLM chain with a custom prompt for document generation

### Response:
```python
from langchain.chains import LLMChain
from langchain.llms import OpenAI
from langchain.prompts import PromptTemplate

prompt_template = """Use the context below to write a 400 word article about the topic below:
    Context: {context}
    Topic: {topic}
    Article:"""

PROMPT = PromptTemplate(template=prompt_template, input_variables=["context", "topic"])
llm = OpenAI(temperature=0.5)

chain = LLMChain(llm=llm, prompt=PROMPT)
```
---
