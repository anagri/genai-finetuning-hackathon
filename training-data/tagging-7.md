Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Create a tagging chain out of the Pydantic model you just created and run an aggressive Spanish sentence through this new chain.

### Response:
```python
from langchain.chains import create_tagging_chain_pydantic

chain = create_tagging_chain_pydantic(Tags, llm)

inp = "Estoy muy enojado con vos! Te voy a dar tu merecido!"
res = chain.run(inp)
```