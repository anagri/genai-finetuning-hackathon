Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Reset the vector database and perform data operations for a new set of document chunks from a different Langchain GitHub repository.

### Response:
```python
sources = get_github_docs("Langchain", "AdvancedPythonTopics")
source_chunks = []
for source in sources:
    for chunk in splitter.split_text(source.page_content):
        source_chunks.append(Document(page_content=chunk, metadata=source.metadata))
        
search_index = Chroma.from_documents(source_chunks, OpenAIEmbeddings())
```