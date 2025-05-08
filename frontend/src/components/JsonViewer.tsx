'use client'

import { useState } from 'react'
import { Card, CardBody } from "@nextui-org/react"

interface JsonViewerProps {
  data: any;
}

interface JsonNodeProps {
  name: string | null;
  value: any;
  isRoot?: boolean;
  level: number;
}

const JsonNode = ({ name, value, isRoot = false, level }: JsonNodeProps) => {
  const [isExpanded, setIsExpanded] = useState(isRoot || level < 2)

  const getType = (val: any): string => {
    if (val === null) return 'null'
    if (Array.isArray(val)) return 'array'
    return typeof val
  }

  const formatValue = (val: any, type: string): string => {
    switch (type) {
      case 'string':
        return `"${val}"`
      case 'null':
        return 'null'
      default:
        return String(val)
    }
  }

  const getValueClassName = (type: string): string => {
    switch (type) {
      case 'string':
        return 'text-green-600 dark:text-green-400'
      case 'number':
        return 'text-blue-600 dark:text-blue-400'
      case 'boolean':
        return 'text-purple-600 dark:text-purple-400'
      case 'null':
        return 'text-gray-500 dark:text-gray-400'
      case 'object':
      case 'array':
        return 'text-orange-600 dark:text-orange-400'
      default:
        return ''
    }
  }

  const type = getType(value)
  const isExpandable = type === 'object' || type === 'array'
  const isEmpty = isExpandable && Object.keys(value).length === 0

  const toggleExpand = () => {
    if (isExpandable) {
      setIsExpanded(!isExpanded)
    }
  }

  return (
    <div className="font-mono text-sm">
      <div
        className={`flex items-start ${isExpandable ? 'cursor-pointer' : ''} hover:bg-gray-100 dark:hover:bg-gray-800 py-1 rounded pl-${level * 4}`}
        onClick={toggleExpand}
      >
        {isExpandable && !isEmpty && (
          <span className="mr-1 text-gray-500 w-4">
            {isExpanded ? '▼' : '►'}
          </span>
        )}
        {isExpandable && isEmpty && (
          <span className="mr-1 text-gray-500 w-4">□</span>
        )}
        {!isExpandable && (
          <span className="mr-1 w-4"></span>
        )}

        {name !== null && (
          <span className="font-semibold mr-1">
            {`"${name}": `}
          </span>
        )}

        {isExpandable ? (
          <span className={getValueClassName(type)}>
            {type === 'array' ? '[' : '{'}
            {!isExpanded && '...'}
            {!isExpanded && (type === 'array' ? ']' : '}')}
            {isExpanded && isEmpty && (type === 'array' ? ']' : '}')}
          </span>
        ) : (
          <span className={getValueClassName(type)}>
            {formatValue(value, type)}
          </span>
        )}
      </div>

      {isExpandable && isExpanded && !isEmpty && (
        <div className="ml-4 border-l-2 border-gray-200 dark:border-gray-700 pl-2">
          {Object.entries(value).map(([key, val]) => (
            <JsonNode
              key={key}
              name={type === 'array' ? null : key}
              value={val}
              level={level + 1}
            />
          ))}
          <div className={`text-gray-600 dark:text-gray-400 pl-${level * 4}`}>
            {type === 'array' ? ']' : '}'}
          </div>
        </div>
      )}
    </div>
  )
}

export default function JsonViewer({ data }: JsonViewerProps) {
  return (
    <Card>
      <CardBody className="overflow-auto max-h-[600px]">
        <JsonNode name={null} value={data} isRoot={true} level={0} />
      </CardBody>
    </Card>
  )
}
