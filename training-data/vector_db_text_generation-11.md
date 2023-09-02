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
