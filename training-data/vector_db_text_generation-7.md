Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the Langchain library, generate a custom prompt and setup the Language Model Chain to generate text pertaining to the topic of "Python Exception Handling".

### Response:
```python
prompt_template = """Please generate a tutorial about the topic below referring to the context:
    Context: {context}
    Topic: {topic}
    Tutorial Body:"""
    
PROMPT = PromptTemplate(template=prompt_template, input_variables=["context", "topic"])

llm = OpenAI(temperature=0.5)

chain = LLMChain(llm=llm, prompt=PROMPT)

generate_blog_post("Python Exception Handling")
```