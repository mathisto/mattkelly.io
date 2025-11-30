Rails.application.config.to_prepare do
  Lookbook::Theme.class_eval do
    def to_css
      return @css unless @css.nil?
      @css ||= if @overrides.present?
        styles = [ ":root {" ]
        styles << @overrides.reject { |key| key.to_s.start_with?("favicon") }.map do |key, value|
          "  --lookbook-#{key.to_s.underscore.tr("_", "-")}: #{value};"
        end
        styles.push "}"

        # Add custom prose overrides for Tokyo Night theme
        styles.push ""
        styles.push "/* Tokyo Night prose overrides */"
        styles.push ".prose h1, .prose h2, .prose h3, .prose h4, .prose h5, .prose h6 {"
        styles.push "  color: var(--lookbook-prose-headings, #f0f4ff) !important;"
        styles.push "}"
        styles.push ".prose strong, .prose b {"
        styles.push "  color: var(--lookbook-prose-strong, #e0e7ff) !important;"
        styles.push "}"
        styles.push ".prose em, .prose i {"
        styles.push "  color: var(--lookbook-prose-em, #c0caf5) !important;"
        styles.push "}"
        styles.push ".prose code {"
        styles.push "  color: var(--lookbook-prose-code, #7dcfff) !important;"
        styles.push "  background-color: #24283b !important;"
        styles.push "}"
        styles.push ".prose ul, .prose ol, .prose li {"
        styles.push "  color: var(--lookbook-prose-text, #e0e7ff) !important;"
        styles.push "}"
        styles.push ".prose ul > li::marker, .prose ol > li::marker {"
        styles.push "  color: var(--lookbook-prose-text, #e0e7ff) !important;"
        styles.push "}"
        styles.push ".prose {"
        styles.push "  color: var(--lookbook-prose-text, #e0e7ff) !important;"
        styles.push "}"
        styles.push ".prose p {"
        styles.push "  color: var(--lookbook-prose-text, #e0e7ff) !important;"
        styles.push "}"
        styles.push ".prose a {"
        styles.push "  color: var(--lookbook-prose-link, #7aa2f7) !important;"
        styles.push "}"

        styles.join("\n")
      else
        ""
      end
    end
  end
end
