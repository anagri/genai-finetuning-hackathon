Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, initialise a SelfQueryRetriever that can filter based on the metadata of the document.

### Response:
```python
# Import required dependencies
from langchain.llms import OpenAI
from langchain.retrievers.self_query.base import SelfQueryRetriever
from langchain.chains.query_constructor.base import AttributeInfo

# Define the metadata for the retriever
metadata_field_info = [
    AttributeInfo(
        name="Section",
        description="Part of the document that the text comes from",
        type="string or list[string]",
    ),
]
document_content_description = "Major sections of the document"

# Initialise the retriever
llm = OpenAI(temperature=0)
retriever = SelfQueryRetriever.from_llm(
    llm, vectorstore, document_content_description, metadata_field_info, verbose=True
)
```
---
