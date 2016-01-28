require 'test_helper'
class ImagesControllerTest < ActionController::TestCase
  VALID_IMAGE_URL = 'https://upload.wikimedia.org/wikipedia/en/thumb/e/e9/Ruby_on_Rails.svg/791px-Ruby_on_Rails.svg.png'

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'create a new image' do
    assert_difference('Image.count', 1) do
      post :create, image: { url: VALID_IMAGE_URL }
    end

    assert_redirected_to image_path(assigns(:image))
  end

  test 'fail to create a new image' do
    assert_no_difference('Image.count') do
      post :create, image: { url: '' }
    end

    assert_response :unprocessable_entity
    assert_equal "Url can't be blank", flash[:error]
    assert_select 'form#new_image'
  end

  test 'show new image page' do
    get :new
    assert_response :success
    assert_select 'form#new_image'
  end

  test 'show an image' do
    image = Image.create(url: VALID_IMAGE_URL)
    get :show, id: image.id
    assert_response :success
    assert_select 'img' do |elements|
      assert_equal [image.url], elements.map { |el| el[:src] }
    end
  end

  test 'fail to show an image' do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, id: -1
    end
  end

  test 'display all saved images on index page' do
    7.times do
      Image.create!(url: VALID_IMAGE_URL)
    end

    get :index
    assert_response :success
    assert_select 'img.collection_image' do |elements|
      assert_equal [VALID_IMAGE_URL] * Image.count,
                   elements.map { |el| el[:src] }
    end
  end

  test 'delete a saved image with a valid id' do
    image = Image.create!(url: VALID_IMAGE_URL)

    assert_difference('Image.count', -1) do
      delete :destroy, id: image.id
    end

    assert_equal 'Your selected image has been deleted.', flash[:notice]
    assert_redirected_to action: :index
  end

  test 'fail to delete a saved image with an invalid id' do
    assert_no_difference('Image.count') do
      assert_raises ActiveRecord::RecordNotFound do
        delete :destroy, id: -1
      end
    end
  end
end
