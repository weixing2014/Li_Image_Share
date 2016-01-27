require 'test_helper'
class ImagesControllerTest < ActionController::TestCase
  VALID_IMAGE_URL = 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e9/Ruby_on_Rails.svg/791px-Ruby_on_Rails.svg.png'

  test "should get index" do
    get :index
    assert_response :success
  end

  test "create a new image" do
    post :create, image: {url: VALID_IMAGE_URL}
    assert_redirected_to image_path(assigns(:image))
  end

  test "fail to create a new image" do
    post :create, image: {url: ""}
    assert_response :unprocessable_entity
    assert_equal "Url can't be blank", flash[:error]
    assert_select 'form#new_image'
  end

  test "show new image page" do
    get :new
    assert_response :success
    assert_select 'form#new_image'
  end

  test "show an image" do
    image = Image.create(url: VALID_IMAGE_URL)
    get :show, id: image.id
    assert_response :success
    assert_select 'img', src: image.url
  end

  test "display all saved images on index page" do
    7.times do
      Image.create!(url: VALID_IMAGE_URL)
    end

    get :index
    assert_response :success
    assert_select 'img.collection_image', {count: Image.count, src: VALID_IMAGE_URL},
                  'Wrong number of images displayed'
  end
end
