class MessagesController < ApplicationController
   layout "messages"
  include AuthenticatedSystem
  
#     def secure_email
#         if logged_in?
#           @mail = Mail.find_by_encrypt_code(params[:encrypt_code]) unless params[:encrypt_code].blank?
#           raise @mail.inspect
#         else
#           session[:return_to] = request.request_uri
#           redirect_to :controller => "doctors", :action => "new"
#         end
#     end
     
     def secure_email
         @mail = Mail.find_by_encrypt_code(params[:encrypt_code]) unless params[:encrypt_code].blank?
         flash[:notice] = ""
         render :action => "secure_email"
     end
     
     def check_pin_code
       @mail = Mail.find(params[:mail][:id])
       pin1 = params[:doctor_professional_profile][:pin1]
       pin2 = params[:doctor_professional_profile][:pin2]
       pin3 = params[:doctor_professional_profile][:pin3]
       pin4 = params[:doctor_professional_profile][:pin4]

       if pin1.empty? && pin2.empty? && pin3.empty? && pin4.empty?
          flash[:notice] = "Please enter Pin Code"
          render :action => :secure_email
       elsif pin1.empty? || pin2.empty? || pin3.empty? || pin4.empty?
          flash[:notice] = "Invalid Pin Code"
          render :action => :secure_email
       else
         doctor = Doctor.find(@mail.doctor_id)
         if doctor.doctor_professional_profile
            pincode = pin1.chomp(' ') + pin2.chomp(' ') + pin3.chomp(' ') + pin4.chomp(' ')
            if doctor.doctor_professional_profile.secure_pin == pincode.to_i
               flash[:notice] = ''
               render :action => :view_message, :mail_id => params[:mail][:id]
             else
               flash[:notice] = 'Invalid Pin Code'
               render :action => :secure_email
            end
         else
           flash[:notice] = "Please register for your msgSmart Secure Pin inorder to view this message."
           redirect_to '/logout'
         end
       end
     end

        # to view the message in email without entering the secure pin
     def view_message
       @mail = Mail.find(params[:mail_id])
       doctor = Doctor.find(@mail.doctor_id)
       if doctor.doctor_professional_profile.nil?
         flash[:notice] = "Please register for your msgSmart Secure Pin inorder to view this message."
         redirect_to '/logout'
       end
     end

end
