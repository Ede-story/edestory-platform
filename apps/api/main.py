from fastapi import FastAPI
from pydantic import BaseModel
from typing import List

app = FastAPI(title="Diary API (repo)")

class IngestReq(BaseModel):
    title: str = "repo"
    content: str = "ok"

@app.get("/api/diary")
def list_diary() -> List[dict]:
    return []

@app.post("/api/diary/ingest", status_code=202)
def ingest(req: IngestReq):
    return {"status": "PENDING_APPROVAL", "id": "repo-1"}

@app.post("/api/diary/approve")
def approve():
    return {"status": "PLAN"}

@app.post("/api/diary/summarize")
def summarize():
    return {"summary": "empty"}
