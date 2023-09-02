### Instruction:
Loop through the facts contained in the result's answer, print each statement and its associated citation from the context. Use the "highlight" function for better visualization.

### Response:
```python
for fact in result.answer:
    print("Statement:", fact.fact)
    for span in fact.get_spans(context):
        print("Citation:", highlight(context, span))
    print()
```