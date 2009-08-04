ActionController::Routing::Routes.draw do |map|

  map.resources :contents
  map.resources :categories
  map.resources :topics
  map.resources :curriculum_contents

 
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
