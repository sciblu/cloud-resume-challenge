# Cloud Resume Challenge – TL;DR

## What This Is
A personal resume site built with **Hugo** + **Blowfish theme**, deployed to AWS as part of the Cloud Resume Challenge.

## Tech Stack
- **Frontend:** Hugo static site generator, custom HTML/CSS resume page
- **Theme:** Blowfish (Git submodule)
- **Icons:** Phosphor Icons (CDN)
- **Hosting:** AWS (S3, CloudFront, Route 53, ACM)
- **IaC:** Terraform
- **CI/CD:** GitHub Actions with OIDC authentication
- **Domain:** custom domain with HTTPS

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
- [x] Domain purchased and registered (lahdigital.dev)
- [x] AWS account created with IAM admin user
- [x] Hugo site files uploaded to GitHub repo
- [x] Infrastructure as Code with Terraform
- [x] S3 buckets (www and root domain)
- [x] CloudFront distributions with OAC
- [x] ACM SSL certificates
- [x] Route 53 DNS records
- [x] CloudFront Function for Hugo directory routing
- [x] GitHub Actions CI/CD with OIDC authentication
- [x] Automated deployment on push to main
- [x] Site is live at my registar domaiin

## Next Steps 🚧
- [x] Visitor counter (Lambda + API Gateway + DynamoDB)
- [ ] Blog section

## Architecture Diagram
![AWS Architecture Diagram](docs/Final_AWS_CRC.png)

## Key Files Quick Reference
```
static/resume/index.html      # Resume page
static/css/resume.css         # Resume styles
layouts/shortcodes/pub.html   # Publication shortcode
themes/blowfish/              # Theme (submodule)
terraform/                    # Infrastructure as Code
.github/workflows/            # CI/CD deployment pipeline
```


---
📄 **Full documentation:** [See detailed README](./docs/README.md)
