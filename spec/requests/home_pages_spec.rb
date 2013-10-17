require 'spec_helper'

describe "HomePages" do

	describe "Home page" do
		before { visit root_path}
		
		it { should have_title "Measuring Wellness" }
		it { should haave_content "Measuring Wellness" }
	end
end
