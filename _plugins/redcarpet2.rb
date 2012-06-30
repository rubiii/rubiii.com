require 'fileutils'
require 'digest/md5'
require 'redcarpet'
require 'albino'

PYGMENTS_CACHE_DIR = File.expand_path('../../_cache', __FILE__)
FileUtils.mkdir_p(PYGMENTS_CACHE_DIR)

class Redcarpet2Markdown < Redcarpet::Render::HTML
  def header(text, level)
    id = text.downcase.gsub('&#39;', '').gsub(/[^a-z1-9]+/, '-').chomp('-')
    "<h#{level} id='#{id}'>#{text}</h#{level}>"
  end

  def block_code(code, lang_and_context)
    lang, context = lang_and_context.split("+")
    lang ||= "text"

    path = File.join(PYGMENTS_CACHE_DIR, "#{lang}-#{Digest::MD5.hexdigest code}.html")
    cache(path) do
      colorized = Albino.colorize(code, lang)
      add_code_tags(colorized, lang, context)
    end
  end

  def add_code_tags(code, lang, context)
    if context
      context_desc = context[0,1].upcase + context[1..-1] + ":"
      context_html = "<b>#{context_desc}</b>"
      context_class = "context #{context}"
    else
      context_html = ""
      context_class = ""
    end

    code.sub(/<pre>/, "<pre class='#{context_class}'>#{context_html}<code class=\"#{lang}\">").
         sub(/<\/pre>/, "</code></pre>")
  end

  def cache(path)
    if File.exist?(path)
      File.read(path)
    else
      content = yield
      File.open(path, 'w') {|f| f.print(content) }
      content
    end
  end
end

class Jekyll::MarkdownConverter
  def extensions
    Hash[ *@config['redcarpet']['extensions'].map {|e| [e.to_sym, true] }.flatten ]
  end

  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet2Markdown.new(extensions), extensions)
  end

  def convert(content)
    return super unless @config['markdown'] == 'redcarpet2'
    markdown.render(content)
  end
end
