"""
FastAPI orchestrator for the Edestory platform.

This service provides endpoints for coordinating AI models, fetching
presenter definitions, and acting as a design registry.  It is intended
to run in Cloud Run behind an HTTPS load balancer and communicates with
the storefront and other services via REST or GraphQL.
"""

from fastapi import FastAPI, HTTPException

app = FastAPI(title="Edestory Orchestrator", version="0.1.0")


@app.get("/")
async def root() -> dict[str, str]:
    """Root endpoint returns a simple health check message."""
    return {"message": "Edestory orchestrator is up and running"}


@app.get("/design-registry/{component}")
async def get_component(component: str) -> dict[str, str]:
    """
    Placeholder design registry endpoint.  In future iterations, this
    will return the JSON schema or component configuration for the
    requested UI component.
    """
    # For now we just return a stub response.
    r
    
    eturn {"component": component, "status": "not implemented"}

# Diary models and endpoints
import json
import uuid
from enum import Enum
from pathlib import Path
from pydantic import BaseModel

# Path to store diary entries in JSON
DATA_FILE = Path(__file__).with_name("diary_entries.json")

class DiaryStatus(str, Enum):
    PENDING_APPROVAL = "PENDING_APPROVAL"
    PLAN = "PLAN"
    REJECTED = "REJECTED"

class DiaryIn(BaseModel):
    content: str

class DiaryEntry(DiaryIn):
    id: str
    status: DiaryStatus
    approved: bool | None = None

def load_entries() -> list[DiaryEntry]:
    """Load diary entries from the JSON file."""
    if DATA_FILE.exists():
        try:
            data = json.loads(DATA_FILE.read_text())
            return [DiaryEntry(**entry) for entry in data]
        except Exception:
            return []
    return []

def save_entries(entries: list[DiaryEntry]):
    """Persist diary entries to the JSON file."""
    DATA_FILE.write_text(json.dumps([entry.dict() for entry in entries], indent=2))

@app.get("/api/diary")
async def list_entries() -> list[DiaryEntry]:
    """Return all diary entries."""
    return load_entries()

@app.post("/api/diary/ingest")
async def ingest_diary(entry: DiaryIn) -> DiaryEntry:
    """Ingest a new diary entry in pending state."""
    entries = load_entries()
    new_entry = DiaryEntry(id=str(uuid.uuid4()), content=entry.content, status=DiaryStatus.PENDING_APPROVAL)
    entries.append(new_entry)
    save_entries(entries)
    return new_entry

class ApproveRequest(BaseModel):
    id: str
    approve: bool

@app.post("/api/diary/approve")
async def approve_diary(req: ApproveRequest) -> DiaryEntry:
    """Approve or reject a pending diary entry."""
    entries = load_entries()
    for idx, e in enumerate(entries):
        if e.id == req.id:
            if e.status != DiaryStatus.PENDING_APPROVAL:
                raise HTTPException(status_code=400, detail="Entry is not pending approval")
            # Update status based on approval flag
            e.status = DiaryStatus.PLAN if req.approve else DiaryStatus.REJECTED
            e.approved = req.approve
            entries[idx] = e
            save_entries(entries)
            return e
    raise HTTPException(status_code=404, detail="Entry not found")

@app.post("/api/diary/summarize")
async def summarize_diary() -> dict[str, list[DiaryEntry]]:
    """Return a summary of diary entries grouped by status."""
    entries = load_entries()
    summary = {
        "PLAN": [e for e in entries if e.status == DiaryStatus.PLAN],
        "PENDING_APPROVAL": [e for e in entries if e.status == DiaryStatus.PENDING_APPROVAL],
        "REJECTED": [e for e in entries if e.status == DiaryStatus.REJECTED],
    }
    return summary
