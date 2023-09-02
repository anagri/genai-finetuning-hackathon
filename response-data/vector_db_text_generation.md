Prompt 1:
---
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, fetch document content from github repositories and organize them into usable data chunks.

### Response:
```python
from langchain.llms import OpenAI
from langchain.docstore.document import Document
from langchain.embeddings.openai import OpenAIEmbeddings
from langchain.text_splitter import CharacterTextSplitter
import requests
import subprocess
import tempfile
import pathlib

def get_github_docs(repo_owner, repo_name):
    with tempfile.TemporaryDirectory() as d:
        subprocess.check_call(
            f"git clone --depth 1 https://github.com/{repo_owner}/{repo_name}.git .",
            cwd=d,
            shell=True,
        )
        git_sha = (
            subprocess.check_output("git rev-parse HEAD", shell=True, cwd=d)
            .decode("utf-8")
            .strip()
        )
        repo_path = pathlib.Path(d)
        markdown_files = list(repo_path.glob("*/*.md")) + list(
            repo_path.glob("*/*.mdx")
        )
        for markdown_file in markdown_files:
            with open(markdown_file, "r") as f:
                relative_path = markdown_file.relative_to(repo_path)
                github_url = f"https://github.com/{repo_owner}/{repo_name}/blob/{git_sha}/{relative_path}"
                yield Document(page_content=f.read(), metadata={"source": github_url})

sources = get_github_docs("yirenlu92", "deno-manual-forked")

source_chunks = []
splitter = CharacterTextSplitter(separator=" ", chunk_size=1024, chunk_overlap=0)
for source in sources:
    for chunk in splitter.split_text(source.page_content):
        source_chunks.append(Document(page_content=chunk, metadata=source.metadata))
```

---

Prompt 2:
---
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Use the python langchain library to set up a vector index from a list of documents.

### Response:
```python
from langchain.vectorstores import Chroma
from langchain.embeddings.openai import OpenAIEmbeddings

# Assuming 'source_chunks' is a list of documents
search_index = Chroma.from_documents(source_chunks, OpenAIEmbeddings())
```

---

Prompt 3:
---
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, set up a simple LLM chain with a custom prompt for document generation

### Response:
```python
from langchain.chains import LLMChain
from langchain.llms import OpenAI
from langchain.prompts import PromptTemplate

prompt_template = """Use the context below to write a 400 word article about the topic below:
    Context: {context}
    Topic: {topic}
    Article:"""

PROMPT = PromptTemplate(template=prompt_template, input_variables=["context", "topic"])
llm = OpenAI(temperature=0.5)

chain = LLMChain(llm=llm, prompt=PROMPT)
```

---

Prompt 4:
---
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Write a function using the python langchain library to apply inputs of context and topic to the LLM chain for text generation.

### Response:
```python
def generate_text(topic):
    docs = search_index.similarity_search(topic, k=4)
    inputs = [{"context": doc.page_content, "topic": topic} for doc in docs]
    return chain.apply(inputs)
```

---

Prompt 5:
---
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the langchain library, fetch a certain topic from the vector index and generate a document using the retrieved documents as context.

### Response:
```python
def generate_document(topic):
    docs = search_index.similarity_search(topic, k=3)
    inputs = [{"context": doc.page_content, "topic": topic} for doc in docs]
    return chain.apply(inputs)

generate_document("socket programming")
```

---

Prompt 6:
---
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the langchain library, retrieve a specific github repository, parse the markdown files and output a list of documents.

### Response:
```python
from langchain.docstore.document import Document
import subprocess
import pathlib
import tempfile

def get_docs_from_github(repo_owner, repo_name):
    with tempfile.TemporaryDirectory() as d:
        subprocess.check_call(
            f"git clone --depth 1 https://github.com/{repo_owner}/{repo_name}.git .",
            cwd=d,
            shell=True,
        )
        repo_path = pathlib.Path(d)
        markdown_files = list(repo_path.glob("*/*.md")) + list(repo_path.glob("*/*.mdx"))
        for markdown_file in markdown_files:
            with open(markdown_file, "r") as f:
                relative_path = markdown_file.relative_to(repo_path)
                github_url = f"https://github.com/{repo_owner}/{repo_name}/blob/{git_sha}/{relative_path}"
                yield Document(page_content=f.read(), metadata={"source": github_url})

docs = list(get_docs_from_github("userName","repoName"))
```

---

Prompt 7:
---
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Use python's langchain library to index document chunks using a vector store.

### Response:
```python
from langchain.vectorstores import Chroma
from langchain.embeddings.openai import OpenAIEmbeddings

# Assuming 'source_chunks' is a list of document chunks
search_index = Chroma.from_documents(source_chunks, OpenAIEmbeddings())
```

---

Prompt 8:
---
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Use the python langchain library to generate an informative blog post on a given topic using past articles as context.

### Response:
```python
def generate_blog_post(topic):
    docs = search_index.similarity_search(topic, k=4)
    inputs = [{"context": doc.page_content, "topic": topic} for doc in docs]
    return chain.apply(inputs)

generate_blog_post("python web scraping")
```

---

Prompt 9:
---
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, set up a Language model that generates product tutorials from past documentation.

### Response:
```python
from langchain.chains import LLMChain
from langchain.llms import OpenAI
from langchain.prompts import PromptTemplate

prompt_template = """Use the context below to provide a detailed tutorial on the topic:
    Context: {context}
    Topic: {topic}
    Tutorial:"""

PROMPT = PromptTemplate(template=prompt_template, 
                        input_variables=["context", "topic"])

llm = OpenAI(temperature=0.5)

tutorial_chain = LLMChain(llm=llm, prompt=PROMPT)
```

---

Prompt 10:
---
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Write a function to generate detailed product tutorials from a given topic and past tutorials as context, by employing the python langchain library.

### Response:
```python
def generate_tutorial(topic):
    docs = search_index.similarity_search(topic, k=3)
    inputs = [{"context": doc.page_content, "topic": topic} for doc in docs]
    return tutorial_chain.apply(inputs)

generate_tutorial("how to use language models")
```

---