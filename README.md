# LearnForge — FOSSEE UI/UX Workshop Booking Enhancement

> **FOSSEE Python Screening Task** — UI/UX Enhancement of the FOSSEE Workshop Booking site,
> rebuilt in React with a focus on mobile-first design, accessibility, and performance.

---

## 📸 Before & After

| Before | After |
|--------|-------|
| ![Before](screenshots/before.png) | ![After](screenshots/after.png) |

> Screenshots are in the `screenshots/` folder. A live demo can be run locally
> with the instructions below, or via Docker.

---

## ✨ What Was Improved

| Area | Change |
|------|--------|
| **Typography** | Switched to DM Sans (body) + DM Serif Display (headings) — legible on small screens |
| **Colour system** | Semantic CSS variables with full dark-mode support |
| **Mobile layout** | Cards go 1 → 2 → 3 columns; sticky nav; hamburger with Escape-to-close |
| **Visual hierarchy** | Eyebrow text, display headings, muted subtitles, meta-card grid on detail page |
| **Accessibility** | `aria-current`, `aria-label`, skip-to-main link, `:focus-visible` ring, `sr-only` text, `role` landmarks |
| **Performance** | Route-level code splitting (`React.lazy` + `Suspense`), `will-change: transform` on sticky header, `scrollbar-gutter: stable` to prevent layout shift |
| **SEO** | `<title>`, `<meta description>`, Open Graph tags, `lang="en"` on `<html>` |
| **Form UX** | Per-field blur validation (stale-closure bug fixed), inline error messages, button spinner, success confirmation ID |
| **Urgency UX** | "🔥 X spots left" chip on cards and detail page; "Sold out" disabled state |
| **Reduced motion** | All animations disabled via `@media (prefers-reduced-motion: reduce)` |

---

## 💡 Reasoning (Required by FOSSEE)

### 1. What design principles guided your improvements?

Three principles drove every decision:

**Mobile-first, content-first.** The task brief states that most users access the site
on mobile devices. Every layout decision started at 320 px and scaled up — not the
reverse. Typography sizes use `clamp()` to scale fluidly between breakpoints without
media-query clutter.

**Progressive disclosure.** The workshop list shows only what a user needs to decide
whether to click (title, level, date, instructor, a short excerpt). The full description
and registration form are deferred to the detail page. This reduces cognitive load on
the first screen.

**Accessibility as a baseline, not an afterthought.** WCAG 2.1 AA compliance was
treated as a hard constraint: every interactive element has a visible focus state,
every image has alt text, every icon has a screen-reader label, and keyboard
navigation works end-to-end including hamburger close on `Escape`.

### 2. How did you ensure responsiveness across devices?

- **Fluid grid:** CSS `grid` with `repeat(auto-fill, minmax(...))` — no JavaScript,
  no third-party grid library. Cards reflow naturally from 1 to 3 columns.
- **Fluid type:** `clamp(var(--text-3xl), 5vw, var(--text-4xl))` on headings avoids
  hard breakpoints for typography.
- **Sticky navbar:** `position: sticky` + `will-change: transform` keeps the nav in
  view on long pages without expensive JavaScript scroll listeners.
- **Viewport meta:** `width=device-width, initial-scale=1` ensures correct pixel
  density on retina screens.
- **Touch targets:** All buttons and links have a minimum padding that meets the
  48 × 48 px WCAG touch-target guideline.

### 3. What trade-offs did you make between design and performance?

| Decision | Trade-off |
|----------|-----------|
| Google Fonts (DM Sans + DM Serif) via `<link rel="preconnect">` | Adds ~1 external request, but `font-display: swap` and preconnect keep FCP unaffected in practice |
| CSS Modules instead of Tailwind | Larger CSS bundle than utility-first, but zero runtime overhead and scoped by default — no class name collisions |
| `React.lazy` + `Suspense` for page routes | Tiny shell bundle on first load; each page chunk loads on demand |
| Mock data in page components | Avoids a real API call (keeping the task scope clean), but means data lives in JS — acceptable for a prototype |
| No animation library | CSS transitions only (`transition`, `@keyframes`) — zero JS bundle cost, disabled automatically for users who prefer reduced motion |

### 4. What was the most challenging part and how did you approach it?

**The form validation stale-closure bug.** The original `useFormValidation` hook
had a subtle React closure problem: `handleChange` captured `values` at the time the
callback was created. Under rapid typing, validation ran against a snapshot of state
from a previous render, producing wrong errors or missing them entirely.

The fix was two-pronged:
1. Use the functional form of `setValues(prev => ...)` so the update always runs
   against the latest state, not the closed-over snapshot.
2. Store the `validate` function and current `values` in a `useRef` that updates every
   render — refs are always current, unlike closure variables. The callbacks themselves
   (`handleChange`, `handleBlur`, `handleSubmit`) are then `useCallback` with an empty
   dependency array, meaning they are created once and never cause child re-renders.

This is a common React pitfall that is easy to miss in code review but has a real
impact on user experience (wrong validation feedback feels broken).

---

## 🗂️ Project Structure

```
fossee-uiux-workshop-booking/
├── frontend/
│   ├── src/
│   │   ├── styles/
│   │   │   ├── variables.css      # Design tokens, dark mode, reduced-motion
│   │   │   └── global.css         # Reset, focus ring, skip link, sr-only
│   │   ├── hooks/
│   │   │   └── useFormValidation.js
│   │   ├── components/
│   │   │   ├── Layout/            # Skip link, semantic landmarks
│   │   │   ├── Navbar/            # Mobile hamburger, a11y, Escape-to-close
│   │   │   ├── WorkshopCard/      # Badge colours, urgency chip
│   │   │   └── RegistrationForm/  # Blur validation, error/success UI
│   │   ├── pages/
│   │   │   ├── WorkshopList/      # Hero header, responsive grid
│   │   │   └── WorkshopDetails/   # Meta grid, sticky form, spots warning
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── index.html                 # SEO meta, og: tags, fonts
│   ├── package.json
│   └── vite.config.js
├── Dockerfile                     # Multi-stage Nginx build
├── docker-compose.yml
├── nginx.conf                     # SPA routing, gzip, cache headers
├── .dockerignore
├── .github/
│   └── workflows/
│       ├── ci.yml                 # Lint + build on every push/PR
│       └── cd.yml                 # Docker build + push on merge to main
├── screenshots/
│   ├── before.png
│   └── after.png
└── README.md
```

---

## 🛠️ Setup Instructions

### Prerequisites
- Node.js ≥ 20
- npm ≥ 9

### Local development

```bash
# 1. Clone
git clone https://github.com/joeljohngeorge8080/fossee-uiux-workshop-booking.git
cd fossee-uiux-workshop-booking

# 2. Install dependencies
cd frontend
npm install

# 3. Start dev server
npm run dev
# → http://localhost:5173
```

### Production build

```bash
cd frontend
npm run build
npm run preview
# → http://localhost:4173
```

### Docker (recommended for reviewers)

```bash
# Build and run with one command
docker compose up --build

# → http://localhost:3000
```

---

## ♿ Accessibility

- All interactive elements have visible `:focus-visible` outlines
- Skip-to-main-content link for keyboard users
- `aria-current="page"` on active nav links
- `aria-label` / `aria-expanded` on hamburger button
- `role="alert"` on form error and success messages
- `sr-only` class for screen-reader-only text
- Colour contrast ≥ 4.5:1 on all text/background pairs

---

## 🏎️ Performance

| Metric | Technique |
|--------|-----------|
| Route splitting | `React.lazy` + `Suspense` |
| No layout shift | `scrollbar-gutter: stable` |
| Smooth sticky nav | `will-change: transform` |
| Font loading | `rel="preconnect"` + `font-display: swap` |
| Reduced repaints | `React.memo` on `WorkshopCard` |
| Reduced motion | `@media (prefers-reduced-motion: reduce)` |

---

## 📬 Contact

Submitted for FOSSEE Python Screening Task — UI/UX Enhancement.
Questions: pythonsupport@fossee.in
