# Use local LLMs

The popularity of projects like [PrivateGPT](https://github.com/imartinez/privateGPT), [llama.cpp](https://github.com/ggerganov/llama.cpp), and [GPT4All](https://github.com/nomic-ai/gpt4all) underscore the importance of running LLMs locally.

LangChain has [integrations](https://integrations.langchain.com/) with many open source LLMs that can be run locally.

For example, here we show how to run `GPT4All` or `Llama-v2` locally (e.g., on your laptop) using local embeddings and a local LLM.

## Document Loading 

First, install packages needed for local embeddings and vector storage.


```python
! pip install gpt4all
! pip install chromadb
```

Load and split an example docucment.

We'll use a blog post on agents as an example.


```python
from langchain.document_loaders import WebBaseLoader

loader = WebBaseLoader("https://lilianweng.github.io/posts/2023-06-23-agent/")
data = loader.load()

from langchain.text_splitter import RecursiveCharacterTextSplitter

text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=0)
all_splits = text_splitter.split_documents(data)
```

Next, the below steps will download the `GPT4All` embeddings locally (if you don't already have them).


```python
from langchain.vectorstores import Chroma
from langchain.embeddings import GPT4AllEmbeddings

vectorstore = Chroma.from_documents(documents=all_splits, embedding=GPT4AllEmbeddings())
```

Test similarity search is working with our local embeddings.


```python
question = "What are the approaches to Task Decomposition?"
docs = vectorstore.similarity_search(question)
len(docs)
```


```python
docs[0]
```

## Model 

### Llama-v2

Download a GGML converted model (e.g., [here](https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGML/tree/main)).


```python
! pip install llama-cpp-python
```

To enable use of GPU on Apple Silicon, follow the steps [here](https://github.com/abetlen/llama-cpp-python/blob/main/docs/install/macos.md) to use the Python binding `with Metal support`.

In particular, ensure that `conda` is using the correct virtual enviorment that you created (`miniforge3`).

E.g., for me:

```
conda activate /Users/rlm/miniforge3/envs/llama
```

With this confirmed:


```python
! CMAKE_ARGS="-DLLAMA_METAL=on" FORCE_CMAKE=1 pip install -U llama-cpp-python --no-cache-dir
```


```python
from langchain.llms import LlamaCpp
from langchain.callbacks.manager import CallbackManager
from langchain.callbacks.streaming_stdout import StreamingStdOutCallbackHandler
```

Setting model parameters as noted in the [llama.cpp docs](https://python.langchain.com/docs/integrations/llms/llamacpp).


```python
n_gpu_layers = 1  # Metal set to 1 is enough.
n_batch = 512  # Should be between 1 and n_ctx, consider the amount of RAM of your Apple Silicon Chip.
callback_manager = CallbackManager([StreamingStdOutCallbackHandler()])

# Make sure the model path is correct for your system!
llm = LlamaCpp(
    model_path="/Users/rlm/Desktop/Code/llama.cpp/llama-2-13b-chat.ggmlv3.q4_0.bin",
    n_gpu_layers=n_gpu_layers,
    n_batch=n_batch,
    n_ctx=2048,
    f16_kv=True,  # MUST set to True, otherwise you will run into problem after a couple of calls
    callback_manager=callback_manager,
    verbose=True,
)
```

Note that these indicate that [Metal was enabled properly](https://python.langchain.com/docs/integrations/llms/llamacpp):

```
ggml_metal_init: allocating
ggml_metal_init: using MPS
```


```python
prompt = """
Question: A rap battle between Stephen Colbert and John Oliver
"""
llm(prompt)
```

### GPT4All

Similarly, we can use `GPT4All`.

[Download the GPT4All model binary](https://python.langchain.com/docs/integrations/llms/gpt4all).

The Model Explorer on the [GPT4All](https://gpt4all.io/index.html) is a great way to choose and download a model.

Then, specify the path that you downloaded to to.

E.g., for me, the model lives here:

`/Users/rlm/Desktop/Code/gpt4all/models/nous-hermes-13b.ggmlv3.q4_0.bin`


```python
from langchain.llms import GPT4All

llm = GPT4All(
    model="/Users/rlm/Desktop/Code/gpt4all/models/nous-hermes-13b.ggmlv3.q4_0.bin",
    max_tokens=2048,
)
```

## LLMChain

Run an `LLMChain` (see [here](https://python.langchain.com/docs/modules/chains/foundational/llm_chain)) with either model by passing in the retrieved docs and a simple prompt.

It formats the prompt template using the input key values provided and passes the formatted string to `GPT4All`, `LLama-V2`, or another specified LLM.
 
In this case, the list of retrieved documents (`docs`) above are pass into `{context}`.


```python
from langchain import PromptTemplate, LLMChain

# Prompt
prompt = PromptTemplate.from_template(
    "Summarize the main themes in these retrieved docs: {docs}"
)

# Chain
llm_chain = LLMChain(llm=llm, prompt=prompt)

# Run
question = "What are the approaches to Task Decomposition?"
docs = vectorstore.similarity_search(question)
result = llm_chain(docs)

# Output
result["text"]
```

## QA Chain

We can use a `QA chain` to handle our question above.

`chain_type="stuff"` (see [here](https://python.langchain.com/docs/modules/chains/document/stuff)) means that all the docs will be added (stuffed) into a prompt.


```python
from langchain.chains.question_answering import load_qa_chain

# Prompt
template = """Use the following pieces of context to answer the question at the end. 
If you don't know the answer, just say that you don't know, don't try to make up an answer. 
Use three sentences maximum and keep the answer as concise as possible. 
Always say "thanks for asking!" at the end of the answer. 
{context}
Question: {question}
Helpful Answer:"""
QA_CHAIN_PROMPT = PromptTemplate(
    input_variables=["context", "question"],
    template=template,
)

# Chain
chain = load_qa_chain(llm, chain_type="stuff", prompt=QA_CHAIN_PROMPT)

# Run
chain({"input_documents": docs, "question": question}, return_only_outputs=True)
```

## RetrievalQA

For an even simpler flow, use `RetrievalQA`.

This will use a QA default prompt (shown [here](https://github.com/hwchase17/langchain/blob/275b926cf745b5668d3ea30236635e20e7866442/langchain/chains/retrieval_qa/prompt.py#L4)) and will retrieve from the vectorDB.

But, you can still pass in a prompt, as before, if desired.


```python
from langchain.chains import RetrievalQA

qa_chain = RetrievalQA.from_chain_type(
    llm,
    retriever=vectorstore.as_retriever(),
    chain_type_kwargs={"prompt": QA_CHAIN_PROMPT},
)
```


```python
qa_chain({"query": question})
```
