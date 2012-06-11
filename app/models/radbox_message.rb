class RadboxMessage < ActiveRecord::Base

  is_private_message :sender_class_name => "Nurse", :receiver_class_name => "Doctor"
  
  # The :to accessor is used by the scaffolding,
  # uncomment it if using it or you can remove it if not
  attr_accessor :to
  
end