Rails.application.routes.draw do

  
  put 'solutions/:id' => 'solutions#set_grade'


  get 'journal/browse'
  post 'journal/set_interests'

  get 'courses/:course_id/assignments/:assignment_id/delete' => 'solutions#delete_solution'
  
  resources :contents
  resources :chapters
  get '/courses/mycourses' => 'courses#mycourses'
  get '/courses/studying' => 'courses#studying'
  get 'courses/:id/join' =>'courses#join_course'
  get 'courses/:id/joinrequest' =>'courses#join_request' 
  get 'courses/:id/requesters' => 'courses#join_requests'

  get 'courses/:id/requesters/accept/:requester_id' => 'courses#accept_request'
  get 'courses/:id/requesters/reject/:requester_id' => 'courses#reject_request'



  
  # get 'courses/:id/joinrequests' =>'courses#join_requests'
  
  resources :courses do
    resources :announcements
    resources :assignments do
      resources :solutions
  end
  end
  get 'home/index'

  get 'home/about'

  get 'home/contact'
  
  get 'teacher/home'

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  # delete "/logout" => "devise/sessions#destroy"

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
