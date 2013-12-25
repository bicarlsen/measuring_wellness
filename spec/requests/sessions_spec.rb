require 'spec_helper'

describe "Sessions" do
	subject { page }
	let(:user) { FactoryGirl.create :user }

	describe 'Signing In' do	
		before { visit signin_path}
		
		it { should have_content 'Sign In' }

		context 'with valid credentials' do
			before do
				fill_in 'Email', with: user.email
				fill_in 'Password', with: user.password

				click_button 'Sign In'
			end

			it { should have_content user.name }
		end # valid credentials

		context 'with invalid credentials' do
			before { click_button 'Sign In' }

			it { should have_selector '.flash-error' }
			it 'should not be logged in' do
				should have_link 'Sign In'
			end # not logged in
		end # invalid credentials
	end # Signing In

	describe 'Signing Out' do
		before do 
			sign_in user
			visit root_path
			click_link 'Sign Out'
		end

		it 'should go to the home page for anonymous users' do
			should have_link 'Sign In'
		end # should be the home page
	end # Signing Out

end # end Sessions
