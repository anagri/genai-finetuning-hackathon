Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Create a SelfQueryRetriever that can filter metadata based on the subsections of the document using langchain.

### Response:
```python
from langchain.llms import OpenAI
from langchain.retrievers.self_query.base import SelfQueryRetriever
from langchain.chains.query_constructor.base import AttributeInfo

llm = OpenAI(temperature=0)
retriever = SelfQueryRetriever.from_llm(
    llm, vectorstore, document_content_description, metadata_field_info, verbose=True
)
```