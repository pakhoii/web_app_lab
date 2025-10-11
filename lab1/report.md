# Lab 1 - HTML & CSS
---

### 1) Semantically correct HTML structure
- What is it
	- Semantic HTML means using HTML elements that describe their meaning and purpose (for example: `<header>`, `<main>`, `<section>`, `<address>`, `<h1>`/`<h2>`, `<p>`, `<ul>`).
- Why we use it
	- Improves accessibility (screen readers and assistive tech understand page structure).
	- Helps search engines index and rank content correctly.
	- Makes markup more maintainable and easier for other developers to understand.
- How?
	- `exercise1.html` uses `<html lang="en">`, a `<head>` and `<body>` — the required top-level structure.
	- The visible page is organized with `<header>` containing the main `<h1>`, and `<main>` which contains multiple `<section>` elements for different content blocks.
	- Contact information is wrapped in an `<address>` element, headings use `<h2>` for section titles, and lists of responsibilities use `<ul>/<li>`.

### 2) Single-page layout with sections for education, skills, and career history
- What is it
	- A single-page layout places all core resume/CV content on one HTML document and divides it into logical sections (education, skills, career history) rather than multiple pages.
- Why we use it
	- Keeps navigation simple and fast to load.
	- Ensures all important information is discoverable from one URL — convenient for sharing and quick scanning.
	- Easier to style responsively and maintain.
- How?
	- `exercise1.html` implements a single-page CV: the `<main>` element contains separate `<section>` blocks labelled by headings: `Skills`, `Education`, and `Experience` (career history).
	- Each section is visually separated using simple utility classes (`space-y-2`, `space-y-4`) and semantic headings (`<h2 class="text-green">`) so the structure is clear to users and machines.

### 3) SEO meta tags in the head section
- What is it
	- SEO meta tags are metadata placed inside the `<head>` (like `<meta charset>`, `<meta name="viewport">`, `<meta name="description">`, `<title>`) that inform browsers and search engines about the page.
- Why we use it
	- `charset` ensures correct character rendering.
	- `viewport` enables responsive layout on mobile devices.
	- `description` provides a summary shown in search results.
	- `title` is used by browsers and search engines as the page title.
- How?
	- `exercise1.html` includes the essential tags: `<meta charset="UTF-8">`, `<meta name="viewport" content="width=device-width, initial-scale=1.0">`, `<meta name="author" content="pakhoii">`, `<meta name="description" content="A brief description of my CV webpage.">`, and a `<title>pakhoii CV</title>`.
	- These tags help the page render correctly on mobile and provide the basic SEO signals search engines expect.

### 4) OG tags for better social media sharing
- What is it
	- Open Graph (OG) tags are meta tags that provide social platforms (Facebook, Twitter card parsers, LinkedIn) information about how to preview a shared link (title, description, type, image, etc.). Typical tags look like `<meta property="og:title" content="...">`.
- Why we use it
	- Controls link previews when someone shares the page.
	- Increases click-through rate by showing a clear, tailored preview (title, description, sometimes an image).
- How?
	- `exercise1.html` includes OG-like tags: `<meta name="og:title" content="My CV">`, `<meta name="og:description" content="A brief description of my CV webpage.">`, and `<meta name="og:type" content="website">`.
	- Note: The typical convention is to use `property="og:*"` (rather than `name`) and to include `og:image` for a richer preview; switching to `property` and adding an image is a small improvement to consider.

### 5) A favicon linked in the head section
- What is it
	- A favicon is a small icon shown in browser tabs, bookmarks, and some social previews; linked with `<link rel="icon">` in the `<head>`.
- Why we use it
	- Increases recognizability and polish for the site.
	- Makes it easier for users to find the page among many tabs or bookmarks.
- How?
	- `exercise1.html` includes a favicon link: `<link rel="icon" type="image/svg" href="./public/ChatGPT-Logo.wine.svg">`.
	- The icon file sits in the `public/` folder relative to the HTML file. For broader browser support you can also provide PNG/favicon.ico variants and include sizes and type attributes.

---