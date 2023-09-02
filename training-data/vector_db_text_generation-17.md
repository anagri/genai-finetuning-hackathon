Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, set up a Language model that generates product tutorials from past documentation.

### Response:
```python
from langchain.chains import LLMChain
from langchain.llms import OpenAI
from langchain.prompts import PromptTemplate

prompt_template = """Use the context below to provide a detailed tutorial on the topic:
    Context: {context}
    Topic: {topic}
    Tutorial:"""

PROMPT = PromptTemplate(template=prompt_template, 
                        input_variables=["context", "topic"])

llm = OpenAI(temperature=0.5)

tutorial_chain = LLMChain(llm=llm, prompt=PROMPT)
```
---
