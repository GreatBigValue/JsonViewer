'use client'

import { useState } from 'react'
import { Button, Input, Textarea, Card, CardBody, CardFooter } from "@nextui-org/react"
import { saveDocument } from '@/services/api'

interface JsonInputProps {
  onParse: (data: any) => void;
  onError: (error: string) => void;
}

export default function JsonInput({ onParse, onError }: JsonInputProps) {
  const [jsonText, setJsonText] = useState('')
  const [name, setName] = useState('')
  const [isSaving, setIsSaving] = useState(false)

  const handleTextChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setJsonText(e.target.value)
  }

  const handleParse = () => {
    try {
      const parsedData = JSON.parse(jsonText)
      onParse(parsedData)
    } catch (err) {
      onError(`Invalid JSON: ${(err as Error).message}`)
    }
  }

  const handleFormatJson = () => {
    try {
      const parsed = JSON.parse(jsonText)
      const formatted = JSON.stringify(parsed, null, 2)
      setJsonText(formatted)
      onParse(parsed)
    } catch (err) {
      onError(`Invalid JSON: ${(err as Error).message}`)
    }
  }

  const handleSave = async () => {
    try {
      setIsSaving(true)
      const parsed = JSON.parse(jsonText)
      await saveDocument(parsed, name || undefined)
      alert('JSON saved successfully')
    } catch (err) {
      alert(`Error saving JSON: ${(err as Error).message}`)
    } finally {
      setIsSaving(false)
    }
  }

  const handleLoadExample = () => {
    const example = {
      name: "John Doe",
      age: 30,
      isActive: true,
      address: {
        street: "123 Main St",
        city: "Anytown",
        zipCode: "12345"
      },
      phoneNumbers: [
        {
          type: "home",
          number: "555-1234"
        },
        {
          type: "work",
          number: "555-5678"
        }
      ],
      tags: ["developer", "javascript", "typescript"],
      settings: null
    }

    const exampleText = JSON.stringify(example, null, 2)
    setJsonText(exampleText)
    onParse(example)
  }

  return (
    <Card>
      <CardBody className="gap-4">
        <Input
          label="Name (optional)"
          placeholder="Enter a name for this JSON"
          value={name}
          onChange={(e) => setName(e.target.value)}
        />

        <Textarea
          label="JSON Input"
          placeholder="Paste your JSON here..."
          value={jsonText}
          onChange={handleTextChange}
          minRows={15}
          className="font-mono text-sm"
        />
      </CardBody>

      <CardFooter>
        <div className="flex flex-wrap gap-2">
          <Button color="primary" onClick={handleParse}>
            Parse JSON
          </Button>
          <Button color="secondary" onClick={handleFormatJson}>
            Format JSON
          </Button>
          <Button color="success" onClick={handleLoadExample}>
            Load Example
          </Button>
          <Button
            color="default"
            onClick={handleSave}
            isLoading={isSaving}
          >
            Save JSON
          </Button>
        </div>
      </CardFooter>
    </Card>
  )
}
