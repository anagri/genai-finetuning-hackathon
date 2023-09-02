### Instruction:
Initialize Elasticsearch python client and populate your database with some sample customers data.

### Response:
```python
from elasticsearch import Elasticsearch
ELASTIC_SEARCH_SERVER = "https://elastic:pass@localhost:9200"
db = Elasticsearch(ELASTIC_SEARCH_SERVER)
customers = [{"firstname": "Jennifer", "lastname": "Walters"},{"firstname": "Monica","lastname":"Rambeau"},{"firstname": "Carol","lastname":"Danvers"}]
for i, customer in enumerate(customers):
    db.create(index="customers", document=customer, id=i)
```