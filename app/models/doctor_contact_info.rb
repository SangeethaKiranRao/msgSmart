class DoctorContactInfo < ActiveRecord::Base
  include Authentication

#  removing the virtual attribute field
#  attr_accessor :contact_mobile_number

  attr_accessible :doctor_id, :mobile_number, :pager, :office_number, :back_line_number, :assistant_number, :work_email, :office_email, :personal_email
  
  validates_presence_of     :work_email, :mobile_number, :message => "must be present"
 
  validates_format_of       :office_number, :assistant_number, :back_line_number, :pager, :mobile_number, :with => /^(\(?\d\d\d\)?)?( |-|\.)?\d\d\d( |-|\.)?\d{4,4}(( |-|\.)?[ext\.]+ ?\d+)?$/, :allow_nil => true, :allow_blank => true
  
  validates_length_of       :work_email,    :within => 6..100 #r@a.wk
  validates_length_of       :office_email, :personal_email, :within => 6..100, :allow_nil => true, :allow_blank => true
  validates_uniqueness_of   :work_email, :mobile_number
  validates_uniqueness_of   :office_email, :personal_email, :allow_nil => true, :allow_blank => true
  validates_format_of       :work_email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  validates_format_of       :office_email, :personal_email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message, :allow_nil => true, :allow_blank => true
  
  belongs_to :doctor

end
