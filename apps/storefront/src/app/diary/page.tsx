import React, { useEffect, useState } from 'react';

interface DiaryEntry {
  id: string;
  content: string;
  status: string;
  approved?: boolean;
}

export default function DiaryPage() {
  const [entries, setEntries] = useState<DiaryEntry[]>([]);
  const [filter, setFilter] = useState<string>('all');

  useEffect(() => {
    fetch('/api/diary')
      .then((res) => res.json())
      .then((data) => setEntries(data))
      .catch((err) => console.error(err));
  }, []);

  const filtered = entries.filter((entry) => {
    return filter === 'all' || entry.status === filter;
  });

  return (
    <div className="container mx-auto p-4">
      <h1 className="text-2xl font-bold mb-4">Diary entries</h1>
      <div className="mb-4">
        <label className="mr-2">Filter:</label>
        <select
          value={filter}
          onChange={(e) => setFilter(e.target.value)}
          className="border p-1"
        >
          <option value="all">All</option>
          <option value="PENDING_APPROVAL">Pending</option>
          <option value="PLAN">Plan</option>
          <option value="REJECTED">Rejected</option>
        </select>
      </div>
      <ul className="space-y-2">
        {filtered.map((entry) => (
          <li key={entry.id} className="border p-2 rounded">
            <p className="font-semibold">{entry.content}</p>
            <p className="text-sm text-gray-500">Status: {entry.status}</p>
          </li>
        ))}
        {filtered.length === 0 && <li>No entries found</li>}
      </ul>
    </div>
  );
}
