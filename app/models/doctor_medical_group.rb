class DoctorMedicalGroup < ActiveRecord::Base
  
  attr_accessible :doctor_id, :medical_group_id, :priority
  
  belongs_to :doctor
  belongs_to :medical_group  
end
