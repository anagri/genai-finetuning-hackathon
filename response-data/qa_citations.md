---
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:

Using the python langchain library, write a script that uses langchain to make API calls to a Large Language Model, given a question and context. The context is about Tom, who is a software engineer and has worked with Microsoft and Google. The question is "What were Tom's roles at his previous jobs?"

### Response:

```python
from langchain.chains import create_citation_fuzzy_match_chain
from langchain.chat_models import ChatOpenAI

question = "What were Tom's roles at his previous jobs?"
context = """
Tom is a software engineer who has worked in the tech industry for over a decade.
During his time at Microsoft, he was a key player in the development of their cloud infrastructure,
and at Google, he contributed significantly to the improvement of their search algorithm.
"""

llm = ChatOpenAI(temperature=0, model="gpt-3.5-turbo-0613")

chain = create_citation_fuzzy_match_chain(llm)

result = chain.run(question=question, context=context)

print(result)

def highlight(text, span):
    return (
        "..."+text[span[0] - 20 : span[0]]+"*"
        + "\033[91m"+text[span[0] : span[1]]+"\033[0m"
        +"*"+text[span[1] : span[1] + 20]+"..."
    )

for fact in result.answer:
    print("Statement:", fact.fact)
    for span in fact.get_spans(context):
        print("Citation:", highlight(context, span))
```
---
