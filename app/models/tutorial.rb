class Tutorial
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :description, :string
  attribute :difficulty, :string
  attribute :category, :string
  attribute :order, :integer
  attribute :estimated_time, :string
  attribute :tags, array: true, default: []
  attribute :author, :string
  attribute :date, :date
  attribute :status, :string
  attribute :dragonruby_version, :string
  attribute :slug, :string
  attribute :content, :string
  attribute :starter_code, :string
  attribute :solution_code, :string
  attribute :readonly_code, :string

  validates :title, :content, presence: true
  validates :status, inclusion: { in: %w[draft published archived] }
  validates :difficulty, inclusion: { in: %w[beginner intermediate advanced] }

  class << self
    def all
      Dir.glob("dragonruby/*.md").map { |file| from_file(file) }
         .select { |tutorial| tutorial.status == "published" }
         .sort_by(&:order)
    end

    def find(slug)
      all.find { |tutorial| tutorial.slug == slug } || raise(ActiveRecord::RecordNotFound)
    end

    def from_file(file_path)
      content = File.read(file_path)
      frontmatter, markdown = parse_frontmatter(content)

      slug = File.basename(file_path, ".md")

      code_blocks = extract_code_blocks(content)

      new(
        frontmatter.merge(
          content: markdown,
          slug: slug,
          starter_code: code_blocks[:starter],
          solution_code: code_blocks[:solution],
          readonly_code: code_blocks[:readonly]
        )
      )
    end

    private

    def parse_frontmatter(content)
      if content =~ /\A---\r?\n(.*?)\r?\n---\r?\n(.*)\z/m
        [ YAML.safe_load($1, permitted_classes: [ Date ]), $2 ]
      else
        [ {}, content ]
      end
    end

    def extract_code_blocks(content)
      blocks = { starter: nil, solution: nil, readonly: nil }

      content.scan(/```ruby(?::(\w+))?\n(.*?)```/m) do |type, code|
        case type
        when "starter"
          blocks[:starter] = code.strip
        when "solution"
          blocks[:solution] = code.strip
        when "readonly"
          blocks[:readonly] = code.strip
        else
          blocks[:starter] ||= code.strip
        end
      end

      blocks
    end
  end

  def to_param
    slug
  end

  def rendered_content
    @rendered_content ||= begin
      renderer = DragonRubyRenderer.new(
        with_toc_data: true,
        hard_wrap: true,
        link_attributes: { target: "_blank", rel: "noopener" }
      )

      markdown = Redcarpet::Markdown.new(
        renderer,
        fenced_code_blocks: true,
        autolink: true,
        tables: true,
        strikethrough: true,
        highlight: true,
        footnotes: true,
        quote: true,
        lax_spacing: true
      )
      markdown.render(content)
    end
  end

  # Extract only the starter code block for the interactive editor
  def literate_code
    @literate_code ||= begin
      lines = []
      in_code_block = false
      code_type = nil
      found_starter = false

      content.split("\n").each do |line|
        # Detect code blocks
        if line.match(/^```ruby(?::(\w+))?/)
          in_code_block = true
          code_type = $1

          # Only include the starter code block
          if code_type == "starter"
            found_starter = true
          end
          next
        elsif line == "```"
          in_code_block = false
          code_type = nil
          next
        end

        # Inside starter code block - use raw code
        if in_code_block && code_type == "starter"
          lines << line
        end
      end

      # If no starter block found, return a default
      if lines.empty?
        lines << "def tick args"
        lines << "  # Your code here"
        lines << "end"
      end

      lines.join("\n")
    end
  end

  class DragonRubyRenderer < Redcarpet::Render::HTML
    def block_code(code, language)
      if language&.start_with?("ruby")
        lang_parts = language.split(":")
        base_lang = lang_parts[0]
        block_type = lang_parts[1]

        data_attr = block_type ? %( data-block-type="#{block_type}") : ""

        %(<div class="code-block"#{data_attr}><pre><code class="language-#{base_lang}">#{code}</code></pre></div>)
      else
        language ||= "plaintext"
        %(<div class="code-block"><pre><code class="language-#{language}">#{code}</code></pre></div>)
      end
    end

    def list(contents, list_type)
      tag = list_type == :ordered ? "ol" : "ul"
      "<#{tag} class=\"list-#{list_type}\">\n#{contents}</#{tag}>\n"
    end

    def list_item(text, list_type)
      "<li class=\"list-item\">\n#{text}\n</li>\n"
    end

    def header(text, header_level)
      tag = "h#{header_level}"
      "<#{tag} class=\"heading-#{header_level}\">\n#{text}\n</#{tag}>\n"
    end

    def paragraph(text)
      "<p>\n#{text}\n</p>\n"
    end
  end
end
