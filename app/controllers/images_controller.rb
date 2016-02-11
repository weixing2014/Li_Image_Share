class ImagesController < ApplicationController
  before_action :find_image, only: [:show, :destroy, :edit, :update]

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)

    if @image.save
      flash[:notice] = 'You have successfully uploaded the image!'
      redirect_to image_path(@image)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def index
    tag = params[:tag]

    if ActsAsTaggableOn::Tag.exists?(name: tag)
      @filtered = true
      @images = Image.tagged_with(tag)
    else
      flash.now[:notice] = 'No such tag exists!' if tag.present?
      @images = Image.all
    end
  end

  def destroy
    @image.destroy!
    flash[:notice] = 'Your selected image has been deleted.'
    redirect_to action: :index, status: 303
  end

  def edit
  end

  def update
    if @image.update(image_params)
      flash[:notice] = 'You successfully updated the image!'
      redirect_to action: :show
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def find_image
    @image = Image.find(params[:id])
  end

  def image_params
    params.require(:image).permit(:url, :tag_list)
  end
end
