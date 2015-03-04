require 'spec_helper'
module TranslationCenter
  describe TranslationKeysController, :type => :controller do
  	let(:user) {FactoryGirl.create(:user)}
	let(:translation_key) {FactoryGirl.create(:translation_key)}
	before(:each) do
	  sign_in user
 	end
 	describe "POST update_translation" do
 	  it "should assigns @translation & render nothing" do
 	  	post :update_translation, translation_key_id: translation_key.id, format: :json, use_route: "trancelaion_center"
 	  	  expect(assigns(:translation_key)).to eq translation_key
 	  	  expect(response.body).to be_blank
 	  end
 	  it "should assigns @translation & render json" do
 	  	post :update_translation, translation_key_id: translation_key.id, value: "value value", format: :json, use_route: "trancelaion_center"
 	  	  expect(assigns(:translation_key)).to eq translation_key
 	  end
 	end

	describe "GET translations" do
 	  it "should assigns @translations sorted by votes & render translations.js" do
		FactoryGirl.create(:translation, translation_key: translation_key)
		# FactoryGirl.create(:translation, value: "value", translation_key: translation_key)
 	  	get :translations, translation_key_id: translation_key.id, sort_by: "votes", format: :js, use_route: "trancelaion_center"
 	  	expect(assigns(:translations).first.class.name).to eq "TranslationCenter::Translation"
	      	expect(response).to render_template(:translations)
 	  end
 	  it "should assigns @translations sorted by created_at" do
 	  	FactoryGirl.create(:translation, translation_key: translation_key)
 	  	get :translations, translation_key_id: translation_key.id, format: :js, use_route: "trancelaion_center"
 	  	expect(assigns(:translations).first.class.name).to eq "TranslationCenter::Translation"
 	  end
 	end

 	describe "GET show" do
  	  it "should assign @translation_key & render show" do
  	  	get :show, id: translation_key.id, use_route: "trancelaion_center"
  	  	expect(assigns(:translation_key)).to eq translation_key
	      	expect(response).to render_template(:show)
  	  end
  	end

  	describe "PUT update" do
  	  it "should assign @translation_key" do
  	  	put :update, id: translation_key.id, format: :json, use_route: "trancelaion_center"
  	  	expect(assigns(:translation_key)).to eq translation_key
  	  	expect(TranslationKey.find(translation_key).name).to eq translation_key.name
  	  end

  	  it "should assign @translation_key & update value" do
  	  	put :update, id: translation_key.id, format: :json, value: "new value", use_route: "trancelaion_center"
  	  	expect(assigns(:translation_key)).to eq translation_key
  	  	expect(TranslationKey.find(translation_key).name).to eq "new value"
  	  end
  	end
  
  	describe "POST destroy" do
  	  it "should assign translation & render destroy.js" do
  	  	delete :destroy, id: translation_key.id, format: :js, use_route: "trancelaion_center"
  	  	expect(assigns(:category)).to eq translation_key.category
  	  	expect(assigns(:translation_key)).to eq translation_key
	      	expect(TranslationKey.where(id: translation_key.id)).to be_empty
	      	expect(response).to render_template(:destroy)
  	  end

  	   it "should assign render categories/show.html" do
  	  	delete :destroy, id: translation_key.id, use_route: "trancelaion_center"
	      	expect(response).to redirect_to(translation_key.category)
  	  end
  	end

      describe "GET search" do
        it "should assign translations & render search" do
          get :search, search_key_name: translation_key.name, use_route: "trancelaion_center"
          expect(assigns(:translation_key)).to eq translation_key
          expect(response).to redirect_to(translation_key)
        end

         it "should render search.js" do
          get :search, query: " ", format: :json, use_route: "trancelaion_center"
          expect(assigns(:key_names).class.name).to eq "ActiveRecord::Relation"
          expect(response).not_to redirect_to(translation_key)
        end
    end  
  end
end