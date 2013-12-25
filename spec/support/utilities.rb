# FILE: utilities.rb

def sign_in(user, options = {})
	if options[:no_capybara]
		remember_token = User.new_remember_token
		cookies[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))

	else
		visit signin_path
		fill_in "Email", with: user.email
		fill_in "Password", with: user.password
		click_button "Sign In"
	
	end
end # sign_in

def sign_out(user, options = {})
	if options[:no_capybara]
		cookies.delete :remember_token

	else
		visit root_path
		click_link "Sign Out"

	end
end # sign_out

