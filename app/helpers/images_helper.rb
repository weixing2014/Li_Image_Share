module ImagesHelper
  def render_images(images)
    render partial: 'shared/image', collection: images
  end

  def render_tag_links(links)
    render partial: 'shared/tag_link', collection: links
  end
end
