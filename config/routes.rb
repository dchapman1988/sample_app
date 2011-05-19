SampleApp::Application.routes.draw do
  get "users/new"

  # Users' routes
  match '/signup',  :to => 'users#new'
  
  # Pages' routes
  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'

  # Web root's route
  root :to => 'pages#home'

end
