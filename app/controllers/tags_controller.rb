class TagsController < ApplicationController
  helper ImagesHelper

  def show
    tag = params[:tag_name]
    @tagged_images = Image.tagged_with(tag)
  end
end
