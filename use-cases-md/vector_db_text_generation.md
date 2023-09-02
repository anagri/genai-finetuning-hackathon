# Retrieve from vector stores directly

This notebook walks through how to use LangChain for text generation over a vector index. This is useful if we want to generate text that is able to draw from a large body of custom text, for example, generating blog posts that have an understanding of previous blog posts written, or product tutorials that can refer to product documentation.

## Prepare Data

First, we prepare the data. For this example, we fetch a documentation site that consists of markdown files hosted on Github and split them into small enough Documents.


```python
from langchain.llms import OpenAI
from langchain.docstore.document import Document
import requests
from langchain.embeddings.openai import OpenAIEmbeddings
from langchain.vectorstores import Chroma
from langchain.text_splitter import CharacterTextSplitter
from langchain.prompts import PromptTemplate
import pathlib
import subprocess
import tempfile
```


```python
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

## Set Up Vector DB

Now that we have the documentation content in chunks, let's put all this information in a vector index for easy retrieval.


```python
search_index = Chroma.from_documents(source_chunks, OpenAIEmbeddings())
```

## Set Up LLM Chain with Custom Prompt

Next, let's set up a simple LLM chain but give it a custom prompt for blog post generation. Note that the custom prompt is parameterized and takes two inputs: `context`, which will be the documents fetched from the vector search, and `topic`, which is given by the user.


```python
from langchain.chains import LLMChain

prompt_template = """Use the context below to write a 400 word blog post about the topic below:
    Context: {context}
    Topic: {topic}
    Blog post:"""

PROMPT = PromptTemplate(template=prompt_template, input_variables=["context", "topic"])

llm = OpenAI(temperature=0)

chain = LLMChain(llm=llm, prompt=PROMPT)
```

## Generate Text

Finally, we write a function to apply our inputs to the chain. The function takes an input parameter `topic`. We find the documents in the vector index that correspond to that `topic`, and use them as additional context in our simple LLM chain.


```python
def generate_blog_post(topic):
    docs = search_index.similarity_search(topic, k=4)
    inputs = [{"context": doc.page_content, "topic": topic} for doc in docs]
    print(chain.apply(inputs))
```


```python
generate_blog_post("environment variables")
```


```python

```
