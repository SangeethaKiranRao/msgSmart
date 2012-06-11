class DoctorMailer < ActionMailer::Base
  def signup_notification(doctor)
    setup_email(doctor)
    @subject      += 'Please activate your new account'
    @body[:url]    = "http://msgSmart.com/activate/#{doctor.activation_code}"
    @body[:mailid] = "support@msgSmart.com"
  
  end
  
  def activation(doctor)
    setup_email(doctor)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://msgSmart.com/"
  end
  
  def mobile_verify_code(doctor)
      setup_email(doctor)
      @subject += 'Please verify your new account'
      @body['text'] = doctor.verify_code_mobile
  end
  
  #FOR SENDING RESET PASSWORD ACTIVATION MAIL
  def reset_notification(doctor)
    setup_email(doctor)
    @subject    += 'Link to reset your password'
    @body[:url]  = "http://msgSmart.com/reset/#{doctor.reset_code}"
  end
  
  def send_secure_link(doctor,mail)
      setup_email(doctor)
      mailid = doctor.doctor_contact_info.nil? ? doctor.email : doctor.doctor_contact_info.work_email
      @recipients = mailid
      @subject += 'You have one new message'
      @body[:name] = mail.message.sender.name
      if doctor.doctor_professional_profile && doctor.doctor_professional_profile.use_secure_pin
        @body[:url] = "http://msgSmart.com/secure_link/#{mail.encrypt_code}"
      else
        @body[:url] = "http://msgSmart.com/view_message/#{mail.id}"
      end
      
  end
  
  protected
    def setup_email(doctor)
      @recipients  = "#{doctor.email}"
      @from        = "info@msgSmart.com"
      @subject     = "msgSmart : "
      @sent_on     = Time.now
      @body[:doctor] = doctor
    end
end