 # Cloud Resume Challenge – Frontend & Content Implementation

This repository contains the frontend portion of my Cloud Resume Challenge. I’m using the [Hugo](https://gohugo.io) static site generator with the **Blowfish*-theme to host:

- My resume (HTML + CSS version)
- A publications section (via a custom Hugo shortcode)
- Space for a future technical blog

In the next phase, this site will be deployed to AWS (S3, CloudFront, etc.) as part of the full Cloud Resume architecture.

------

## 1. Architecture Overview

This project implements a **static personal resume site*-using:

-**Hugo*-with the **Blowfish*-theme for the main site
-A separate **static HTML + CSS*-resume page for precise layout control

At a high level, the frontend architecture includes:

-A Hugo site with the standard directory structure:

  -`content/`, `layouts/`, `assets/`, `static/`, `themes/`
-The **Blowfish*-theme added as a Git submodule and used for:

  -The homepage and overall site framing
  -A future technical blog
-A **static resume*-at `/resume/` implemented as its own HTML file
-A **publications*-section implemented with a custom Hugo `pub` shortcode
-A shared **macro photograph of sand*-used as a visual motif across the site, via:

  -Hugo’s asset pipeline (for the Blowfish theme)
  -Direct CSS references (for the static resume and publication pages)

The goal is to keep the frontend simple and explicit so the next phase—deploying to AWS with a visitor counter—can focus on cloud infrastructure instead of refactoring the UI.

---

## 2. Implementation Details

### 2.1 Hugo Site and Theme

I’m using **Hugo*-as the static site generator.

-Standard Hugo structure:

  -`content/` – Markdown content
  -`layouts/` – custom templates and shortcodes
  -`assets/` – pipeline-managed assets
  -`static/` – pass-through static files
  -`themes/` – Hugo themes (including Blowfish)
-The **Blowfish*-theme is added as a Git submodule under `themes/blowfish`.
-The Hugo configuration:

  -Selects Blowfish as the active theme
  -Sets up the homepage
  -Defines a publications page
  -Leaves room for a future technical blog section

Blowfish gives me clean defaults and accessibility out of the box, so I can focus on the resume, publications, and later the AWS deployment.

### 2.2 Content Structure

The content is organized around three main areas:

-**Homepage and general site content**

  -Managed via standard Hugo Markdown files in `content/`
  -Uses Blowfish layouts for structure and styling

-**Publications page**

  -Implemented as a Hugo content page
  -Uses a custom Hugo shortcode (`pub`) for each publication entry
  -Keeps the Markdown readable while enforcing consistent HTML structure

-**Future technical blog**

  -A section is reserved for blog posts
  -Blowfish already provides layouts and styling
  -Posts can be added later without changing the core structure

### 2.3 Publications Shortcode (`pub`)

To keep the publications page easy to maintain while still rendering consistently, I created a custom `pub` shortcode.

-**File:*-`layouts/shortcodes/pub.html`
-**Purpose:**

  -Wrap each publication entry in a consistent HTML structure
  -Allow inline Markdown formatting (bold, italics, etc.) inside the citation

**Invocation pattern (in content):**

```hugo
{{< pub "Hollimon LA, Author 2, Author 3. *Article title goes here.-Journal Name. 2025. https://example.com/article" >}}
```

**Internal behavior (simplified):**

-Reads the first positional parameter as the full citation string:

  -Authors, title, journal, year, and URL all in one line

-Uses Hugo’s `RenderString` on the citation so Markdown formatting is processed:

  -I can bold my name
  -Titles can be italicized

**Why this approach:**

-Each publication entry stays on a single line in the Markdown file
-The shortcode keeps the HTML consistent
-I still get flexible Markdown formatting for authors and titles

### 2.4 Static Resume Page

The resume is implemented as a **static HTML + CSS*-page instead of a Hugo template.

-**Location:**

  -`static/resume/index.html` – main resume page
  -`static/css/resume.css` – styles for the resume

-**Layout:**

  -Inspired by a Yale-style resume layout
  -Clear sections for:

    -Contact information
    -Summary
    -Experience
    -Education
    -Skills
    -Certifications
  -Two-column style for:

    -Job title / organization on the left
    -Dates and locations aligned on the right
  -Bulleted lists for responsibilities and achievements
  -Uses semantic HTML for readability and accessibility

I chose a static HTML file here because it gives more precise control over alignment, spacing, and bullets without fighting Markdown quirks.

---

## 3. Design and Style

### 3.1 Background Imagery

The site uses a **macro photograph of sand*-(taken on my phone) as a unifying visual element.

-In the Hugo/Blowfish side of the site:

  -The sand image lives under `assets/`
  -It’s integrated via Hugo’s asset pipeline and theme styling
-On the static resume page:

  -The same image is stored under `static/img/`
  -It’s applied directly via CSS in `static/css/resume.css`

This keeps the homepage, publications page, and resume page visually connected, even though they’re rendered in slightly different ways.

### 3.2 Visual Consistency

Even though the homepage and resume are built differently (Hugo + theme vs static HTML), I aimed for a cohesive experience:

-Shared sand background image
-Similar typography and spacing
-Content-forward layout with minimal distractions

The resume should feel like part of the same site, not a separate microsite.

### 3.3 CSS and Layout Choices

For the resume:

-I use **minimal, framework-free CSS*-to:

  -Keep the styles small and easy to understand
  -Avoid external CSS frameworks (no Tailwind, no Bootstrap)
-The CSS handles:

  -Alignment of roles vs dates/locations
  -Section spacing and headings
  -Applying the background image consistently

### 3.4 Icons and External Assets

For social/profile icons (GitHub, LinkedIn, etc.), I use the [Phosphor Icons](https://phosphoricons.com/) library via its webfont/CDN. This lets me:

-Use simple class names in HTML
-Avoid managing individual SVG files in the repo

---

## 4. Key Files

Some of the most important files in this repo:

-`static/resume/index.html`
  Standalone HTML implementation of the resume page, served at `/resume/`.

-`static/css/resume.css`
  Stylesheet for the resume page, including layout, typography, and background image.

-`static/img/sand-hero-background.jpg`
  Background image used directly by the static resume via CSS.

-`assets/img/sand-hero-background.jpg`
  The same sand image, used by the Blowfish theme through Hugo’s asset pipeline.

-`layouts/shortcodes/pub.html`
  Hugo `pub` shortcode that renders individual publication entries with Markdown formatting support.

-`layouts/_default/publications.html`
  Custom layout for the publications page that wraps content using the `pub` shortcode and integrates it into the main site layout.

-Icon library: [Phosphor Icons](https://phosphoricons.com/)
  Used via CDN/webfont for social and other UI icons.

---

## 5. AI Assistance

I used **ChatGPT 5.1*-to speed up parts of the frontend work, but I kept control over the architecture and final implementation.

### 5.1 What AI Helped With

AI was used for:

-**HTML/CSS conversion for the resume**

  -Converting a description of a Yale-style resume layout into an initial HTML/CSS structure for `static/resume/index.html` and `static/css/resume.css`

-**Shortcode development**

  -Drafting and refining the Hugo `pub` shortcode in `layouts/shortcodes/pub.html`

-**Publication layout**

  -Drafting the initial publication layout in `layouts/_default/publications.html`

-**Debugging and integration**

  -Figuring out correct placement of shortcode files in `layouts/`
  -Understanding how `RenderString` behaves with Markdown
  -Resolving minor rendering issues related to the shortcode

-**CSS refinement**

  -Generating minimal, framework-free styles for the resume layout

### 5.2 What I Did Myself

I remained responsible for:

-**Architecture and design decisions**

  -Choosing Hugo and the Blowfish theme
  -Deciding to use a static HTML resume instead of a Hugo template
  -Designing the publications flow with a shortcode

-**Code review and integration**

  -Reviewing and editing AI-generated HTML/CSS and Hugo templates
  -Making sure everything fits the project structure
  -Cleaning up code for readability and maintainability

-**Content and assets**

  -Writing all resume content
  -Writing the publication entries and citations
  -Taking the macro sand photograph and integrating it into both Hugo and static CSS

All AI suggestions were tested locally and only committed once they matched the behavior and design I wanted.

### 5.3 Core Prompt Used for Resume Conversion

The bootcamp requires documenting the core prompts used for AI assistance. Here is one of the main prompts I used for converting the resume layout:

<details>
<summary>Prompt for resume HTML/CSS conversion</summary>

I'm building a personal resume page for my Cloud Resume Challenge using Hugo and the Blowfish theme.

I have a resume layout based on the Yale resume template. Please convert that layout into semantic HTML and CSS that
I can use as a standalone page inside Hugo's static folder.

Requirements:

1. Output plain HTML and a separate CSS file.
2. Do NOT use any CSS frameworks (no Bootstrap, Tailwind, etc.).
3. Use the least amount of CSS selectors needed to get a clean, readable layout.
4. The HTML should be structured like a professional resume:

   -Name and contact info at the top
   -Summary section
   -Experience (with job title, organization, location, and dates)
   -Education
   -Skills
   -Certifications
5. Make sure the dates and locations can be aligned on the right side while titles and organizations stay on the left.
6. Use class names that are easy to understand (e.g., .resume-card, .resume-section, .resume-item, .item-meta).
7. Assume the page will live at /resume/ and that the CSS file will be available at /css/resume.css.

Return:

-One HTML snippet that I can paste into static/resume/index.html.
-One CSS snippet for resume.css.

</details>

Related artifacts:

- [Yale-resume-template-image](Yale-Experience-Alum-Resume.png)
- [Yale-resume-template HTML output](Yale-resume-template.html)
- [Overall-CSS output](/docs/resume-template.css)

### 5.4 Core Prompt Used for the `pub` Shortcode

The original conversation around the `pub` shortcode was informal (e.g., “Make it a Hugo shortcode so I don’t repeat HTML”). For documentation, this is the reconstructed version of the key request:

#### Prompt for pub shortcode
```text
I have a publications section on my Hugo site and I want to render each publication entry in a consistent way without repeating HTML.

Context:
- The site uses Hugo and the Blowfish theme.
- I have a list of publications written in Markdown on a publications page.
- Each publication includes: authors, title, journal, year, and a link to the open access article.
- I’d like the link to the article to be clearly visible, ideally styled like a button similar to the screenshot I’ve attached (but we must not copy any external code or layout exactly).

Requirements:
1. Propose a Hugo approach that avoids duplicating HTML for each publication entry.
2. Implement this as a Hugo shortcode (for example, called `pub`) that:
   - Wraps the inner Markdown content in a suitable container element.
   - Uses `RenderString` so I can:
     - Bold my own name in the author list.
     - Italicize the publication title.
     - Use standard Markdown links for the article URL.
3. Show an example of how the shortcode would be used inside a Markdown content file for the publications page.
4. Keep the HTML structure simple and generic enough that I can style it later with CSS (including giving the link a “button-like” appearance).

Please:
- Provide the full contents of the shortcode file (`layouts/shortcodes/pub.html`).
- Provide a sample Markdown snippet that shows how I would write one publication entry using this shortcode.
- Do not include any JavaScript.
- Do not copy any external site’s markup; use a simple, clean structure that I can customize.
```

Related artifacts:

- [ChatGPT publication shortcode](pub-shortcode.html)
- [ChatGPT publication layout](publications-layout.html)


If there are additional detailed prompts (for shortcode tweaks, debugging, etc.), they can be collected in a separate file such as `docs/ai-prompts.md` and linked from here.


## 6. Lessons and Design Decisions

This section captures the main decisions and trade-offs I made while building the frontend.

### 6.1 Static HTML Resume vs Hugo Template

**Decision**
Use a static HTML + CSS page at `static/resume/index.html` instead of a Hugo template.

**Why:**

-The resume layout needs tight control over:

  -Alignment of dates and locations
  -Bullet indentation and spacing
  -Section ordering and spacing
-Hugo’s Markdown rendering can get in the way for this style of layout
-A standalone HTML file is explicit, easy to tweak, and doesn’t depend on template logic

**Future:**
If I ever want deeper integration with Hugo (for data files, partials, etc.), I could refactor the resume into a Hugo layout later.

### 6.2 Background Image in Both `assets/` and `static/`

**Decision**
Store the sand background image twice:

- assets/img/sand-hero-background.jpg – used by Hugo/Blowfish
- static/img/sand-hero-background.jpg – used directly by the static resume

**Why:**

-Blowfish uses Hugo’s asset pipeline for theme images
-The static HTML resume can’t call `resources.Get`, so it needs a plain static path
-Duplicating the image keeps both sides straightforward and decoupled

**Future:**
If the resume is converted to a Hugo template, I could remove the `static/` copy and rely only on the asset pipeline.

### 6.3 Minimal CSS Instead of Frameworks

**Decision**
Avoid external CSS frameworks for the resume.

**Why:**

- The layout is relatively simple
- A framework would add:

  - Extra complexity in class names
  - Extra assets and build steps
- Custom CSS is:

  - Easy to scan
  - Focused on this layout only

### 6.4 Publications Layout Inspiration

The publications section (grouped citations, highlighted author name, italicized titles, and “open article” links) follows a pattern similar to academic CV and lab websites. I used that general idea, then:

- Designed my own HTML structure
- Implemented it with a Hugo `pub` shortcode
- Kept the content readable in Markdown while rendering consistently in the browser

All markup in this repo was written specifically for this project.



## 7. Next Steps and AWS Deployment Plan


This repo currently focuses on the **frontend and content**. The next phase is deploying it as part of a full Cloud Resume Challenge implementation on AWS.

Planned deployment steps:

- **Static hosting on Amazon S3**

  -Build the Hugo site
  -Upload the generated site and static resume to an S3 bucket configured for static website hosting

- **Global distribution and HTTPS with Amazon CloudFront**

  -Put CloudFront in front of the S3 bucket
  -Use CloudFront for caching and TLS termination

- **Custom domain and DNS**

  -Use a domain from a third-party registrar
  -Manage DNS with Amazon Route 53 (or Cloudflare if I decide to keep using it)
  -Point `www.my-domain.com` (example) at the CloudFront distribution

- **Visitor counter**

  - Implemented using AWS services such as:

    - AWS Lambda (function to read/update the visitor count)
    - API Gateway (HTTP endpoint for the counter)
    - Amazon DynamoDB (persistent store for the count)
  - A small JavaScript snippet on the site will:
    - Call the API
    - Display the visitor count in the UI

This is the frontend and design side. The AWS infrastructure, CI/CD, and visitor counter will be covered in a separate architecture/infra document once that part is implemented.



