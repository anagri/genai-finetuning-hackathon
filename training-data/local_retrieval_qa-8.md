Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Create and run a QA chain.

### Response:
```python
from langchain.chains.question_answering import load_qa_chain
from langchain.chains import RetrievalQA

QA_CHAIN_PROMPT = PromptTemplate(
    input_variables=["context", "question"],
    template= template,
)

# Chain
chain = load_qa_chain(llm, chain_type="stuff", prompt=QA_CHAIN_PROMPT)

# Run
chain({"input_documents": docs, "question": question}, return_only_outputs=True)
```