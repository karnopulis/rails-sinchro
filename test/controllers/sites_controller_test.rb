require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  setup do
    @site = sites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site" do
    assert_difference('Site.count') do
      post :create, site: { csv_collection_order: @site.csv_collection_order, csv_images_order: @site.csv_images_order, csv_offer_order: @site.csv_offer_order, csv_variant_order: @site.csv_variant_order, home_login: @site.home_login, home_pass: @site.home_pass, name: @site.name, quantity_field: @site.quantity_field, scu_field: @site.scu_field, site_global_parent: @site.site_global_parent, site_login: @site.site_login, site_offer_order: @site.site_offer_order, site_pass: @site.site_pass, site_variant_order: @site.site_variant_order, sort_order: @site.sort_order, title_field: @site.title_field, url: @site.url }
    end

    assert_redirected_to site_path(assigns(:site))
  end

  test "should show site" do
    get :show, id: @site
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @site
    assert_response :success
  end

  test "should update site" do
    patch :update, id: @site, site: { csv_collection_order: @site.csv_collection_order, csv_images_order: @site.csv_images_order, csv_offer_order: @site.csv_offer_order, csv_variant_order: @site.csv_variant_order, home_login: @site.home_login, home_pass: @site.home_pass, name: @site.name, quantity_field: @site.quantity_field, scu_field: @site.scu_field, site_global_parent: @site.site_global_parent, site_login: @site.site_login, site_offer_order: @site.site_offer_order, site_pass: @site.site_pass, site_variant_order: @site.site_variant_order, sort_order: @site.sort_order, title_field: @site.title_field, url: @site.url }
    assert_redirected_to site_path(assigns(:site))
  end

  test "should destroy site" do
    assert_difference('Site.count', -1) do
      delete :destroy, id: @site
    end

    assert_redirected_to sites_path
  end
end
