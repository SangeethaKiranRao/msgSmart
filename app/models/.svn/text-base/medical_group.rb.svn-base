class MedicalGroup < ActiveRecord::Base
  
  validates_presence_of :name
  
  has_many :doctor_medical_groups
  has_many :doctors, :through => :doctor_medical_groups  
  
end
