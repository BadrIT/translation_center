require 'spec_helper'
module TranslationCenter
  describe TranslationsController, :type => :controller do
  	let(:user) {FactoryGirl.create(:user)}
	let(:translation) {FactoryGirl.create(:translation)}
	before(:each) do
	  sign_in user
   	end

  	describe "POST vote" do
  	  it "should assign translation & render vote.js" do
  	  	post :vote, translation_id: translation.id, format: :js
  	  	expect(assigns(:translation)).to eq translation
	      	expect(response).to render_template(:vote)
  	  end
  	end

  	describe "POST unvote" do
  	  it "should assign translation & render unvote.js" do
  	  	post :unvote, translation_id: translation.id, format: :js
  	  	expect(assigns(:translation)).to eq translation
	      	expect(response).to render_template(:unvote)
  	  end
  	end

  	 describe "POST accept" do
  	  it "should assign translation & render accepted.js" do
  	  	post :accept, translation_id: translation.id, format: :js
  	  	expect(assigns(:translation)).to eq translation
  	  	expect(assigns(:translation_already_accepted)).to be_falsey
  	  	translation.reload
  	  	expect(translation.status).to eq "accepted"
	      	expect(response).to render_template(:accept)
  	  end
  	end

  	describe "POST unaccept" do
  	  it "should assign translation & render unaccept.js" do
  	  	post :unaccept, translation_id: translation.id, format: :js
  	  	expect(assigns(:translation)).to eq translation
  	  	translation.reload
  	  	expect(translation.status).to eq "pending"
	      	expect(response).to render_template(:unaccept)
  	  end
  	end

  	describe "POST destroy" do
  	  it "should assign translation & render destroy.js" do
  	  	delete :destroy, id: translation.id, format: :js
  	  	expect(assigns(:translation)).to eq translation
	      	expect(Translation.where(id: translation.id)).to be_empty
	      	expect(response).to render_template(:destroy)
  	  end
  	end

  	describe "GET search" do
  	  it "should assign translations & render search" do
  	  	get :search, translation_value: "a"
  	  	expect(assigns(:translations).class.name).to eq "ActiveRecord::Relation"
  	  	expect(assigns(:total_pages).class.name).to eq "Fixnum"
	      	expect(response).to render_template(:search)
  	  end

  	   it "should render search.js" do
  	  	get :search, translation_value: "a",format: :js
	      	expect(response).to render_template(:search)
  	  end
  	end
  end
end