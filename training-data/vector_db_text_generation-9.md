Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Modify the template prompt to generate a condensed review about a specific topic, and then use it to produce a review on "Python Generators".

### Response:
```python
prompt_template = """Using the context below, write a concise review about the topic below:
    Context: {context}
    Topic: {topic}
    Review Body:"""
    
PROMPT = PromptTemplate(template=prompt_template, input_variables=["context", "topic"])

llm = OpenAI(temperature=0.5)

chain = LLMChain(llm=llm, prompt=PROMPT)

generate_blog_post("Python Generators")
```