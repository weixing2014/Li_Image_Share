class ImagesController < ApplicationController
  def new
    @image = Image.new
  end

  def create
    url    = params[:image][:url]
    @image = Image.new(url: url)
    if @image.save
      redirect_to image_path(@image)
    else
      flash.now[:error] = @image.errors.full_messages.first
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @image = Image.find(params[:id])
  end

  def index
    @images = Image.all
  end
end
