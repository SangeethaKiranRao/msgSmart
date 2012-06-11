class HospitalContactShare < ActiveRecord::Base
  
  attr_accessible :doctor_id,:mobile,:pager,:office_number,:back_line_number,:assistant_number,:assistant_name,:work_email,:office_email,:personal_email
  belongs_to :doctor
end
