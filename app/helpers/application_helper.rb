module ApplicationHelper
  def render_nav_item(content, active)
    classes = 'nav-item'
    classes << ' active' if active
    content_tag :li, content, class: classes
  end
end
