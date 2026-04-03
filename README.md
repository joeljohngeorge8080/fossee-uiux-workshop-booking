# LearnForge — FOSSEE UI/UX Screening Task

This is my submission for the FOSSEE UI/UX screening task. The base project had the routing and pages already set up, but it felt pretty bare to use — no way to find a specific workshop, no feedback on form errors until you submit, nothing. So I focused on making it actually usable.

---

## What I Changed (Before vs After)

| Area | Before | After |
|---|---|---|
| Workshop list | Static grid, no filtering | Search bar + level filter pills |
| Empty states | Just a plain text message | Icon, message, and a reset button |
| Form validation | Errors only on submit | Shows errors on blur, clears when fixed |
| Loading | Nothing while fetching | Spinner with screen reader support |
| Urgency cues | None | "🔥 3 left" chip and sold-out badge |
| Navigation | Plain links | Active page highlighted in Navbar |
| Card height | Inconsistent | Excerpt clamped to 3 lines |
| Accessibility | Minimal | `aria-*` attributes + semantic HTML throughout |

---

## Design Principles

A few things I kept reminding myself:

- **Make things obvious** — If spots are running low, show it on the card. Don't hide it behind a tooltip or a separate page.
- **Don't show everything at once** — The toolbar (search + filters) only shows up after workshops load. No point cluttering the screen while it's still loading.
- **Validate at the right time** — Showing errors while someone is still typing is annoying. So errors show up when you leave a field, and go away the moment you fix it.
- **Keep it simple** — I didn't add any animation libraries or global state. If a `useMemo` and a CSS transition can do the job, that's enough.

---

## Responsiveness

Used CSS Grid with breakpoints:

- **Mobile (< 640px):** Cards in a single column, toolbar wraps to two rows
- **Tablet (640–1023px):** Two-column grid, toolbar on one row
- **Desktop (≥ 1024px):** Three-column grid

The search input has a `max-width` so it doesn't look weird on big screens. Filter pills use `flex-wrap` so they wrap naturally. The workshop details page switches from a single column to a side-by-side info+form layout at 768px — all done in CSS, no JS.

---

## Trade-offs

A couple of decisions I made and why:

- **Consistent card height vs showing full content** — I used `-webkit-line-clamp` to cut card excerpts at 3 lines. Some content gets hidden, but the grid looks way better when all cards are the same height. Full description is on the details page anyway.
- **Simple search vs fuzzy search** — Search uses `toLowerCase().includes()`. It won't handle typos, but it's fast, readable, and adds zero dependencies. For 4 workshops, it's more than enough.
- **Skipped sorting** — Adding sort-by-date or sort-by-price would have needed a dropdown or extra state. It felt like over-engineering for this scope, so I left it out.
- **`useMemo` for filtering** — Small win on a tiny dataset, but it's the right habit and the pattern works cleanly if the list ever grows.

---

## Challenges

The hardest part was the form validation hook.

The original `handleChange` had a stale closure issue — it captured the `values` from when the component first rendered, so quick edits could overwrite each other. I fixed it by switching to functional `setValues(prev => ...)` updates and storing the validate function in a `useRef` so the callbacks don't need to be re-created on every render.

The side effect of that fix was that error clearing also became reliable — errors update inside the same state setter call, so you never see a frame where the value is updated but a stale error is still showing.

---

## Features Added

**Workshop List**
- Real-time search — matches title, instructor, and excerpt
- Level filter pills (All / Beginner / Intermediate / Advanced) — works together with search
- Clear (✕) button inside the search input
- "No workshops found" state — icon, message, fade-in animation, and a reset button

**Workshop Cards**
- "🔥 N left" chip when ≤ 5 spots remain
- Sold-out badge + disabled CTA
- Subtle hover lift animation
- 3-line excerpt clamp for consistent card heights

**Workshop Details**
- Meta info (date, instructor, duration, price) laid out in individual cards
- Warning banner when spots are low
- Graceful "not found" page with a back link

**Registration Form**
- Blur validation (not on keystroke)
- Errors clear in real time once fixed
- Form locked during submission with a loading state
- Success toast after registration

**Accessibility**
- `aria-pressed` on filter buttons
- `aria-live="polite"` on loading/empty states
- `role="search"` and `role="group"` on the toolbar
- Keyboard-friendly — focus rings, correct tab order, `tabIndex=-1` on disabled buttons

---

## Tech Stack

| Tool | Why |
|---|---|
| React 18 | UI |
| React Router v6 | Routing |
| CSS Modules | Scoped styles without a CSS-in-JS library |
| Vite | Fast dev server |
| No UI component library | Everything built from scratch |

---

## Running Locally

```bash
git clone <repo-url>
cd FOSSEE/frontend

npm install
npm run dev
```

Opens at `http://localhost:5173`.

---

## Screenshots

### Default State
![All workshops shown with search and filter toolbar](./screenshots/workshop-list.png)

### Search Filtered
![Search results for "react"](./screenshots/search-filtered.png)

### Empty State
![No results found view](./screenshots/empty-state.png)

### Workshop Details
![Details page with meta cards and registration form](./screenshots/workshop-details.png)

> Add images to a `/screenshots` folder and the paths above will work.

---

## Project Structure

```
frontend/src/
├── components/
│   ├── Layout/           # App shell
│   ├── Navbar/           # Nav with active route highlight
│   ├── WorkshopCard/     # Card with badge, chip, CTA
│   ├── RegistrationForm/ # Form with validation
│   ├── StatusMessage/    # Success/error block
│   └── Toast/            # Post-submit notification
├── hooks/
│   └── useFormValidation.js
├── pages/
│   ├── WorkshopList/     # Search + filter + grid
│   └── WorkshopDetails/  # Info + registration
└── styles/               # Global CSS tokens
```
