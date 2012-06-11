class ProfileController < ApplicationController
  
  auto_complete_for :speciality, :name
  auto_complete_for :hospital, :name
  auto_complete_for :medical_group, :name

  before_filter :fetch_profile_pic
  
  def index
      @doctor = Doctor.find(params[:doctor_id])
      @doctor_professional_profile = @doctor.doctor_professional_profile.nil? ? DoctorProfessionalProfile.new : @doctor.doctor_professional_profile
      @doctor_specialities = @doctor.specialities
      @doctor_medical_groups = @doctor.medical_groups
      @doctor_hospitals = @doctor.hospitals
  end
  
  def edit_basic_profile
    @doctor = Doctor.find(params[:doctor_id])
    render :partial => 'edit_basic_profile'
  end
   
  def update_basic_profile
    @doctor = Doctor.find(params[:doctor_id])
    change_contact_email = false
    if @doctor.email != params[:doctor][:email] && @doctor.doctor_contact_info  && @doctor.doctor_contact_info.work_email == @doctor.email
      change_contact_email = true
    end
    if @doctor.update_attributes(params[:doctor])
      if change_contact_email
        @doctor.doctor_contact_info.work_email = @doctor.email
        @doctor.doctor_contact_info.save
      end
      redirect_to :action => "index", :doctor_id => @doctor.id
    else
    @doctor_professional_profile = @doctor.doctor_professional_profile.nil? ? DoctorProfessionalProfile.new : @doctor.doctor_professional_profile
    @doctor_specialities = @doctor.specialities
    @doctor_medical_groups = @doctor.medical_groups
    @doctor_hospitals = @doctor.hospitals  
      render :action => "index"
    end
  end
  
  def create_professional_profile
      @doctor = Doctor.find(params[:doctor_id])
      @doctor_specialities = @doctor.specialities
      @doctor_medical_groups = @doctor.medical_groups
      @doctor_hospitals = @doctor.hospitals  
      @doctor_professional_profile = DoctorProfessionalProfile.new(params[:doctor_professional_profile])
      if @doctor_professional_profile.save
         redirect_to :action => "index", :doctor_id => @doctor.id
       else
         render :action => "index"
      end
  end
  
  def edit_professional_profile
      @doctor = Doctor.find(params[:doctor_id])
      @doctor_professional_profile = @doctor.doctor_professional_profile
      @doctor_specialities = @doctor.specialities
      @doctor_medical_groups = @doctor.medical_groups
      @doctor_hospitals = @doctor.hospitals   
      @edit = true
      @speciality_options = Speciality.speciality_dd_options
      @medical_groups = MedicalGroup.find(:all)
      render :partial => "new_professional_profile"
  end
  
  def update_professional_profile
    @doctor = Doctor.find(params[:doctor_id])
    @doctor_professional_profile = @doctor.doctor_professional_profile
    if @doctor_professional_profile.update_attributes(params[:doctor_professional_profile])
      redirect_to :action => "index", :doctor_id => @doctor.id
    else
      @edit = true
      @doctor_specialities = @doctor.specialities
      @doctor_medical_groups = @doctor.medical_groups
      @doctor_hospitals = @doctor.hospitals
      render :action => "index"
    end
  end
  
  #SORTING SPECIALITY
  def sort_speciality
    params[:speciality_sort].each_with_index do |id, index|
      doctor_speciality = DoctorSpeciality.find(:first, :conditions => ["speciality_id=? and doctor_id=?", id, current_doctor.id])
      doctor_speciality.update_attributes(:priority => index+1)
    end
    render :nothing => true
  end
  
#VIEW FOR CREATING NEW SPECIALITY
  def new_speciality
    @doctor = Doctor.find(params[:doctor_id])
    @speciality_options = Speciality.speciality_dd_options
    render :partial => "new_speciality"
  end
  
#CREATING NEW SPECIALITY
  def create_speciality
    @doctor = Doctor.find(params[:doctor_id])
    doctor_speciality = @doctor.speciality_ids
    if !doctor_speciality.include?(params[:speciality_id])
      @doctor_speciality = DoctorSpeciality.create(:doctor_id => @doctor.id, :speciality_id => params[:speciality_id], :priority => doctor_speciality.length.to_i+1)
    end
    redirect_to :action => "index", :doctor_id => @doctor.id
  end
  
#DELETING Doctor SPECIFIC SPECIALITY
  def delete_doctor_speciality
    @doctor = Doctor.find(params[:doctor_id])
    @doctor.doctor_specialities.find_by_speciality_id(params[:speciality_id]).delete
    redirect_to :action => "index", :doctor_id => @doctor.id
  end


#SORTING Medical Group
  def sort_medical
    params[:medical_sort].each_with_index do |id, index|
      doctor_medical = DoctorMedicalGroup.find(:first, :conditions => ["medical_group_id=? and doctor_id=?", id, current_doctor.id])
      doctor_medical.update_attributes(:priority => index+1)
    end
    render :nothing => true
  end
  
#VIEW FOR CREATING NEW Medical Group
  def new_medical_group
    @doctor = Doctor.find(params[:doctor_id])
    @medical_groups = MedicalGroup.find(:all)
    render :partial => "new_medical_group"
  end
  
#CREATING NEW Medical Group
  def create_medical_group
    @doctor = Doctor.find(params[:doctor_id])
    doctor_medical = @doctor.medical_group_ids
    if !doctor_medical.include?(params[:medical_group][:id])
      @doctor_medical_group = DoctorMedicalGroup.create(:doctor_id => @doctor.id, :medical_group_id => params[:medical_group][:id], :priority => doctor_medical.length.to_i+1)
    end
    redirect_to :action => "index", :doctor_id => @doctor.id
  end
  
#DELETING Doctor SPECIFIC Medical Group
  def delete_doctor_medical
    @doctor = Doctor.find(params[:doctor_id])
    @doctor.doctor_medical_groups.find_by_medical_group_id(params[:medical_group_id]).delete
    redirect_to :action => "index", :doctor_id => @doctor.id
  end



#SORTING HOSPITAL
  def sort_hospital
    params[:hospital_sort].each_with_index do |id, index|
      doctor_hospital = DoctorHospital.find(:first, :conditions => ["hospital_id=? and user_id=?", id, current_doctor.id])
      doctor_hospital.update_attributes(:priority => index+1)
    end
    render :nothing => true
  end
  
#VIEW FOR CREATING NEW HOSPITAL
  def new_hospital
    @doctor = Doctor.find(params[:doctor_id])
    render :partial => "new_hospital"
  end
  
#CREATING NEW HOSPITAL
  def create_hospital
    @doctor = Doctor.find(params[:doctor_id])
    hospital = Hospital.find(:first, :conditions => ["name like ?", "%#{params[:hospital][:name]}%"])
    hospital_doctor = @doctor.hospital_ids
    if hospital
      if !hospital_doctor.include?(hospital.id)
        @doctor_hospital = DoctorHospital.create(:doctor_id => @doctor.id, :hospital_id => hospital.id, :priority => hospital_doctor.length.to_i+1)
      end
    else
      @hospital = Hospital.create(:name => params[:hospital][:name])
      @doctor_hospital = DoctorHospital.create(:doctor_id => @doctor.id, :hospital_id => @hospital.id, :priority => hospital_doctor.length.to_i+1)
    end
    redirect_to :action => "index", :doctor_id => @doctor.id
  end
  
#DELETING USER SPECIFIC HOSPITAL
  def delete_doctor_hospital
    @doctor = Doctor.find(params[:doctor_id])
    @doctor.doctor_hospitals.find_by_hospital_id(params[:hospital_id]).delete
    redirect_to :action => "index", :doctor_id => @doctor.id
  end

  def contact_info
      @doctor = Doctor.find(params[:doctor_id])
      @doctor_contact_info = @doctor.doctor_contact_info.nil? ? DoctorContactInfo.new : @doctor.doctor_contact_info
      @doctor_contact_info.work_email ||= @doctor.email
  end

  def create_contact_info_profile
      @doctor = Doctor.find(params[:doctor_id])
      @doctor_contact_info = DoctorContactInfo.new(params[:doctor_contact_info])
      @doctor_contact_share = DoctorContactShare.new(params[:doctor_contact_share])
      @hospital_contact_share = HospitalContactShare.new(params[:hospital_contact_share])
      @public_contact_share = PublicContactShare.new(params[:public_contact_share])
      if @doctor_contact_info.save
          @doctor_contact_share.save
          @hospital_contact_share.save
          @public_contact_share.save
         redirect_to :action => "contact_info",:doctor_id => @doctor.id
       else
         render :action => "contact_info"
      end
  end
  
  def edit_contact_info_profile
      @doctor = Doctor.find(params[:doctor_id])
      @doctor_contact_info = @doctor.doctor_contact_info
      @doctor_contact_share = @doctor.doctor_contact_share
      @hospital_contact_share = @doctor.hospital_contact_share
      @public_contact_share = @doctor.public_contact_share
      render :partial => "edit_contact_info"
  end
  
  def update_contact_info_profile
      @doctor = Doctor.find(params[:doctor_id])
      @doctor_contact_info = @doctor.doctor_contact_info
       doctor_share = DoctorContactShare.set_default_values(@doctor.doctor_contact_share) 
       doctor_contact_share =  @doctor.doctor_contact_share.update_attributes(params[:doctor_contact_share])
       hospital_share = DoctorContactShare.set_default_values(@doctor.hospital_contact_share)
      hospital_contact_share = @doctor.hospital_contact_share.update_attributes(params[:hospital_contact_share])
      public_share = DoctorContactShare.set_default_values(@doctor.public_contact_share) 
      public_contact_share = @doctor.public_contact_share.update_attributes(params[:public_contact_share])
      @doctor_contact_share = @doctor.doctor_contact_share
      @hospital_contact_share = @doctor.hospital_contact_share
      @public_contact_share = @doctor.public_contact_share
      if @doctor_contact_info.update_attributes(params[:doctor_contact_info])
         redirect_to :action => "contact_info", :doctor_id => @doctor.id
       else
         render :partial => "edit_contact_info",:layout => "application"
      end
  end
  
  def insurance
      @doctor = Doctor.find(params[:doctor_id])
  end
  
  def personal_profile
      @doctor = Doctor.find(params[:doctor_id])
      @doctor_personal_profile = @doctor.doctor_personal_profile.nil? ? DoctorPersonalProfile.new : @doctor.doctor_personal_profile
  end
  
  def create_personal_profile
      @doctor = Doctor.find(params[:doctor_id])
      @doctor_personal_profile = DoctorPersonalProfile.new(params[:doctor_personal_profile])
      if @doctor_personal_profile.save
         redirect_to :action => "personal_profile", :doctor_id => @doctor.id
     else
       render :partial => "new_personal_profile",:layout => "application"
     end  
  end

  def edit_personal_profile
      @doctor = Doctor.find(params[:doctor_id])
      @doctor_personal_profile = @doctor.doctor_personal_profile
      @edit = true  
      render :partial => "new_personal_profile" 
  end

      def update_personal_profile
      @doctor = Doctor.find(params[:doctor_id])
      @doctor_personal_profile = @doctor.doctor_personal_profile
      if @doctor_personal_profile.update_attributes(params[:doctor_personal_profile])
         redirect_to :action => "personal_profile",:doctor_id => @doctor.id
       else
         @edit = true
         render :partial => "new_personal_profile", :layout => "application"
      end
  end

private

def fetch_profile_pic
  @doctor = Doctor.find(params[:doctor_id])
  unless @doctor.doctor_personal_profile.nil?
    pic_file_name = @doctor.doctor_personal_profile.avatar_file_name
    @doc_profile_pic = "/system/avatars/#{@doctor.doctor_personal_profile.id}/medium/#{pic_file_name}" if pic_file_name
  end
  @doc_profile_pic ||= "/images/profilepic.jpg"
end

end
