
# This ApplicationHelper is used in _form.html.erb.old.
# I stopped using it after checkpoint #14 (Validating Posts)
# because Bloc recommended to use the Simple Form gem instead.
#
# I found Simple Form to be quite complicated, so I'm leaving
# this here so that I can come back to it later.

module ApplicationHelper
  def form_group_tag(errors, &block)
    if errors.any?
      content_tag :div, capture(&block), class: 'form-group has-error'
    else
      content_tag :div, capture(&block), class: 'form-group'
    end
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new
    extensions = {fenced_code_blocks: true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    (redcarpet.render text).html_safe
  end
end
