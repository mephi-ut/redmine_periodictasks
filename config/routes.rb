Rails.application.routes.draw do
#  this is like "resources :periodictask" but it has been
#  replaced put with match for action 'update', allowing both http-verb options 'put' 
#  and the new verb 'patch' for compatibility with Redmine 3 and below
	resources :projects do
		resources :periodictasks, :path => 'periodictasks'
		resources :periodictask,  :path => 'periodictasks'
		#get      'periodictasks',            :to => 'periodictasks#index',  :as => 'periodictasks'
		#get      'periodictasks/new',        :to => 'periodictasks#new',    :as => 'new_periodictask'
		#post     'periodictasks',            :to => 'periodictasks#create'
		#get      'periodictasks/:id',        :to => 'periodictasks#show'#,   :as => 'periodictask'
		#get      'periodictasks/:id/edit',   :to => 'periodictasks#edit',   :as => 'edit_periodictask'
		#match    'periodictasks/:id',        :to => 'periodictasks#update', :via => [:put, :patch]
		#delete   'periodictasks/:id',        :to => 'periodictasks#destroy'
	end
end
