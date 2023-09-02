### Instruction:
Customize and execute the "refine" type summarization chain.

### Response:
```python
chain = load_summarize_chain(
    llm=llm,
    chain_type="refine",
    question_prompt=prompt,
    refine_prompt=refine_prompt,
    return_intermediate_steps=True,
    input_key="input_documents",
    output_key="output_text",
)
result = chain.run({"input_documents": split_docs}, return_only_outputs=True)
```