# Cloud Resume Challenge – TL;DR

## What This Is
A personal resume site built with **Hugo** + **Blowfish theme**, deployed to AWS as part of the Cloud Resume Challenge.

## Tech Stack
- **Frontend:** Hugo static site generator, custom HTML/CSS resume page
- **Theme:** Blowfish (Git submodule)
- **Icons:** Phosphor Icons (CDN)
- **Hosting:** AWS (S3, CloudFront, Route 53)
- **IaC:** Terraform (in progress)

## Site Structure
| Section | Implementation |
|---------|---------------|
| Homepage | Hugo + Blowfish |
| Resume | Static HTML/CSS at `/resume/` |
| Publications | Custom `pub` shortcode |
| Blog | Future (Blowfish-ready) |

## Key Design Decisions
- **Static HTML resume** → precise layout control without fighting Markdown
- **Duplicate background image** → one in `assets/` for Hugo, one in `static/` for the resume page
- **No CSS frameworks** → minimal, framework-free styling
- **AI-assisted development** → architecture decisions and final code review done by me

## Current Progress ✅
- [x] Domain purchased and registered
- [x] AWS account created with IAM admin user
- [x] Hugo site files uploaded to GitHub repo
- [x] Learning Terraform for S3 bucket provisioning

## Next Steps 🚧
- [ ] S3 static website hosting
- [ ] CloudFront distribution + HTTPS
- [ ] Route 53 DNS configuration
- [ ] Visitor counter (Lambda + API Gateway + DynamoDB)
- [ ] CI/CD pipeline

## Key Files Quick Reference
```
static/resume/index.html      # Resume page
static/css/resume.css         # Resume styles
layouts/shortcodes/pub.html   # Publication shortcode
themes/blowfish/              # Theme (submodule)
```

---
📄 **Full documentation:** [See detailed README](./docs/README.md)
