# Summarization

[![Open In Collab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/langchain-ai/langchain/blob/master/docs/extras/use_cases/summarization.ipynb)

## Use case

Suppose you have a set of documents (PDFs, Notion pages, customer questions, etc.) and you want to summarize the content. 

LLMs are a great tool for this given their proficiency in understanding and synthesizing text.

In this walkthrough we'll go over how to perform document summarization using LLMs.

![Image description](/img/summarization_use_case_1.png)

## Overview

A central question for building a summarizer is how to pass your documents into the LLM's context window. Two common approaches for this are:

1. `Stuff`: Simply "stuff" all your documents into a single prompt. This is the simplest approach (see [here](/docs/modules/chains/document/stuff) for more on the `StuffDocumentsChains`, which is used for this method).

2. `Map-reduce`: Summarize each document on it's own in a "map" step and then "reduce" the summaries into a final summary (see [here](/docs/modules/chains/document/map_reduce) for more on the `MapReduceDocumentsChain`, which is used for this method).

![Image description](/img/summarization_use_case_2.png)

## Quickstart

To give you a sneak preview, either pipeline can be wrapped in a single object: `load_summarize_chain`. 

Suppose we want to summarize a blog post. We can create this in a few lines of code.

First set environment variables and install packages:


```python
!pip install openai tiktoken chromadb langchain

# Set env var OPENAI_API_KEY or load from a .env file
# import dotenv

# dotenv.load_env()
```

We can use `chain_type="stuff"`, especially if using larger context window models such as:

* 16k token OpenAI `gpt-3.5-turbo-16k` 
* 100k token Anthropic [Claude-2](https://www.anthropic.com/index/claude-2)

We can also supply `chain_type="map_reduce"` or `chain_type="refine"` (read more [here](/docs/modules/chains/document/refine)).


```python
from langchain.chat_models import ChatOpenAI
from langchain.document_loaders import WebBaseLoader
from langchain.chains.summarize import load_summarize_chain

loader = WebBaseLoader("https://lilianweng.github.io/posts/2023-06-23-agent/")
docs = loader.load()

llm = ChatOpenAI(temperature=0, model_name="gpt-3.5-turbo-16k")
chain = load_summarize_chain(llm, chain_type="stuff")

chain.run(docs)
```

## Option 1. Stuff

When we use `load_summarize_chain` with `chain_type="stuff"`, we will use the [StuffDocumentsChain](/docs/modules/chains/document/stuff).

The chain will take a list of documents, inserts them all into a prompt, and passes that prompt to an LLM:


```python
from langchain.chains.llm import LLMChain
from langchain.prompts import PromptTemplate
from langchain.chains.combine_documents.stuff import StuffDocumentsChain

# Define prompt
prompt_template = """Write a concise summary of the following:
"{text}"
CONCISE SUMMARY:"""
prompt = PromptTemplate.from_template(prompt_template)

# Define LLM chain
llm = ChatOpenAI(temperature=0, model_name="gpt-3.5-turbo-16k")
llm_chain = LLMChain(llm=llm, prompt=prompt)

# Define StuffDocumentsChain
stuff_chain = StuffDocumentsChain(
    llm_chain=llm_chain, document_variable_name="text"
)

docs = loader.load()
print(stuff_chain.run(docs))
```

Great! We can see that we reproduce the earlier result using the `load_summarize_chain`.

### Go deeper

* You can easily customize the prompt. 
* You can easily try different LLMs, (e.g., [Claude](/docs/integrations/chat/anthropic)) via the `llm` parameter.

## Option 2. Map-Reduce

Let's unpack the map reduce approach. For this, we'll first map each document to an individual summary using an `LLMChain`. Then we'll use a `ReduceDocumentsChain` to combine those summaries into a single global summary.
 
First, we specfy the LLMChain to use for mapping each document to an individual summary:


```python
from langchain.chains.mapreduce import MapReduceChain
from langchain.text_splitter import CharacterTextSplitter
from langchain.chains import ReduceDocumentsChain, MapReduceDocumentsChain

llm = ChatOpenAI(temperature=0)

# Map
map_template = """The following is a set of documents
{docs}
Based on this list of docs, please identify the main themes 
Helpful Answer:"""
map_prompt = PromptTemplate.from_template(map_template)
map_chain = LLMChain(llm=llm, prompt=map_prompt)
```

The `ReduceDocumentsChain` handles taking the document mapping results and reducing them into a single output. It wraps a generic `CombineDocumentsChain` (like `StuffDocumentsChain`) but adds the ability to collapse documents before passing it to the `CombineDocumentsChain` if their cumulative size exceeds `token_max`. In this example, we can actually re-use our chain for combining our docs to also collapse our docs.

So if the cumulative number of tokens in our mapped documents exceeds 4000 tokens, then we'll recursively pass in the documents in batches of < 4000 tokens to our `StuffDocumentsChain` to create batched summaries. And once those batched summaries are cumulatively less than 4000 tokens, we'll pass them all one last time to the `StuffDocumentsChain` to create the final summary.


```python
# Reduce
reduce_template = """The following is set of summaries:
{doc_summaries}
Take these and distill it into a final, consolidated summary of the main themes. 
Helpful Answer:"""
reduce_prompt = PromptTemplate.from_template(reduce_template)
reduce_chain = LLMChain(llm=llm, prompt=reduce_prompt)

# Takes a list of documents, combines them into a single string, and passes this to an LLMChain
combine_documents_chain = StuffDocumentsChain(
    llm_chain=reduce_chain, document_variable_name="doc_summaries"
)

# Combines and iteravely reduces the mapped documents
reduce_documents_chain = ReduceDocumentsChain(
    # This is final chain that is called.
    combine_documents_chain=combine_documents_chain,
    # If documents exceed context for `StuffDocumentsChain`
    collapse_documents_chain=combine_documents_chain,
    # The maximum number of tokens to group documents into.
    token_max=4000,
)
```

Combining our map and reduce chains into one:


```python
# Combining documents by mapping a chain over them, then combining results
map_reduce_chain = MapReduceDocumentsChain(
    # Map chain
    llm_chain=map_chain,
    # Reduce chain
    reduce_documents_chain=reduce_documents_chain,
    # The variable name in the llm_chain to put the documents in
    document_variable_name="docs",
    # Return the results of the map steps in the output
    return_intermediate_steps=False,
)

text_splitter = CharacterTextSplitter.from_tiktoken_encoder(
    chunk_size=1000, chunk_overlap=0
)
split_docs = text_splitter.split_documents(docs)
```


```python
print(map_reduce_chain.run(split_docs))
```

### Go deeper
 
**Customization** 

* As shown above, you can customize the LLMs and prompts for map and reduce stages.

**Real-world use-case**

* See [this blog post](https://blog.langchain.dev/llms-to-improve-documentation/) case-study on analyzing user interactions (questions about LangChain documentation)!  
* The blog post and associated [repo](https://github.com/mendableai/QA_clustering) also introduce clustering as a means of summarization.
* This opens up a third path beyond the `stuff` or `map-reduce` approaches that is worth considering.

![Image description](/img/summarization_use_case_3.png)

## Option 3. Refine
 
[Refine](/docs/modules/chains/document/refine) is similar to map-reduce:

> The refine documents chain constructs a response by looping over the input documents and iteratively updating its answer. For each document, it passes all non-document inputs, the current document, and the latest intermediate answer to an LLM chain to get a new answer.

This can be easily run with the `chain_type="refine"` specified.


```python
chain = load_summarize_chain(llm, chain_type="refine")
chain.run(split_docs)
```

It's also possible to supply a prompt and return intermediate steps.


```python
prompt_template = """Write a concise summary of the following:
{text}
CONCISE SUMMARY:"""
prompt = PromptTemplate.from_template(prompt_template)

refine_template = (
    "Your job is to produce a final summary\n"
    "We have provided an existing summary up to a certain point: {existing_answer}\n"
    "We have the opportunity to refine the existing summary"
    "(only if needed) with some more context below.\n"
    "------------\n"
    "{text}\n"
    "------------\n"
    "Given the new context, refine the original summary in Italian"
    "If the context isn't useful, return the original summary."
)
refine_prompt = PromptTemplate.from_template(refine_template)
chain = load_summarize_chain(
    llm=llm,
    chain_type="refine",
    question_prompt=prompt,
    refine_prompt=refine_prompt,
    return_intermediate_steps=True,
    input_key="input_documents",
    output_key="output_text",
)
result = chain({"input_documents": split_docs}, return_only_outputs=True)
```


```python
print(result["output_text"])
```


```python
print("\n\n".join(result["intermediate_steps"][:3]))
```


```python

```
