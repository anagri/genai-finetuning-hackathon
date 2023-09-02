### Instruction:
Define a function to highlight a specific text span in the given context for easier reading.

### Response:
```python
def highlight(text, span):
    return (
        "..."
        + text[span[0] - 20 : span[0]]
        + "*"
        + "\033[91m"
        + text[span[0] : span[1]]
        + "\033[0m"
        + "*"
        + text[span[1] : span[1] + 20]
        + "..."
    )
```