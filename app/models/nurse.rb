class Nurse < ActiveRecord::Base
  has_private_messages :class_name => 'RadboxMessage', :sender => true
end
