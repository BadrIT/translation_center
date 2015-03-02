require "spec_helper"
module TranslationCenter
  describe CenterController, :type => :controller do
  	let(:user) {FactoryGirl.create(:user)}
	let(:translation_key) {FactoryGirl.create(:translation_key)}
	before(:each) do
	  sign_in user
 	end
      after(:all) do
         FileUtils.rm_r("config/locales")
      end

   describe "GET set_language_from" do
 	it "should set language the user is translating from & render nothing" do
 	  get :set_language_from, lang: "ar"
 	  expect(I18n.locale).to eq :ar
 	  expect(response.body).to be_blank
 	end
   end

   describe "GET set_language_to" do
	it "should set language the user is translating to & redirect to root" do
 	  get :set_language_to, lang: "ar"
 	  expect(session[:lang_to]).to eq :ar
        expect(response).to redirect_to(:root)
 	end
 
 	it "should render nothing" do
 	  get :set_language_to, lang: "ar", format: :js
 	  expect(session[:lang_to]).to eq :ar
 	  expect(response.body).to be_blank
 	end
    end

     describe "GET dashboard" do
 	it "should set dashboard stats & render dashboard.html" do
 	  get :dashboard
  	  expect(assigns(:translations_changes).class.name).to eq "ActiveRecord::Relation"
  	  expect(assigns(:total_pages).class.name).to eq "Fixnum"
        expect(response).to render_template(:dashboard)
 	end

 	it "should render search_activity.html" do
 	  get :dashboard, format: :js
        expect(response).to render_template(:search_activity)
 	end
   end
     
    describe "GET search_activity" do
    	it "should render search_activity.js" do
 	  get :search_activity, format: :js
 	  expect(assigns(:translations_changes).class.name).to eq "ActiveRecord::Relation"
  	  expect(assigns(:total_pages).class.name).to eq "Fixnum"
        expect(response).to render_template(:search_activity)
 	end
    end

     describe "GET manage" do
        Dir.mkdir "config/locales"  
        File.open( "config/locales/en.yml", "w+")
    	it "should run yaml2db" do
 	  get :manage, locale: "en", manage_action: "yaml2db", format: :js
 	end

 	it "should run db2yaml" do

 	  get :manage, locale: "en", manage_action: "db2yaml", format: :js
 	end
 	
 	it "should run yaml2db & render manage.js" do
 	  get :manage, locale: "all", manage_action: "db2yaml", format: :js
        expect(response).to render_template(:manage)
 	end
    end
  end
end