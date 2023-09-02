Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Set up the model with correct parameters as per documentation.

### Response:
```python
from langchain.llms import LlamaCpp
from langchain.callbacks.manager import CallbackManager
from langchain.callbacks.streaming_stdout import StreamingStdOutCallbackHandler

n_gpu_layers = 1  # Follow the guidelines in the document. 
n_batch = 256  # Adjust these values based on your system resources.
callback_manager = CallbackManager([StreamingStdOutCallbackHandler()])

llm = LlamaCpp(
    model_path="/path/to/your/model/file",
    n_gpu_layers=n_gpu_layers,
    n_batch=n_batch,
    n_ctx=2048,
    f16_kv=True,
    callback_manager=callback_manager,
    verbose=True,
)
```