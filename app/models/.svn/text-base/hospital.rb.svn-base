class Hospital < ActiveRecord::Base
  
  validates_presence_of :name
  
  has_many :doctor_hospitals
  has_many :doctors, :through => :doctor_hospitals  
  
  
end
