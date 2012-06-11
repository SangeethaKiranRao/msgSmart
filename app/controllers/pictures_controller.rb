class PicturesController < ApplicationController

  layout "messages"

  def edit
    display_pic = Picture.find(params[:id])
    send_file "#{RAILS_ROOT}/app/pictures/#{display_pic.photo_file_name}", :type => display_pic.photo_file_content_type, :disposition => "inline"
  end

  def secure_picture_message
    @picture_id = params[:picture_id]
  end

  def validate_secret_pin
    
    pin1 = params[:doctor_professional_profile][:pin1]
    pin2 = params[:doctor_professional_profile][:pin2]
    pin3 = params[:doctor_professional_profile][:pin3]
    pin4 = params[:doctor_professional_profile][:pin4]
    picture_id = params[:picture][:id]

    if pin1.empty? && pin2.empty? && pin3.empty? && pin4.empty?
      flash[:notice] = "Please enter Pin Code"
      @picture_id = picture_id
      render :action => :secure_picture_message
    elsif pin1.empty? || pin2.empty? || pin3.empty? || pin4.empty?
      flash[:notice] = "Invalid Pin Code"
      @picture_id = picture_id
      render :action => :secure_picture_message
    else
     doctor = Doctor.find(Picture.find(picture_id).sender_id)
     if doctor.doctor_professional_profile
        pincode = pin1.chomp(' ') + pin2.chomp(' ') + pin3.chomp(' ') + pin4.chomp(' ')
        if doctor.doctor_professional_profile.secure_pin == pincode.to_i
           flash[:notice] = ""
#           @picture_url = "http://msgSmart.com/show_picture/#{picture_id}"
#           render :action => :view_picture_message, :picture_id => picture_id

              # show the picture directly without giving any link after validating secure pin
           redirect_to :action => :edit, :id => picture_id 
         else
           flash[:notice] = 'Invalid Pin Code'
           @picture_id = picture_id
           render :action => :secure_picture_message
        end
     else
       flash[:notice] = "Please register for your msgSmart Secure Pin inorder to view this message."
       redirect_to '/logout'
     end
    end
    
  end

end
