require 'spec_helper'
module TranslationCenter
	describe CategoriesController, :type => :controller do
	  let(:user) {FactoryGirl.create(:user)}
	  before(:each) do
	    sign_in user
   	  end

	  describe "GET index" do
	    it "assigns @categories & render index template" do
	      categories = Category.all

	      get :index, use_route: "trancelaion_center"
	      expect(assigns(:categories)).to eq(categories)
	      expect(response).to render_template(:index)
	    end
	  end

	 describe "GET show" do
	    it "assigns @category & render show template" do
	  	category = FactoryGirl.create(:category)

	      get :show, id: category.id, use_route: "trancelaion_center"
	      expect(assigns(:category)).to eq(category)
	      expect(response).to render_template(:show)
	    end
	  end

	  describe "GET more_keys" do
	  	it "assigns @category & render keys", :js => true do
	  	  category = FactoryGirl.create(:category)
	  	  get :more_keys, category_id: category.id, format: :js, use_route: "trancelaion_center"
	      	  expect(response).to render_template(:keys)
	  	end
	  end

	    describe "GET destroy" do
	  	it "assigns @category & render index" do
	  	  category = FactoryGirl.create(:category)
	        get :destroy, id: category.id, use_route: "trancelaion_center"
	      	  expect(Category.where(id: category.id)).to be_empty
	      	  expect(response).to redirect_to(:categories)
	    end
	  end

  end
end