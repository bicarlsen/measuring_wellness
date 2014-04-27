MeasuringWellness::Application.routes.draw do
	# Resources
	resources :users
	resources :sessions, only: [ :new, :create, :destroy ]
	resources :orders
	resources :recommendations, except: [ :new ]	

	# Admin
	resources :coupons, only: [ :new, :create, :destroy ], path: '/admin/coupon'
	resources :analytes, path: '/admin/analyte'
	resources :analyte_groups, path: '/admin/analyte_group'
	resources :rules, path: '/admin/rule'
	resources :thresholds, path: '/admin/threshold'
	resources :results, path: '/admin/result'
	resources :tests, path: '/admin/test'
	
	# Rules Engine
	resources :flags, path: '/admin/flag'
	resources :recommendations, path: 'admin/recommendation'
	resources :evaluations, path: 'admin/evaluation', 
		except: [ :index ]
	resources :consultations, path: 'admin/consultation', 
		only: [ :edit, :update, :destroy ]

	# Root
 	root 'home_pages#index'	
 
	# Sign Up, Sign In, Sign Out
	match '/signup', 				to: 'users#new', 					via: 'get'
	match '/signup',				to: 'users#create',				via: 'post'
	match '/terms_of_use',	to: 'users#terms_of_use', via: 'get'
	match '/terms_of_use',	to: 'users#terms_of_use',	via: 'patch'
	match '/signin',				to: 'sessions#new', 			via: 'get'
	match '/signin', 				to: 'sessions#create', 		via: 'post'
	match '/signout',				to:	'sessions#destroy',		via: 'delete'

	# Home Pages
	match '/measures', 			to: 'home_pages#measures', 			via: 'get'
 	match '/homeostasis', 	to: 'home_pages#homeostasis', 	via: 'get'
 	match '/science', 			to: 'home_pages#science', 			via: 'get'

	# User Pages
	match '/users/:id/profile',	to: 'users#profile',	via: 'get', as: 'profile'
	
	# Admin Pages
	match '/admin', to: 'admin#home', via: 'get'
	match '/admin/orders', to: 'admin#orders', via: 'get'
	match '/admin/users', to: 'admin#users', via: 'get'
	match '/admin/test/:id/evaluate', to: 'tests#evaluate', via: 'post'

	# The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
