9.
### Instruction:
Create a system message and a prompt for the agent using the OpenAIFunctionsAgent.

### Response:
```python
from langchain.agents.openai_functions_agent.base import OpenAIFunctionsAgent
from langchain.schema.messages import SystemMessage
from langchain.prompts import MessagesPlaceholder

system_message = SystemMessage(
        content=(
            "Do your best to answer the questions. "
        )
)
prompt = OpenAIFunctionsAgent.create_prompt(
        system_message=system_message,
        extra_prompt_messages=[MessagesPlaceholder(variable_name=memory_key)]
 )
```