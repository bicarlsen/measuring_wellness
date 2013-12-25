require 'spec_helper'

describe "UserPages" do
	subject { page }
	let(:user) { FactoryGirl.create :user }
	before { sign_in user }

	describe 'Registering' do
		before do
			sign_out user
			visit root_path 
			click_link 'Register'
		end
		
		it { should have_content 'Sign Up' }

		describe 'Submitting the form' do
			let(:new_user) { FactoryGirl.build :user}
			
			context 'with valid info' do
				before do 
					fill_in 'Name', with: new_user.name
					fill_in 'Email', with: new_user.email
					fill_in 'Password', with: new_user.password
					fill_in 'Password Confirmation', with: new_user.password_confirmation
					
					click_button 'Sign Up'
				end

				it 'should go to Terms of Use' do
					have_content 'Terms of Use'
				end # Terms of Use

			end # valid

			context 'with invalid info' do
				before { click_button 'Sign Up' }

				it { should have_selector '.form-error' }
			end # invalid
		end #  submitting the form

		describe 'Terms of Use' do
			context 'when not logged in' do
				before do
					visit terms_of_use_path 
				end

				it { should have_content 'Please sign in' }

			end # not logged in

			context 'when logged in' do
				before do 
					sign_in user
					visit terms_of_use_path
				end

				context 'when accepted' do
					before do 
						check 'user_terms_of_use'
						click_button 'Submit'
					end

					it "should go to the user's home page" do
						should have_content user.name
					end # go to home page
				end # accepted
				
				context 'when not accepted' do
					before do
						uncheck 'user_terms_of_use'
						click_button 'Submit'
					end

					it { should have_content 'Please accept the Terms of Use' }
				end # not accepted
			end # logged in
		end # Terms of Use

		context 'when logged in' do
			before do
				sign_in user
				visit signup_path
			end

			it "should go to the user's home page" do
				should have_content user.name
			end # go to user's home page
		end # logged in
	end # Registering

	describe 'Home page' do
		it { should have_content user.name }	
		it { should have_link 'Settings' }
		it { should have_link 'Profile' }
		it { should have_link 'Order Test' }
		it { should have_link 'Results' }
		it { should have_link 'Store' }
	end # Home page

	describe 'Profile page' do

	end # Profile page

	describe 'Settings page' do

	end # Settings page

	describe 'Results page' do

	end # Results page

	describe 'Tests page' do

	end # Order Test page

end # UserPages
