### Instruction:
Set up a vector database with the document chunks obtained from the Langchain GitHub repository.

### Response:
```python
search_index = Chroma.from_documents(source_chunks, OpenAIEmbeddings())
```