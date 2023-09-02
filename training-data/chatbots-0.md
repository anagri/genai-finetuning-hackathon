Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Install the required dependencies and set the necessary credentials to use langchain and openai. Replace the openai API key with your own.

### Response:
```python
!pip install langchain openai 

import os
os.environ['OPENAI_API_KEY'] = 'your-api-key-here'
```