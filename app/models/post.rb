class Post
  include ActiveModel::Model
  include ActiveModel::Attributes

  # Define attributes from frontmatter
  attribute :title, :string
  attribute :description, :string
  attribute :date, :date
  attribute :author, :string
  attribute :tags, array: true, default: []
  attribute :category, :string
  attribute :status, :string
  attribute :cover_image, :string
  attribute :slug, :string
  attribute :content, :string
  attribute :reading_time, :integer

  validates :title, :date, :content, presence: true
  validates :status, inclusion: { in: %w[draft published] }

  class << self
    def all
      Dir.glob("blog/*.md").map { |file| from_file(file) }
         .select { |post| post.status == "published" }
         .sort_by(&:date)
         .reverse
    end

    def find(slug)
      all.find { |post| post.slug == slug } || raise(ActiveRecord::RecordNotFound)
    end

    def from_file(file_path)
      content = File.read(file_path)
      frontmatter, markdown = parse_frontmatter(content)
      
      # Create slug from filename
      slug = File.basename(file_path, ".md")
      
      # Calculate reading time (words per minute)
      words_per_minute = 200
      word_count = markdown.split.size
      reading_time = (word_count / words_per_minute.to_f).ceil

      new(
        frontmatter.merge(
          content: markdown,
          slug: slug,
          reading_time: reading_time
        )
      )
    end

    private

    def parse_frontmatter(content)
      # Match YAML frontmatter between --- markers
      if content =~ /\A---\r?\n(.*?)\r?\n---\r?\n(.*)\z/m
        [YAML.safe_load($1, permitted_classes: [Date]), $2]
      else
        [{}, content]
      end
    end
  end

  def to_param
    slug
  end

  def rendered_content
    @rendered_content ||= begin
      renderer = PrismRenderer.new(
        with_toc_data: true,
        hard_wrap: true,
        link_attributes: { target: '_blank', rel: 'noopener' }
      )
      
      markdown = Redcarpet::Markdown.new(
        renderer,
        fenced_code_blocks: true,
        autolink: true,
        tables: true,
        strikethrough: true,
        highlight: true,
        footnotes: true,
        quote: true
      )
      markdown.render(content)
    end
  end

  # Custom renderer that adds Prism.js classes
  class PrismRenderer < Redcarpet::Render::HTML
    def block_code(code, language)
      language ||= 'plaintext'
      %(<pre><code class="language-#{language}">#{code}</code></pre>)
    end
  end
end 