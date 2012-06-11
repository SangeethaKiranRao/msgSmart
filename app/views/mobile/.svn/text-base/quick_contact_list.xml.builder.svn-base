xml.instruct!

xml.doctors do
  @doctors.each do |doctor|
    xml.doctor do 
    xml.email(doctor.email)
    xml.id(doctor.id)
    xml.name(doctor.name)
    xml.doctor_personal_profile_id(doctor.doctor_personal_profile.id) if doctor.doctor_personal_profile
   xml.avatar_file_name(doctor.doctor_personal_profile.avatar_file_name) if doctor.doctor_personal_profile
      
    end
  end
end