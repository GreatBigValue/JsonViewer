export interface JsonDocument {
  id: string;
  name: string | null;
  content: any;
  createdAt: string;
}

const API_URL = process.env.NEXT_PUBLIC_BACKEND_URL || 'http://localhost:3001';

export async function fetchAllDocuments(): Promise<JsonDocument[]> {
  const response = await fetch(`${API_URL}/json`);

  if (!response.ok) {
    throw new Error(`Failed to fetch documents: ${response.status}`);
  }

  return await response.json();
}

export async function fetchDocument(id: string): Promise<JsonDocument> {
  const response = await fetch(`${API_URL}/json/${id}`);

  if (!response.ok) {
    throw new Error(`Failed to fetch document: ${response.status}`);
  }

  return await response.json();
}

export async function saveDocument(content: any, name?: string): Promise<JsonDocument> {
  const response = await fetch(`${API_URL}/json`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      content,
      name,
    }),
  });

  if (!response.ok) {
    throw new Error(`Failed to save document: ${response.status}`);
  }

  return await response.json();
}

export async function deleteDocument(id: string): Promise<void> {
  const response = await fetch(`${API_URL}/json/${id}`, {
    method: 'DELETE',
  });

  if (!response.ok) {
    throw new Error(`Failed to delete document: ${response.status}`);
  }
}
