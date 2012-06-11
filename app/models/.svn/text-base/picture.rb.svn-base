class Picture < ActiveRecord::Base

  include Clickatell

  belongs_to :doctor, :foreign_key => "sender_id"

  has_attached_file :photo, :path => ":rails_root/app/pictures/:filename", :dependent => :destroy
  
  validates_attachment_presence :photo
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"], :message => " must be an image file"
  validates_presence_of :sender_id, :recipient_id

  def self.send_picture_sms(picture_id, sender, recipient_mobile_number)
    sms_info = "Message from: Dr. #{sender.name}."
    if sender.doctor_professional_profile && sender.doctor_professional_profile.use_secure_pin
      sms_link = "http://msgSmart.com/secure_picture_message/#{picture_id}"
    else
      sms_link = "http://msgSmart.com/view_picture_message/#{picture_id}"
    end
    return Clickatell.make_http_request_for_sms(sms_info, sms_link, recipient_mobile_number)
  end
  
end
