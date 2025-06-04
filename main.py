from fastapi import FastAPI
from pydantic import BaseModel
import json

app = FastAPI()

class JsonRequest(BaseModel):
    data: str

@app.post("/prettify")
def prettify_json(request: JsonRequest):
    try:
        parsed = json.loads(request.data)
        return {"prettified": json.dumps(parsed, indent=4)}
    except json.JSONDecodeError:
        return {"error": "Invalid JSON"}
