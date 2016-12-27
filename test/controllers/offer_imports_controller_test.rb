require 'test_helper'

class OfferImportsControllerTest < ActionController::TestCase
  setup do
    @offer_import = offer_imports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:offer_imports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create offer_import" do
    assert_difference('OfferImport.count') do
      post :create, offer_import: {  }
    end

    assert_redirected_to offer_import_path(assigns(:offer_import))
  end

  test "should show offer_import" do
    get :show, id: @offer_import
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @offer_import
    assert_response :success
  end

  test "should update offer_import" do
    patch :update, id: @offer_import, offer_import: {  }
    assert_redirected_to offer_import_path(assigns(:offer_import))
  end

  test "should destroy offer_import" do
    assert_difference('OfferImport.count', -1) do
      delete :destroy, id: @offer_import
    end

    assert_redirected_to offer_imports_path
  end
end
