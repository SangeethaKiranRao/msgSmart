ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'doctors', :action => 'create'
  map.signup '/signup', :controller => 'doctors', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'doctors', :action => 'activate', :activation_code => nil
  
  map.forgot '/forgot', :controller => 'doctors', :action => 'forgot'
  map.reset  'reset/:reset_code', :controller => 'doctors', :action => 'reset'
  map.secure '/secure_link/:encrypt_code', :controller => 'messages',:action => 'secure_email'  

  map.resources :doctors, :member => { :suspend => :put, :unsuspend => :put, :purge => :delete }, :collection => {:forgot => :get,:reset => :get}

  map.resource :session

  map.resources :profile, :collection => {:edit_basic_profile => :get,:professional_profile => :get,:update_professional_profile => :put,:update_basic_profile => :put,
                                          :create_speciality => :get, :auto_complete_for_speciality_name => :get, :delete_doctor_speciality => :delete,
                                          :create_hospitals => :get, :auto_complete_for_hospital_name => :get, :delete_doctor_hospital => :delete,
                                          :create_medical_groups => :get, :auto_complete_for_medical_group_name => :get, :delete_doctor_medical => :delete,:auto_complete_for_doctor_name => :get,
                                          :contact_info => :get,:update_contact_info_profile => :put,:insurance => :get,:personal_profile => :get,:update_personal_profile => :put }

  map.resources :home, :collection => {:reply_to_sender => :get,:inbox_messages => :get,:reply_to_all => :get,:compose_message => :get,:sent_messages => :get,:forward_message => :get,:delete_message => :get,:trash_messages => :get,
                                       :to_trash_message => :get,:to_inbox_message => :get,:remove_message => :post,:index => :get,:medical_staff_search => :get,:send_message_from_quick_contact => :get,:view_profile => :get,:view_full_profile => :get}
  

  map.resources :messages,:collection => {:check_pin_code => :get}

  map.resources :nurses do |nurses| 
    nurses.resources :radbox_messages, :collection => { :delete_selected => :post }
  end

  map.resources :pictures
  map.show_picture '/show_picture/:id', :controller => 'pictures', :action => 'edit'

  map.resource :sms

  map.secure_picture_message '/secure_picture_message/:picture_id', :controller => 'pictures', :action => 'secure_picture_message'

  map.view_message '/view_message/:mail_id', :controller => 'messages', :action => 'view_message'
  map.view_picture_message '/view_picture_message/:picture_id', :controller => 'pictures', :action => 'view_picture_message'


  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
   map.root :controller => "doctors",:action => "new"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
