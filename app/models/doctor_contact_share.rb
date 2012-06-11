class DoctorContactShare < ActiveRecord::Base
  
  attr_accessible :doctor_id,:mobile,:pager,:office_number,:back_line_number,:assistant_number,:assistant_name,:work_email,:office_email,:personal_email
  
  belongs_to :doctor
   
  def self.set_default_values(contact_info)
      contact_info.mobile = false
      contact_info.pager = false
      contact_info.office_number = false
      contact_info.back_line_number = false
      contact_info.assistant_number = false
      contact_info.assistant_name = false
      contact_info.work_email = false
      contact_info.office_email = false
      contact_info.personal_email = false
      contact_info.save
  end
end
