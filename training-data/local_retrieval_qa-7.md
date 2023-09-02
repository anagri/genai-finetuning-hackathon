Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Use the LLMChain with a custom prompt and get the response.

### Response:
```python
from langchain import PromptTemplate, LLMChain

# Prompt
prompt = PromptTemplate.from_template(
    "Summarize the key points from the documents I fetched: {docs}"
)

# Chain
llm_chain = LLMChain(llm=llm, prompt=prompt)

# Run
question = "What is the current state of Natural language processing?"
docs = vectorstore.similarity_search(question)
result = llm_chain(docs)

# Output
result["text"]
```