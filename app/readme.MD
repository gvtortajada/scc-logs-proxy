# Local

```
python3 -m virtualenv venv
source venv/bin/activate
pip install -r requirements.txt
```

```
curl -d '{"message":{"data":"SGVsbG8hIEkgYW0gYSBhd2Vzb21lIG1lc3NhZ2Uh"}}' -H "Content-Type: application/json" -X POST http://localhost:8080
```