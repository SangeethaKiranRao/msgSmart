class DoctorSpeciality < ActiveRecord::Base
  
  attr_accessible :doctor_id, :speciality_id, :priority
  
  belongs_to :doctor
  belongs_to :speciality  
end
