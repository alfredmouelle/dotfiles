import assert from 'node:assert/strict'
import test from 'node:test'
import { findPxUsages } from './check-px.mjs'

const tokensOf = (contents: string) => findPxUsages(contents).map((usage) => usage.token)

test('px in sizing classes and declarations is reported', () => {
  assert.deepEqual(tokensOf('<p className="text-[13px] leading-5" />'), ['text-[13px]'])
  assert.deepEqual(tokensOf("cn('md:hover:max-w-[calc(100vw-32px)]')"), [
    'md:hover:max-w-[calc(100vw-32px)]',
  ])
  assert.deepEqual(tokensOf('<div className="[width:240px]" />'), ['[width:240px]'])
  assert.deepEqual(tokensOf('  padding: 12px 16px;'), ['12px', '16px'])
  assert.deepEqual(tokensOf("const style = { fontSize: '14px' }"), ['14px'])
})

test('px stays allowed for borders, outlines, rings, shadows, blur, and pill radius', () => {
  assert.deepEqual(
    tokensOf(
      '<p className="border-l-[3px] aria-[current=page]:shadow-[0_1px_2px_oklch(0_0_0/0.12)] blur-[5px] ring-[2px]" />',
    ),
    [],
  )
  assert.deepEqual(tokensOf('<p className="[box-shadow:0_0_0_1px_red]" />'), [])
  assert.deepEqual(tokensOf('  border-left: 3px solid var(--border);'), [])
  assert.deepEqual(tokensOf("  border: '1px solid red',"), [])
  assert.deepEqual(tokensOf('  border-radius: 9999px;'), [])
})

test('reports the line of each usage', () => {
  assert.deepEqual(findPxUsages('a\n  gap: 8px;\nb'), [{ line: 2, token: '8px' }])
})
