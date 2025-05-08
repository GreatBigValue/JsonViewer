'use client'

import { useState } from 'react'
import { Card, CardBody, Divider } from '@nextui-org/react'
import JsonInput from '@/components/JsonInput'
import JsonViewer from '@/components/JsonViewer'

export default function Home() {
  const [jsonData, setJsonData] = useState<any>(null)
  const [error, setError] = useState<string | null>(null)

  const handleJsonParse = (data: any) => {
    setJsonData(data)
    setError(null)
  }

  const handleError = (errorMessage: string) => {
    setError(errorMessage)
    setJsonData(null)
  }

  return (
    <div className="space-y-8">
      <h1 className="text-4xl font-bold text-center mb-8">JSON Hierarchical Viewer</h1>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <div>
          <h2 className="text-2xl font-semibold mb-4">JSON Input</h2>
          <JsonInput onParse={handleJsonParse} onError={handleError} />
        </div>

        <div>
          <h2 className="text-2xl font-semibold mb-4">JSON Tree View</h2>
          {error ? (
            <Card>
              <CardBody className="text-red-500 dark:text-red-400">
                {error}
              </CardBody>
            </Card>
          ) : jsonData ? (
            <JsonViewer data={jsonData} />
          ) : (
            <Card>
              <CardBody className="text-gray-500 dark:text-gray-400">
                Enter valid JSON to see the tree view
              </CardBody>
            </Card>
          )}
        </div>
      </div>
    </div>
  )
}
