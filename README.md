# MattKelly.io 🚀

<div align="center">

![Ruby on Rails](https://img.shields.io/badge/Ruby%20on%20Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
![Tailwind CSS](https://img.shields.io/badge/Tailwind%20CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)

A minimalist, high-performance personal site built with boring technology principles.

[Live Site](https://mattkelly.io) · [Blog](https://mattkelly.io/blog) · [Projects](https://mattkelly.io/projects)

</div>

## 🌟 Features

- ⚡️ **Lightning Fast** - Static site generation with minimal JavaScript
- 📱 **Fully Responsive** - Perfect viewing on any device
- 🔥 **Minimalist Stack** - Ruby on Rails 8 stripped down to essentials
- 📝 **Markdown Blog** - Content management with standard markdown

## 🛠️ Tech Stack

### Core
- Ruby on Rails 8.0.2 (minimal configuration)
- Markdown processing for content
- Tailwind CSS for styling

### Development
- RSpec for testing
- GitHub Actions for CI/CD
- Fly.io for deployment

## 🚀 Getting Started

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

Visit `http://localhost:8080` and you're ready to go! 🎉

## 📦 Deployment

Deployment is handled automatically through GitHub Actions when pushing to the `trunk` branch:

1. Push changes to trunk:
```bash
git push origin trunk
```

2. GitHub Actions will:
   - Run the test suite
   - Deploy to Fly.io if tests pass

Manual deployment (if needed):
```bash
fly deploy
```

### Troubleshooting Deployment

Common issues and solutions:

1. Health Check Failures
   - Check Fly.io logs: `fly logs`
   - Verify app is binding to 0.0.0.0:8080
   - Ensure `/up` endpoint is responding

2. Build Failures
   - Check GitHub Actions logs
   - Verify Dockerfile configuration
   - Check for missing environment variables

## 🎨 Design Philosophy

This site embraces boring technology principles:
- Minimal dependencies
- Standard patterns over novelty
- Focus on content and performance
- No unnecessary complexity

## 🤝 Contributing

Found a bug? Want to contribute? Feel free to:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (following conventional commit message format)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

Made with 💜 by [Matt Kelly](https://github.com/mathisto)

</div>
