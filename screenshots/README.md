# Screenshots

Add two screenshots here:

| File | Content |
|------|---------|
| `before.png` | Screenshot of the original FOSSEE workshop booking site |
| `after.png`  | Screenshot of your enhanced version |

## How to take screenshots

### Option A — Browser DevTools (recommended)
1. Open Chrome / Edge
2. Press F12 → Toggle device toolbar (Ctrl+Shift+M)
3. Select "iPhone SE" (375px) for the mobile view
4. Screenshot with Ctrl+Shift+P → "Capture full size screenshot"

### Option B — npm package
```bash
npm install -g pageres-cli
pageres http://localhost:5173 375x812 1280x800 --filename='screenshots/<%= date %>'
```

## Before screenshot
Take this from: https://fossee.in/workshop/

## After screenshot
Take this from: http://localhost:5173 (after running npm run dev)
