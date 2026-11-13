import { atom, read, update } from 'claude-code'
import type { Register } from 'claude-code'

import type { Limit } from '../types'

const GAP = 2
const STYLE = `
svg{--fill:#cfcfcf;--empty:#f1f1f1;--hatch:#dddddd;--tick:#111;--gap:#fff;--txt:#333;--sub:#666;--halo:#fff;--pill:#fff;--pilltxt:#444}
svg.alert{--fill:#e38d88;--empty:#f9e3e1;--hatch:#efc4c1}
svg.good{--fill:#a3d29c;--empty:#e9f4e7;--hatch:#cde6c8}
@media (prefers-color-scheme:dark){
svg{--fill:#6b6b6b;--empty:#2e2e2e;--hatch:#404040;--tick:#f2f2f2;--gap:#1c1c1c;--txt:#eee;--sub:#aaa;--halo:#000;--pill:#2a2a2a;--pilltxt:#ddd}
svg.alert{--fill:#cf6560;--empty:#3d2826;--hatch:#523432}
svg.good{--fill:#6fa86a;--empty:#2b3a2a;--hatch:#3a4e38}}
`.replace(/\n/g, '')
const WINDOWS: Record<string, { label: string; ms: number }> = {
  five_hour: { label: '5h', ms: 5 * 3600_000 },
  seven_day: { label: '7d', ms: 7 * 24 * 3600_000 },
}

const limits = atom({ plugin: 'quota-pace', key: 'limits' } as const, [] as Limit[])

const timeLeft = (limit: Limit): number =>
  limit.resetsAt ? Date.parse(limit.resetsAt) - Date.now() : NaN

const remaining = (limit: Limit): number =>
  Math.max(0, 100 - Math.round(limit.percentUsed))

const BAR_H = 16
const CHAR_PX = 8.8

const barSvg = (limit: Limit, windowMs: number, width: number, name: string): string => {
  const w = Math.max(40, width)
  const fillW = (remaining(limit) / 100) * w
  const left = timeLeft(limit)
  const tickX = Number.isNaN(left) ? -1 : Math.min(1, Math.max(0, left / windowMs)) * w
  const r = BAR_H / 2
  const expected = Number.isNaN(left) ? NaN : (Math.min(left, windowMs) / windowMs) * 100
  const gap = remaining(limit) - expected
  const threshold = windowMs > 24 * 3600_000 ? 10 : 20
  const isAlert = Number.isNaN(gap)
    ? remaining(limit) <= 15
    : gap <= -threshold || (remaining(limit) <= 15 && gap <= -5)
  const isGood = !isAlert && gap >= threshold
  const state = isAlert ? 'alert' : isGood ? 'good' : ''
  const tick =
    tickX < 0
      ? ''
      : `<rect x="${Math.min(w - 4.75, Math.max(0, tickX - 2.375)).toFixed(2)}" y="0" width="4.75" height="${BAR_H}" style="fill:var(--gap)"/><rect x="${Math.min(w - 1.75, Math.max(0, tickX - 0.875)).toFixed(2)}" y="0" width="1.75" height="${BAR_H}" rx="0.875" style="fill:var(--tick)"/>`
  const label = Number.isNaN(left) ? '' : `\u21BB ${duration(left)}`
  const percent = `<text x="${(w / 2).toFixed(1)}" y="${BAR_H / 2 + 3.7}" text-anchor="middle" font-family="-apple-system, system-ui, sans-serif" font-size="10.5" font-weight="600" style="fill:var(--txt);stroke:var(--halo);stroke-opacity:0.6;stroke-width:2.5;paint-order:stroke"><tspan font-weight="400" style="fill:var(--sub)">${name}</tspan><tspan dx="6">${remaining(limit)}%</tspan></text>`
  const pillW = Math.round(label.length * 7 + 14)
  const pill =
    label && w > pillW + 60
      ? `<rect x="${(w - pillW - 5).toFixed(1)}" y="1.5" width="${pillW}" height="${BAR_H - 3}" rx="${(BAR_H - 3) / 2}" style="fill:var(--pill);fill-opacity:0.85"/><text x="${(w - 5 - pillW / 2).toFixed(1)}" y="${BAR_H / 2 + 3.7}" text-anchor="middle" font-family="-apple-system, system-ui, sans-serif" font-size="10.5" style="fill:var(--pilltxt)">${label}</text>`
      : ''
  return `<svg xmlns="http://www.w3.org/2000/svg" class="${state}" width="${w}" height="${BAR_H}" viewBox="0 0 ${w} ${BAR_H}">
<defs><style>${STYLE}</style><pattern id="h" width="6" height="6" patternUnits="userSpaceOnUse" patternTransform="rotate(45)"><rect width="6" height="6" style="fill:var(--empty)"/><rect width="1.5" height="6" style="fill:var(--hatch)"/></pattern>
<clipPath id="c"><rect width="${w}" height="${BAR_H}" rx="${r}"/></clipPath></defs>
<g clip-path="url(#c)"><rect width="${w}" height="${BAR_H}" fill="url(#h)"/>
<rect width="${fillW.toFixed(1)}" height="${BAR_H}" rx="${r}" style="fill:var(--fill)"/></g>${percent}${tick}${pill}</svg>`
}

const duration = (ms: number): string => {
  const m = Math.max(0, Math.round(ms / 60_000))
  const d = Math.floor(m / 1440)
  const h = Math.floor((m % 1440) / 60)
  return d > 0 ? `${d}d ${h}h` : h > 0 ? `${h}h ${String(m % 60).padStart(2, '0')}m` : `${m}m`
}

const DAYS = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']

const clock = (iso: string): string => {
  const at = new Date(iso)
  const now = new Date()
  const days = Math.round(
    (new Date(at.getFullYear(), at.getMonth(), at.getDate()).getTime() -
      new Date(now.getFullYear(), now.getMonth(), now.getDate()).getTime()) /
      86_400_000,
  )
  const day = days <= 0 ? 'today' : days === 1 ? 'tomorrow' : (DAYS[at.getDay()] ?? '')
  const hh = String(at.getHours()).padStart(2, '0')
  const mm = String(at.getMinutes()).padStart(2, '0')
  return `${day} at ${hh}:${mm}`
}

const detail = (limit: Limit, windowMs: number): [string, string][] => {
  const rows: [string, string][] = [['Left', `${remaining(limit)}%`]]
  const left = timeLeft(limit)
  if (Number.isNaN(left) || !limit.resetsAt) return rows
  const expected = Math.round((Math.min(left, windowMs) / windowMs) * 100)
  const gap = remaining(limit) - expected
  rows.push(['Resets', `${clock(limit.resetsAt)} · in ${duration(left)}`])
  rows.push(['Even pace', `${expected}% left by now`])
  rows.push(['Status', gap >= 0 ? `${gap} pts ahead, keep pushing` : `${-gap} pts behind, slow down`])
  return rows
}

const REFRESH_MS = 60_000

export const register: Register = on => {
  let timer: { cancel: () => void } | undefined

  on('session.start', ($, e, next) => {
    timer?.cancel()
    timer = $.clock.every(REFRESH_MS, async () => {
      const { rateLimits } = await $.session.usage()
      const fresh = rateLimits.map(l => ({
        kind: l.kind,
        percentUsed: l.percentUsed,
        resetsAt: l.resetsAt,
      }))
      await update($, limits, () => fresh)
      $.ui.invalidate('ui.render')
    })
    return next(e)
  })

  on('session.measure', async ($, e, next) => {
    $.ui.status(undefined)
    const fresh = e.rateLimits.map(l => ({
      kind: l.kind,
      percentUsed: l.percentUsed,
      resetsAt: l.resetsAt,
    }))
    await update($, limits, () => fresh)
    return next(e)
  })

  on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
    const known = (await read($, limits)).flatMap(l => {
      const w = WINDOWS[l.kind]
      return w ? [{ l, w }] : []
    })
    if (e.props.hasSurvey || known.length === 0) return next(e)

    if (e.surface === 'terminal') return next(e)
    const { Box, Svg, Text } = $.ui.resolve(e)
    const columns = e.props.bodyColumns
    const half = Math.floor((columns - GAP * (known.length - 1)) / known.length)
    const n = Math.max(6, half)

    return (
      <Box width={columns}>
        {known.map(({ l, w }, index) => (
          <Box key={l.kind} alignItems="center" width={half} marginRight={index < known.length - 1 ? GAP : 0}>
            <Box>
              <Svg
                source={barSvg(l, w.ms, Math.floor(n * CHAR_PX), w.label)}
                alt={`${w.label} quota ${remaining(l)}% left`}
                width={Math.floor(n * CHAR_PX)}
                height={BAR_H}
              />
            </Box>
            <Box
              position="absolute"
              bottom={1}
              left={0}
              width={52}
              flexDirection="column"
              borderStyle="round"
              paddingX={2}
              display="none"
              hover={{ display: 'flex' }}
            >
              <Text bold>{w.label === '5h' ? '5-hour window' : '7-day window'}</Text>
              {detail(l, w.ms).map(([label, value]) => (
                <Box>
                  <Box width={12}>
                    <Text dimColor>{label}</Text>
                  </Box>
                  <Text>{value}</Text>
                </Box>
              ))}
            </Box>
          </Box>
        ))}
      </Box>
    )
  })
}
