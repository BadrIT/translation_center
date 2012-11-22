require 'test_helper'

module TranslationCenter
  class TranslationKeysControllerTest < ActionController::TestCase
    setup do
      @translation_key = translation_keys(:one)
    end
  
    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:translation_keys)
    end
  
    test "should get new" do
      get :new
      assert_response :success
    end
  
    test "should create translation_key" do
      assert_difference('TranslationKey.count') do
        post :create, translation_key: { category_id: @translation_key.category_id, last_accessed: @translation_key.last_accessed, name: @translation_key.name }
      end
  
      assert_redirected_to translation_key_path(assigns(:translation_key))
    end
  
    test "should show translation_key" do
      get :show, id: @translation_key
      assert_response :success
    end
  
    test "should get edit" do
      get :edit, id: @translation_key
      assert_response :success
    end
  
    test "should update translation_key" do
      put :update, id: @translation_key, translation_key: { category_id: @translation_key.category_id, last_accessed: @translation_key.last_accessed, name: @translation_key.name }
      assert_redirected_to translation_key_path(assigns(:translation_key))
    end
  
    test "should destroy translation_key" do
      assert_difference('TranslationKey.count', -1) do
        delete :destroy, id: @translation_key
      end
  
      assert_redirected_to translation_keys_path
    end
  end
end
