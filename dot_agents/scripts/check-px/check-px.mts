import { readdir, readFile } from 'node:fs/promises'
import { relative } from 'node:path'
import { fileURLToPath, pathToFileURL } from 'node:url'

type PxUsage = { line: number; token: string }

const sourceDirectory = fileURLToPath(new URL('../src/', import.meta.url))
const excludedDirectories = [/^emails(\/|$)/]
const scannedExtensions = /\.(css|ts|tsx)$/
const allowedUtilities =
  /^!?-?(shadow|inset-shadow|drop-shadow|border|outline|ring|inset-ring|blur|divide)(-|$)/
const allowedProperties = /^(border|boxshadow|outline|textshadow)/
const pillRadius = '9999px'

function utilityOf(token: string) {
  let depth = 0
  let start = 0
  for (const [index, character] of [...token].entries()) {
    if (character === '[' || character === '(') {
      depth += 1
    } else if (character === ']' || character === ')') {
      depth -= 1
    } else if (character === ':' && depth === 0) {
      start = index + 1
    }
  }
  return token.slice(start)
}

function isAllowed(token: string, linePrefix: string) {
  if (token.includes(pillRadius)) {
    return true
  }
  if (token.includes('[')) {
    const utility = utilityOf(token)
    if (utility.startsWith('[')) {
      const property = utility.slice(1, utility.indexOf(':')).replaceAll('-', '').toLowerCase()
      return allowedProperties.test(property)
    }
    return allowedUtilities.test(utility)
  }
  const property = linePrefix.match(/([A-Za-z-]+)\s*:[^:;{}]*$/)?.[1]
  return (
    property !== undefined && allowedProperties.test(property.replaceAll('-', '').toLowerCase())
  )
}

export function findPxUsages(contents: string): PxUsage[] {
  const usages: PxUsage[] = []
  for (const [index, line] of contents.split(/\r?\n/).entries()) {
    for (const match of line.matchAll(/(?<![\w.])\d*\.?\d+px\b/g)) {
      const before = line.slice(0, match.index)
      const after = line.slice(match.index)
      const tokenStart = before.search(/[^\s'"`]*$/)
      const tokenEnd = after.search(/[\s'"`]|$/)
      const token = before.slice(tokenStart) + after.slice(0, tokenEnd)
      if (!isAllowed(token, before)) {
        usages.push({ line: index + 1, token: token.includes('[') ? token : match[0] })
      }
    }
  }
  return usages
}

export async function main() {
  const entries = await readdir(sourceDirectory, { recursive: true })
  const files = entries
    .filter((entry) => scannedExtensions.test(entry))
    .filter((entry) => !excludedDirectories.some((pattern) => pattern.test(entry)))
    .sort()

  let count = 0
  for (const file of files) {
    const path = `${sourceDirectory}${file}`
    for (const usage of findPxUsages(await readFile(path, 'utf8'))) {
      count += 1
      process.stdout.write(`${relative(process.cwd(), path)}:${usage.line}: ${usage.token}\n`)
    }
  }

  if (count > 0) {
    process.stdout.write(
      `${count} px value(s) found: use rem or spacing tokens (px stays allowed for borders, outlines, rings, shadows, and blur).\n`,
    )
    process.exitCode = 1
  }
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  await main()
}
