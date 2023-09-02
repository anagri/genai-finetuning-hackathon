### Instruction:
Set up a Language Model Chain with a custom prompt to generate articles about programming.

### Response:
```python
prompt_template = """Use the context below to write an article about the programming topic below:
    Context: {context}
    Programming Topic: {topic}
    Article Body:"""

PROMPT = PromptTemplate(template=prompt_template, input_variables=["context", "topic"])

llm = OpenAI(temperature=0.5)

chain = LLMChain(llm=llm, prompt=PROMPT)
```