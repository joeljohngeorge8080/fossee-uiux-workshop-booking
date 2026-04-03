# LearnForge — FOSSEE UI/UX Screening Task

A UI/UX improvement of an existing React-based workshop booking site. The original site had the core structure in place — pages, routing, and a registration form — but the experience felt bare. This submission focuses on making the interface cleaner, more interactive, and easier to use without touching the backend or adding unnecessary complexity.

---

## Before vs After

| Area | Before | After |
|---|---|---|
| Workshop list | Static grid, no way to find a specific workshop | Real-time search + level filter pills |
| Empty states | Generic "no workshops" text | Illustrated empty state with a reset button |
| Form validation | Errors shown only on submit | Inline errors on blur, real-time feedback on change |
| Loading states | No feedback during data fetch | Spinner with `aria-live` for screen readers |
| Urgency cues | None | "🔥 3 left" chip and sold-out badge on cards |
| Navigation | Plain links | Active route highlighting on Navbar |
| Card layout | Uniform height regardless of content | Clamped excerpt (3 lines) keeps grid visually consistent |
| Accessibility | Minimal | `aria-pressed`, `aria-label`, `role`, semantic HTML throughout |

---

## Design Principles

A few ideas guided every decision:

- **Show, don't tell** — Instead of writing "few spots left" in a tooltip, show a 🔥 chip directly on the card so users notice it without extra effort.
- **Progressive disclosure** — The search bar and filter pills only appear after the workshops load. No toolbar cluttering the screen during the loading state.
- **Feedback at the right moment** — Form fields validate on blur (not on every keystroke) so users aren't interrupted while typing. The error clears the moment the field becomes valid.
- **Don't add what you don't need** — No animation libraries, no global state, no extra hooks. If something could be done with a `useMemo` and a CSS transition, that's how it was done.

---

## Responsiveness

The layout uses CSS Grid with breakpoint-based column counts:

- **Mobile (< 640px):** Single column — cards stack vertically, toolbar wraps into two rows
- **Tablet (640px–1023px):** Two-column card grid, toolbar fits on one row
- **Desktop (≥ 1024px):** Three-column grid

The search bar has a `max-width` so it doesn't stretch awkwardly on wide screens. Filter pills use `flex-wrap` so they wrap naturally on smaller viewports. The workshop details page switches between a single-column stack and a two-column info+form layout using a CSS Grid breakpoint — no JavaScript involved.

---

## Trade-offs

**Design vs. performance:**
- Workshop filtering uses `useMemo` to avoid recomputing on every render. Since the dataset is small (4 workshops), this is a minor win, but the pattern scales cleanly if the list grows.
- Cards use `-webkit-line-clamp` to cap excerpt height at 3 lines. This is a visual trade-off: some content is hidden, but card heights stay consistent across the grid, which looks much better than jagged columns.

**Simplicity vs. features:**
- Sorting (by date, price) was intentionally skipped. Adding it would have meant either a more complex filter bar or a dropdown — both felt like overkill for 4 workshops. The task asked for meaningful improvements, not every possible feature.
- The search matches against title, instructor, and excerpt text. Fuzzy search (e.g., Fuse.js) would be more forgiving of typos but adds a dependency. The current `toLowerCase().includes()` approach is fast, readable, and dependency-free.

---

## Challenges

**The trickiest part was the form validation logic.**

The original hook had a stale closure bug — `handleChange` closed over the initial `values` snapshot, so rapid edits could lose earlier changes. The fix was to use functional `setValues(prev => ...)` updates and a `useRef` to hold the latest `validate` function. This meant the `handleChange` and `handleBlur` callbacks could stay stable (no deps array churn) while always reading fresh state.

The same pattern resolved the error-clearing issue: errors update reactively inside the same state setter call, so there's never a frame where the new value is set but the old error is still visible.

---

## Features Added

### Workshop List (`/`)
- **Real-time search** — filters by title, instructor, and excerpt as you type
- **Level filter pills** — All / Beginner / Intermediate / Advanced, combinable with search
- **Clear button** — appears inside the search input only when there's text
- **"No workshops found" empty state** — with a fade-in animation and a "Reset filters" button that clears both search and filter at once

### Workshop Cards
- **Urgency chip** — "🔥 N left" shown when ≤ 5 spots remain
- **Sold-out badge** — muted chip + disabled CTA button when spots = 0
- **Hover lift** — subtle `translateY` + border highlight on hover
- **Consistent height** — 3-line excerpt clamp keeps the grid aligned

### Workshop Details (`/workshop/:id`)
- **Meta cards** — date, instructor, duration, and price each in a distinct card block
- **Spots warning banner** — contextual alert when seats are running low
- **Not found state** — graceful message + back link if the ID doesn't exist

### Registration Form
- **Blur validation** — errors appear after leaving a field, not during typing
- **Real-time clearing** — error disappears the moment input becomes valid
- **Submit guard** — all fields are validated before the form submits; shows a loading state during submission
- **Success toast** — confirmation message after successful registration

### Accessibility
- `aria-pressed` on filter buttons
- `aria-live="polite"` on loading and empty states
- `role="search"` and `role="group"` on toolbar sections
- `aria-label` on icon-only buttons and icon-only links
- Fully keyboard-navigable (tab order, focus rings, `tabIndex=-1` on disabled CTAs)

---

## Tech Stack

| Tool | Purpose |
|---|---|
| React 18 | UI library |
| React Router v6 | Client-side routing |
| CSS Modules | Scoped component styles |
| Vite | Dev server and build tool |
| No UI library | All components built from scratch |

---

## Setup

```bash
# Clone the repo
git clone <repo-url>
cd FOSSEE/frontend

# Install dependencies
npm install

# Start the dev server
npm run dev
```

The app runs at `http://localhost:5173` by default.

---

## Screenshots

### Workshop List — Default State
![Workshop list showing search bar, filter pills, and all workshop cards](./screenshots/workshop-list.png)

### Real-time Search in Action
![Workshop list filtered by search query "react"](./screenshots/search-filtered.png)

### Empty State (No Results)
![Empty state shown when no workshops match the search and filter](./screenshots/empty-state.png)

### Workshop Details Page
![Workshop detail page with meta cards and registration form side by side](./screenshots/workshop-details.png)

> **Note:** Screenshots are from the live dev server. Drop images into a `/screenshots` folder and the paths above will resolve.

---

## Project Structure

```
frontend/
├── src/
│   ├── components/
│   │   ├── Layout/          # App shell (Navbar + main content wrapper)
│   │   ├── Navbar/          # Navigation with active route highlight
│   │   ├── WorkshopCard/    # Card component with badge, urgency chip, CTA
│   │   ├── RegistrationForm/# Controlled form with blur validation
│   │   ├── StatusMessage/   # Generic success/error message block
│   │   └── Toast/           # Transient notification after form submit
│   ├── hooks/
│   │   └── useFormValidation.js  # Form state + validation hook
│   ├── pages/
│   │   ├── WorkshopList/    # Search, filter, and card grid
│   │   └── WorkshopDetails/ # Workshop info + registration form
│   └── styles/              # Global CSS tokens (colours, spacing, shadows)
```
