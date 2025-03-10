# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing projects
Project.destroy_all

# Create projects
projects = [
  {
    title: "MattKelly.io",
    description: "My personal developer portfolio built with Rails 8 and Tailwind CSS. Features a beautiful Tokyo Night theme, responsive design, and modern web development practices.",
    technologies_used: ["Ruby on Rails", "Tailwind CSS", "Stimulus.js", "PostgreSQL"],
    role: "Full Stack Developer",
    duration: "2 weeks",
    github_url: "https://github.com/mathisto/mattkelly.io",
    live_site_url: "https://mattkelly.io",
    highlight: true,
    position: 1
  },
  {
    title: "AI Chat Interface",
    description: "A sophisticated chat interface for interacting with AI models. Features real-time streaming responses, code syntax highlighting, and conversation management.",
    technologies_used: ["React", "TypeScript", "WebSockets", "OpenAI API"],
    role: "Frontend Developer",
    duration: "1 month",
    github_url: "https://github.com/mathisto/ai-chat",
    highlight: true,
    position: 2
  },
  {
    title: "Data Visualization Dashboard",
    description: "Interactive dashboard for visualizing complex datasets. Includes customizable charts, filters, and real-time updates.",
    technologies_used: ["Vue.js", "D3.js", "Node.js", "MongoDB"],
    role: "Full Stack Developer",
    duration: "3 months",
    github_url: "https://github.com/mathisto/data-viz",
    live_site_url: "https://data-viz-demo.herokuapp.com",
    position: 3
  },
  {
    title: "E-commerce Platform",
    description: "A modern e-commerce platform with features like product management, cart functionality, and secure payments.",
    technologies_used: ["Ruby on Rails", "React", "Stripe API", "Redis"],
    role: "Backend Developer",
    duration: "6 months",
    github_url: "https://github.com/mathisto/shop",
    position: 4
  },
  {
    title: "Task Management API",
    description: "RESTful API for task management with authentication, authorization, and comprehensive documentation.",
    technologies_used: ["Node.js", "Express", "JWT", "MongoDB"],
    role: "Backend Developer",
    duration: "2 months",
    github_url: "https://github.com/mathisto/task-api",
    position: 5
  },
  {
    title: "Weather App",
    description: "Clean and intuitive weather application with location-based forecasts and beautiful animations.",
    technologies_used: ["React Native", "Weather API", "Geolocation", "Lottie"],
    role: "Mobile Developer",
    duration: "3 weeks",
    github_url: "https://github.com/mathisto/weather-app",
    live_site_url: "https://weather.mathisto.dev",
    position: 6
  }
]

# Create each project
projects.each do |project_data|
  Project.create!(project_data)
end

puts "Created #{Project.count} projects"
