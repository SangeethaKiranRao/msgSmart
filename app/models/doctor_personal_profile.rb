class DoctorPersonalProfile < ActiveRecord::Base
  
  attr_accessible :doctor_id,:interests,:languages,:avatar
  validates_presence_of :interests,:languages,:message => "must be present"
  
  has_attached_file :avatar,  :default_url => '/images/foto.jpg',
                              :default_style => :small,
                              :path => ':rails_root/public/system/:attachment/:id/:style/:filename',
                              :styles => {:medium => "150x150#", :small => "50x50#", :thumb => "35x35#"}, :dependent => :destroy
  
#  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"], :message => " must be an image file"
   validates_format_of       :interests,:languages, :with => /^[a-zA-Z*,\s]*$/, :message => "is invalid"  

  belongs_to :doctor
end