class ImagesController < ApplicationController
  before_action :find_image, only: [:show, :destroy]

  def new
    @image = Image.new
  end

  def create
    url = params[:image][:url]
    tags = params[:image][:tag_list]

    @image = Image.new(url: url, tag_list: tags)

    if @image.save
      flash[:notice] = 'You have successfully uploaded the image!'
      redirect_to image_path(@image)
    else
      flash.now[:error] = @image.errors.full_messages.first
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def index
    @images = Image.all
  end

  def destroy
    @image.destroy!
    flash[:notice] = 'Your selected image has been deleted.'
    redirect_to action: :index, status: 303
  end

  private

  def find_image
    @image = Image.find(params[:id])
  end
end
