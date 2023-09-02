### Instruction:
Attempt a different question. Run the process again with the new question keeping the same context.

### Response:
```python
question = "Which companies did the author intern at?"
result = chain.run(question=question, context=context)
for fact in result.answer:
    print("Statement:", fact.fact)
    for span in fact.get_spans(context):
        print("Citation:", highlight(context, span))
    print()
```