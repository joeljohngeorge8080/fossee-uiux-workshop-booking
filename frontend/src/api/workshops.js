/**
 * workshops.js — Centralized API layer.
 * Set VITE_API_URL in your .env to point at your Django backend.
 * In dev, falls back to mock data when the API is unreachable.
 */

const BASE_URL = import.meta.env.VITE_API_URL ?? '/api';

async function apiFetch(path, options = {}) {
    const res = await fetch(`${BASE_URL}${path}`, {
        headers: { 'Content-Type': 'application/json' },
        ...options,
    });

    if (!res.ok) {
        let message = `Request failed: ${res.status} ${res.statusText}`;
        try {
            const body = await res.json();
            if (body?.detail) message = body.detail;
            else if (body?.message) message = body.message;
        } catch { /* keep status message */ }
        throw new Error(message);
    }

    return res.json();
}

const MOCK_WORKSHOPS = [
    {
        id: 1,
        title: 'Advanced React Patterns',
        date: '2026-05-15',
        instructor: 'Jane Doe',
        level: 'Advanced',
        duration: '4 hours',
        price: '$149',
        spotsLeft: 3,
        excerpt: 'Master advanced React concepts including higher-order components, render props, and custom hooks for scalable applications.',
        description: 'This intensive workshop dives deep into the advanced patterns used in modern React applications. You will learn how to build scalable and maintainable components using techniques like higher-order components, render props, compound components, and custom hooks. The curriculum includes practical exercises on state management optimizations and performance tuning using React Profiler.',
    },
    {
        id: 2,
        title: 'Python Django Mastery',
        date: '2026-05-22',
        instructor: 'John Smith',
        level: 'Intermediate',
        duration: '6 hours',
        price: '$199',
        spotsLeft: 12,
        excerpt: 'Build robust backend architectures with Django. Learn ORM optimizations, middleware, and class-based views.',
        description: 'Elevate your backend engineering skills with our comprehensive Django Mastery workshop. This session goes beyond the basics to cover ORM performance optimizations, custom middleware development, and the utilization of class-based views for cleaner code.',
    },
    {
        id: 3,
        title: 'UI/UX Fundamentals for Engineers',
        date: '2026-06-05',
        instructor: 'Alice Johnson',
        level: 'Beginner',
        duration: '3 hours',
        price: '$99',
        spotsLeft: 20,
        excerpt: 'Understand basic design principles, typography, and color theory to build better user interfaces and experiences.',
        description: "This workshop bridges the gap between engineering and design. You will gain a solid foundation in visual hierarchy, typography, color theory, and responsive layout — all taught from an engineer's perspective.",
    },
    {
        id: 4,
        title: 'Fullstack Next.js Development',
        date: '2026-06-12',
        instructor: 'Bob Williams',
        level: 'Intermediate',
        duration: '5 hours',
        price: '$179',
        spotsLeft: 8,
        excerpt: 'Create high-performance server-side rendered applications utilizing Next.js app router and server actions.',
        description: 'A hands-on fullstack workshop covering Next.js App Router, React Server Components, server actions, data fetching strategies, and deployment. Build a complete production app from scratch during the session.',
    },
];

function delay(ms) { return new Promise((r) => setTimeout(r, ms)); }

export async function fetchWorkshops() {
    try {
        return await apiFetch('/workshops/');
    } catch (err) {
        if (import.meta.env.DEV) {
            console.warn('[API] Using mock workshop list:', err.message);
            await delay(600);
            return MOCK_WORKSHOPS;
        }
        throw err;
    }
}

export async function fetchWorkshop(id) {
    try {
        return await apiFetch(`/workshops/${id}/`);
    } catch (err) {
        if (import.meta.env.DEV) {
            console.warn('[API] Using mock workshop detail:', err.message);
            await delay(400);
            const workshop = MOCK_WORKSHOPS.find((w) => w.id === Number(id));
            if (!workshop) throw new Error('Workshop not found');
            return workshop;
        }
        throw err;
    }
}

export async function registerForWorkshop(workshopId, formData) {
    try {
        return await apiFetch(`/workshops/${workshopId}/register/`, {
            method: 'POST',
            body: JSON.stringify(formData),
        });
    } catch (err) {
        if (import.meta.env.DEV) {
            console.warn('[API] Simulating registration POST:', err.message);
            await delay(1000);
            if (formData.email?.endsWith('@blocked.com')) {
                throw new Error('This email domain is not accepted.');
            }
            return { success: true, confirmationId: `WRK-${Date.now()}` };
        }
        throw err;
    }
}
