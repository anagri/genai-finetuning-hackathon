# genai-finetuning-hackathon

The following is part of GenAI Fine Tuning Hackathon submission - https://hasgeek.com/generativeAI/gen-ai-hack-day/


# Demo Video

https://www.loom.com/share/220bd480f4774ede98553a1a4c0466cc?sid=4384441a-1a6f-4f87-9a50-4e72e5b3df6d

# Idea

The idea addresses 2 issues that are problematic when you are using GenAI code tools like Code-Interpreter or Co-pilot.

1. Domain knowledge not up-to-date
2. Specific library knowledge

## 1. Domain knowledge not up-to-date
All the Large Langauge Models have a data cut off date. For e.g. OpenAI GPT has a cut-off date of Sep 2021. So if you ask the model related to any recent happenings or changes, it does not have any information regarding that.

This is much bigger problem when you are using a Code tools. It either gives you answers based on old version of the library that are no longer applicable, or hallucinates.

## 2. Specific library knowledge

For code completion tools like CodeInterpreter and Co-pilot, the underlying LLM is trained on a large corpus of data and not specifically on the library of your interest. Thus, it tends to hallucinates when generating code for your specific library.

# Solution

With the PEFT technique, now you can generate a knowledgebase specific to a subject. Thus we can use PEFT to create adapters for a specific library, and plug it in when asking questions related to that specific library.

**For the hackathon, we have fine-tuned WizardCoder-3B model on the langchain library.**

# Setup

install requirements from `requirements.txt`

# Preparing Dataset

For the training data, we used the readily available langchain guides in jupyter notebook format. We did the following to prepare the data to train the model -

1. We selected 12 jupyter notebook guides from langchain repos - https://github.com/langchain-ai/langchain/tree/master/docs/extras/guides . The selected guides are in `use-cases` folder.

2. We converted these jupyter notebook guides into markdown file using `jupyter nbconvert` extension. The script to convert the guides is in `convert-to-md.sh`, and converted notebooks are in `use-cases-md` folder.

3. Next we used the markdown guides as context, and asked GPT-4 to generate training data in the format below - 

```
Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
Using the python langchain library, {instruction}

### Response:
{response}
```

The code to query GPT-4 and parsing the training data is in notebook `automate.ipynb`. The responses received from GPT-4 are in `responses` folder, and training data parsed are in `training-data` folder. We had around 48 training data points. The final training data required by WizardCoder is in `final-data/code-assist.jsonl`.

4. We then used WizardCoder code itself to fine-tune a PEFT adapter using the above training data. The code to finetune the model is in `train.ipynb`

Once training is complete, the adapter is uploaded to huggingface inside repo `amir36/langchain_adapter`.

5. The code to compare the baseline performance vs the PEFT performance is in `inference.ipynb`

# Conclusion

The non-finetuned foundation model hallucinates and does not generate a valid python code for the langchain library.

The fine-tuned model does generate valid python code for langchain library. But it also makes mistakes or hallucinates in some cases.

With more training data, longer training, larger foundation model, some of these issues can be fixed.
