class Speciality < ActiveRecord::Base
  
  validates_presence_of :name
  
  has_many :doctor_specialities
  has_many :doctors, :through => :doctor_specialities

  SPECIALITY_HEADERS = ["Adult", "Pediatrics"]

  def self.speciality_dd_options(selected=nil)
    speciality_options = ""
    self.find(:all).each do |rec|
      if SPECIALITY_HEADERS.include?(rec.name)
        options_value = (rec.name == SPECIALITY_HEADERS[0]) ? "--------------#{rec.name}--------------" : "-----------#{rec.name}-----------"
        speciality_options += "<option value='#{rec.id}' class='disabled_dd_option' disabled>#{options_value}</option>"
      else
        option_selected = (rec.id == selected) ? "selected" : "" unless selected.nil?
        speciality_options += "<option value='#{rec.id}' class='enabled_dd_option' #{option_selected}>#{rec.name}</option>"
      end
    end
    speciality_options
  end
  
end
