'use client'

import { useEffect, useState } from 'react'
import { Card, CardBody, Button, Chip, Spinner } from '@nextui-org/react'
import JsonViewer from '@/components/JsonViewer'
import { JsonDocument, fetchAllDocuments, deleteDocument } from '@/services/api'

export default function SavedPage() {
  const [documents, setDocuments] = useState<JsonDocument[]>([])
  const [selectedDoc, setSelectedDoc] = useState<JsonDocument | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    loadDocuments()
  }, [])

  const loadDocuments = async () => {
    try {
      setLoading(true)
      const docs = await fetchAllDocuments()
      setDocuments(docs)
      setError(null)
    } catch (err) {
      setError(`Error loading documents: ${(err as Error).message}`)
    } finally {
      setLoading(false)
    }
  }

  const handleDelete = async (id: string) => {
    if (!confirm('Are you sure you want to delete this document?')) {
      return
    }

    try {
      await deleteDocument(id)
      setDocuments(documents.filter(doc => doc.id !== id))
      if (selectedDoc?.id === id) {
        setSelectedDoc(null)
      }
    } catch (err) {
      alert(`Error deleting document: ${(err as Error).message}`)
    }
  }

  const formatDate = (dateStr: string) => {
    const date = new Date(dateStr)
    return date.toLocaleString()
  }

  return (
    <div className="space-y-8">
      <h1 className="text-4xl font-bold text-center mb-8">Saved JSON Documents</h1>

      {loading ? (
        <div className="flex justify-center py-8">
          <Spinner size="lg" />
        </div>
      ) : error ? (
        <Card>
          <CardBody className="text-red-500 dark:text-red-400">
            {error}
          </CardBody>
        </Card>
      ) : documents.length === 0 ? (
        <Card>
          <CardBody className="text-center py-8">
            <p className="text-gray-500 dark:text-gray-400">No saved documents found</p>
          </CardBody>
        </Card>
      ) : (
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          <div className="lg:col-span-1">
            <h2 className="text-2xl font-semibold mb-4">Documents</h2>
            <Card>
              <CardBody className="p-2">
                <div className="space-y-2 max-h-[600px] overflow-auto">
                  {documents.map((doc) => (
                    <Card
                      key={doc.id}
                      isPressable
                      isHoverable
                      className={selectedDoc?.id === doc.id ? 'border-primary' : ''}
                      onPress={() => setSelectedDoc(doc)}
                    >
                      <CardBody className="p-3">
                        <div className="font-medium">{doc.name || 'Unnamed Document'}</div>
                        <div className="text-xs text-gray-500 dark:text-gray-400 mt-1">
                          {formatDate(doc.createdAt)}
                        </div>
                        <div className="mt-2">
                          <Button
                            color="danger"
                            size="sm"
                            onClick={(e) => {
                              e.stopPropagation()
                              handleDelete(doc.id)
                            }}
                          >
                            Delete
                          </Button>
                        </div>
                      </CardBody>
                    </Card>
                  ))}
                </div>
              </CardBody>
            </Card>
          </div>

          <div className="lg:col-span-2">
            <h2 className="text-2xl font-semibold mb-4">JSON Preview</h2>
            {selectedDoc ? (
              <JsonViewer data={selectedDoc.content} />
            ) : (
              <Card>
                <CardBody className="text-gray-500 dark:text-gray-400">
                  Select a document to view
                </CardBody>
              </Card>
            )}
          </div>
        </div>
      )}
    </div>
  )
}
