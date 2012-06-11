class DoctorProfessionalProfile < ActiveRecord::Base
  
  attr_accessible :doctor_id,:first_name,:last_name,:middle_name,:office_address,:state,:zip_code,:assistant_name,:assistant_email,:web_url,:medical_school,:graduation_year,:degree,:sub_speciality, :secure_pin, :use_secure_pin
  
  ZIP_CODE_LENGTH = 5
  PIN_CODE_LENGTH = 4
  
  validates_presence_of :first_name, :last_name, :sub_speciality, :office_address, :state, :zip_code, :degree, :secure_pin, :message => "must be present"
  validates_format_of :zip_code, :with => /(^$|^[0-9]{#{ZIP_CODE_LENGTH}}$)/, :message => "must be a five digit number"
  validates_format_of :secure_pin, :with => /(^$|^[0-9]{#{PIN_CODE_LENGTH}}$)/, :message => "must be a four digit number"
  validates_format_of :first_name,:last_name, :with => /^[a-zA-Z*.\s]*$/, :message => "Enter in proper format"
  validates_format_of :state,:with => /^[a-zA-Z\s]*$/, :message => "Enter in proper format"

  validates_format_of :middle_name,:assistant_name, :with => /^[a-zA-Z*.\s]*$/, :allow_nil => true, :allow_blank => true, :message => "Enter in proper format"
  validates_numericality_of :graduation_year, :allow_nil => true, :allow_blank => true
  validates_length_of :graduation_year, :is => 4, :allow_nil => true, :allow_blank => true
  validates_format_of :web_url, :with => /^((http|https):\/\/)*[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :message => "is invalid", :allow_nil => true, :allow_blank => true
  
  DEGREE = [
  ["MD","MD"],
  ["DO","DO"],
  ["DMD","DMD"],
  ["DDS","DDS"]
  ]
  
  belongs_to :doctor
  
end