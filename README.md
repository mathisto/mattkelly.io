# MattKelly.io

<div align="center">

[![Ruby on Rails](https://img.shields.io/badge/Ruby%20on%20Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white)](https://rubyonrails.org/)
[![Tailwind CSS](https://img.shields.io/badge/Tailwind%20CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)](https://tailwindcss.com/)
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Fly.io](https://img.shields.io/badge/Fly.io-8E5BC3?style=for-the-badge&logo=fly.io&logoColor=white)](https://fly.io/)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)](https://github.com/features/actions)

A high-performance personal website embracing boring technology principles and modern development practices.

[🌐 Live Site](https://mattkelly.io) · [📝 Blog](https://mattkelly.io/blog) · [🛠️ Projects](https://mattkelly.io/projects)

</div>

## ✨ Overview

MattKelly.io is a minimalist personal website that prioritizes performance, maintainability, and user experience. Built with Ruby on Rails 8 and styled with Tailwind CSS, it demonstrates how traditional technologies can create modern, lightning-fast web experiences.

### Key Features

- 🚀 **Blazing Fast Performance**
  - Static site generation
  - Minimal JavaScript footprint
  - Optimized asset delivery

- 🎯 **Content-First Design**
  - Markdown-based blog system
  - Clean, responsive layouts
  - Accessibility-focused UI

- 🛡️ **Modern Development Practices**
  - Comprehensive test coverage
  - Automated CI/CD pipeline
  - Container-based deployment

## 🔧 Technology Stack

### Core Technologies
| Technology | Purpose |
|------------|---------|
| Ruby on Rails 8.0.2 | Web framework |
| Tailwind CSS | Styling |
| Markdown | Content management |

### Development & Operations
| Category | Tools |
|----------|--------|
| Testing | RSpec |
| CI/CD | GitHub Actions |
| Hosting | Fly.io |
| Monitoring | Fly.io Dashboard |

## 🚀 Getting Started

### Prerequisites
- Ruby 3.3.0+

### Installation

1. Clone the repository
```bash
git clone https://github.com/mathisto/mattkelly.io.git
cd mattkelly.io
```

2. Install dependencies
```bash
bundle install
```

3. Start the development server
```bash
bin/dev
```

Your site should now be running at `http://localhost:3000` 🎉

## 📦 Deployment

### Automated Deployment
The site automatically deploys to Fly.io through GitHub Actions when changes are pushed to the `trunk` branch.

```bash
git push origin trunk
```

### Manual Deployment
If needed, you can deploy manually:

```bash
fly deploy
```

### Deployment Checklist
- ✅ Tests passing locally
- ✅ Environment variables configured
- ✅ Database migrations ready
- ✅ Assets precompiled

## 🔍 Development Guidelines

### Code Style
- Follow Ruby style guide
- Use conventional commit messages
- Write tests for new features

### Testing
```bash
# Run the full test suite
bundle exec rspec

# Run specific tests
bundle exec rspec spec/path/to/test
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📫 Contact

Matt Kelly - [@mathisto](https://github.com/mathisto)

Project Link: [https://github.com/mathisto/mattkelly.io](https://github.com/mathisto/mattkelly.io)

---

<div align="center">

[![Made with Ruby on Rails](https://img.shields.io/badge/Made%20with-Ruby%20on%20Rails-red?style=for-the-badge&logo=ruby-on-rails)](https://rubyonrails.org)

</div>
