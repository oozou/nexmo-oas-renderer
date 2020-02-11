# frozen_string_literal: true

class String
  def render_markdown(options = {})
    Nexmo::OAS::Renderer::MarkdownPipeline.new(options).call(self).html_safe
  end

  def unindent
    indent = squeeze("\n").lines.map { |line| line.index(/[^\s]/) }.compact.min || 0
    gsub(/^[[:blank:]]{#{indent}}/, '')
  end

  def unindent!
    replace(unindent)
  end
end
