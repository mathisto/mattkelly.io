# frozen_string_literal: true

# DocsController - Development-only documentation wiki
# This controller is only accessible in development mode to provide
# easy navigation of project documentation without exposing it in production.
class DocsController < ApplicationController
  before_action :ensure_development_environment
  before_action :set_doc_path, only: [ :show ]

  DOCS_DIR = Rails.root.join("docs")

  def index
    @readme_content = render_markdown_file(DOCS_DIR.join("README.md"))
    @title = "Documentation Wiki"
  end

  def show
    # Construct the full file path
    doc_file = DOCS_DIR.join("#{@doc_path}.md")

    # Security: Prevent directory traversal attacks
    unless doc_file.to_s.start_with?(DOCS_DIR.to_s)
      return render_not_found
    end

    # Check if file exists
    unless File.exist?(doc_file)
      return render_not_found
    end

    @content = render_markdown_file(doc_file)
    @title = extract_title_from_path(@doc_path)
    @breadcrumbs = build_breadcrumbs(@doc_path)

    render :show
  end

  private

  def ensure_development_environment
    unless Rails.env.development?
      render plain: "Documentation wiki is only available in development mode", status: :forbidden
    end
  end

  def set_doc_path
    @doc_path = params[:path] || "README"
  end

  def render_markdown_file(file_path)
    return nil unless File.exist?(file_path)

    content = File.read(file_path)
    render_markdown(content)
  end

  def render_markdown(content)
    # Use the same markdown renderer as the blog
    require "redcarpet"

    renderer = Redcarpet::Render::HTML.new(
      filter_html: false,
      hard_wrap: true,
      link_attributes: { target: "_blank", rel: "noopener noreferrer" }
    )

    markdown = Redcarpet::Markdown.new(
      renderer,
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      strikethrough: true,
      superscript: true,
      highlight: true,
      footnotes: true
    )

    markdown.render(content).html_safe
  end

  def extract_title_from_path(path)
    # Convert path like "getting-started/quick-start" to "Quick Start"
    path.split("/").last.split("-").map(&:capitalize).join(" ")
  end

  def build_breadcrumbs(path)
    parts = path.split("/")
    breadcrumbs = [ { name: "Docs", path: "/docs" } ]

    parts.each_with_index do |part, index|
      breadcrumb_path = parts[0..index].join("/")
      breadcrumbs << {
        name: part.split("-").map(&:capitalize).join(" "),
        path: "/docs/#{breadcrumb_path}"
      }
    end

    breadcrumbs
  end

  def render_not_found
    render plain: "Documentation page not found", status: :not_found
  end
end
