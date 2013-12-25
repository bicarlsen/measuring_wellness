require 'spec_helper'

describe "HomePages" do
	subject { page }

	describe 'Home page' do
		before { visit root_path }
	
		it { should have_title 'Measuring Wellness' }	

		context 'when not logged in' do
			it { should have_content 'What We Do' }
			it { should have_link 'Sign In' }
			it { should have_link 'Register' }
			it { should_not have_link 'Settings' }
			it { should_not have_link 'Log Out' }
		end # not logged in
		 
		context 'when logged in' do
			let(:user) { FactoryGirl.create :user }
			before { sign_in user }

			it { should have_content user.name }
			it { should_not have_link 'Register' }
			it { should_not have_link 'Sign In' }
			it { should have_link 'Settings' }
			it { should have_link 'Sign Out' }
			it { should have_content user.name }
		end # logged in
	end # Home page

	describe 'Measures page' do
		before { visit measures_path }

		it { should have_content 'What We Measure'}
	end # Measures page

	describe 'Homeostasis page' do
		before { visit homeostasis_path }

		it { should have_content 'Finding Balance' }
	end
end # HomePages
