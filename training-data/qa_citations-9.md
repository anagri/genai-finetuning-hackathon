### Instruction:
Explore the model's handling of complex queries. Craft a question that demands a high level of comprehension and run it with the given context.

### Response:
```python
question = "What motivated the author to start a AI research club at the University of Oxford?"
result = chain.run(question=question, context=context)
for fact in result.answer:
    print("Statement:", fact.fact)
    for span in fact.get_spans(context):
        print("Citation:", highlight(context, span))
    print()
```