Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, load a QA chain and run it with the given input documents and question.

### Response:
```python
from langchain.chains.question_answering import load_qa_chain

template = """Here is some context to consider for answering the question at the end. 
{context}
Question: {question}
Provide a helpful answer:"""
QA_CHAIN_PROMPT = PromptTemplate(
    input_variables=["context", "question"],
    template=template,
)

chain = load_qa_chain(llm, chain_type="stuff", prompt=QA_CHAIN_PROMPT)

chain({"input_documents": docs, "question": question}, return_only_outputs=True)
```
---
