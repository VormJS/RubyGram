require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'actions requires login: ' do
    it 'index' do
      get '/users'
      should redirect_to(login_url)
    end

    it 'show' do
      get '/users/1'
      should redirect_to(login_url)
    end

    it 'edit' do
      get '/users/1/edit'
      should redirect_to(login_url)
    end

    it 'update' do
      put '/users/1'
      should redirect_to(login_url)
    end

    it 'destroy' do
      delete '/users/1/'
      should redirect_to(login_url)
    end
  end


  describe 'Controller methods' do
    
    before {
      @user1 = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user)
      sign_in @user1
    }

    context 'New' do
      before{
        sign_out @user1
      }
      
      it 'render form for sign up' do 
        get '/signup'
        expect(response).to be_successful
        should render_template('new')
        expect(response.body).to include('Create account')
      end
    end

    context 'Create' do
      before{
        sign_out @user1
      }

      it 'works with valid data' do
        @new_user = FactoryBot.attributes_for(:user)
        post '/users', params: {user: @new_user}
        expect(flash[:success]).to eq 'Welcome to the RubyGram!'
        should redirect_to("/users/#{User.last.id}")
      end

      it 'fails with invalid data' do
        @new_user = FactoryBot.attributes_for(:user, :invalid)
        post '/users', params: {user: @new_user}
        expect(flash[:danger])
        should render_template('new')
      end
    end

    context 'Index' do
      it 'shows all users' do 
        get '/users'
        expect(response).to be_successful
        should render_template('index')
        expect(response.body).to include("#{@user1.name}")
        expect(response.body).to include("#{@user2.name}")
      end
    end

    context 'Show' do
      before {
        @user2.posts.create(description: 'sample text')
      }

      it 'displays user profile and his posts' do 
        get "/users/#{@user2.id}"
        expect(response).to be_successful
        should render_template('show') 
        expect(response.body).to include("#{@user2.name}")
        expect(response.body).to include('sample text')
      end
    end

    context 'Edit' do
      it 'render edit form for current user' do 
        get "/users/#{@user1.id}/edit"
        expect(response).to be_successful
        should render_template('edit')
        expect(response.body).to include('Save changes')
      end

      it 'redirect to home for not current user' do 
        get "/users/#{@user2.id}/edit"
        should redirect_to(root_url)
      end
    end

    context 'Update' do
      before { @params = { name: 'new name',
                 email: 'newemail@mail.org',
                 password: 'newpassword',
                 password_confirmation: 'newpassword'}
      }

      it 'works for current user' do 
        put "/users/#{@user1.id}", params: { user: @params}
        @user1.reload
        expect(@user1.name).to eq('new name')
        expect(@user1.email).to eq('newemail@mail.org')
        expect(flash[:success]).to eq 'Profile updated'
        should redirect_to("/users/#{@user1.id}")
      end

      it 'can\'t become admin via web' do 
        expect(@user1.admin).to eq(false)
        put "/users/#{@user1.id}", params: { user: { admin:true } }
        @user1.reload
        expect(@user1.admin).to eq(false)
      end

      it 'blocked for other users' do 
        put "/users/#{@user2.id}", params: { user: @params}
        @user1.reload
        expect(@user1.name).not_to eq('new name')
        expect(@user1.email).not_to eq('newemail@mail.org')
        should redirect_to(root_url) 
      end
    end

    context 'Destroy' do
      it 'not works for not admins' do 
        delete "/users/#{@user1.id}"
        should redirect_to(root_url)
      end

      it 'works for admin' do

        @admin = FactoryBot.create(:user, :admin)
        sign_in @admin
        @users_number = User.count
        delete "/users/#{@user1.id}"
        expect(flash[:success]).to eq 'User deleted'
        expect(User.count).to eq(@users_number - 1)
        should redirect_to("/users")
      end
    end
  end
end
