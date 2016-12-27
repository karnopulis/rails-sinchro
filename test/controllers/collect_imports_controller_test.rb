require 'test_helper'

class CollectImportsControllerTest < ActionController::TestCase
  setup do
    @collect_import = collect_imports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:collect_imports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create collect_import" do
    assert_difference('CollectImport.count') do
      post :create, collect_import: {  }
    end

    assert_redirected_to collect_import_path(assigns(:collect_import))
  end

  test "should show collect_import" do
    get :show, id: @collect_import
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @collect_import
    assert_response :success
  end

  test "should update collect_import" do
    patch :update, id: @collect_import, collect_import: {  }
    assert_redirected_to collect_import_path(assigns(:collect_import))
  end

  test "should destroy collect_import" do
    assert_difference('CollectImport.count', -1) do
      delete :destroy, id: @collect_import
    end

    assert_redirected_to collect_imports_path
  end
end
