# FOSSEE Submission Checklist

Go through every item before sending the repo link to pythonsupport@fossee.in.

## Code Quality
- [ ] `cd frontend && npm run lint` — zero errors
- [ ] `cd frontend && npm run build` — builds without errors
- [ ] No `console.log` left in production code
- [ ] All components have `displayName` or named exports

## Git History
- [ ] At least 5–8 meaningful commits (not one giant dump)
- [ ] Commit messages describe WHAT and WHY, not just "update"
- [ ] Example good commits:
  - `feat: add mobile-first responsive card grid`
  - `fix: stale-closure bug in useFormValidation handleChange`
  - `a11y: add skip-to-main link and focus-visible ring`
  - `perf: lazy-load WorkshopList and WorkshopDetails pages`
  - `chore: add Dockerfile and nginx SPA config`

## README
- [ ] Includes before/after screenshots (screenshots/ folder)
- [ ] All 4 reasoning questions answered
- [ ] Setup instructions tested end-to-end
- [ ] Docker instructions included

## Screenshots
- [ ] `screenshots/before.png` exists
- [ ] `screenshots/after.png` exists
- [ ] Both are mobile viewport (375px wide preferred)

## Accessibility
- [ ] Tab through the whole site — every element reachable, visible focus ring shown
- [ ] Press Escape when hamburger is open — menu closes, focus returns to button
- [ ] Use a screen reader (VoiceOver / NVDA) on the form — errors announced
- [ ] Run axe DevTools Chrome extension — 0 violations

## Performance (optional but impressive)
- [ ] Run Lighthouse in Chrome DevTools on the production build
- [ ] Performance ≥ 90, Accessibility ≥ 95, Best Practices ≥ 90, SEO ≥ 90
- [ ] Add Lighthouse scores to README if they look good

## Docker
- [ ] `docker compose up --build` runs without errors
- [ ] http://localhost:3000 shows the app
- [ ] SPA routing works: navigate to /workshop/1, refresh — still works

## CI/CD
- [ ] Push a branch → CI workflow triggers in GitHub Actions
- [ ] Add DOCKERHUB_USERNAME and DOCKERHUB_TOKEN secrets to the repo
- [ ] Merge to main → CD workflow builds and pushes Docker image

## Final
- [ ] Repo is PUBLIC on GitHub
- [ ] Email sent to pythonsupport@fossee.in with the repo link
