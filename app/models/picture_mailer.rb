class PictureMailer < ActionMailer::Base

  def picture_link(picture_id, sender, recipient_email)
    @from                = "info@msgSmart.com"
    @recipients          = "#{recipient_email}"
    @subject             = "msgSmart : Dr.#{sender.name} has sent a picture"
    @sent_on             = Time.now
    if sender.doctor_professional_profile && sender.doctor_professional_profile.use_secure_pin
      @body[:url]        = "http://msgSmart.com/secure_picture_message/#{picture_id}"
    else
      #@body[:url]        = "http://msgSmart.com/view_picture_message/#{picture_id}"

        # show the picture message directly
      @body[:url]        = "http://msgSmart.com/show_picture/#{picture_id}"
    end
    
    @body[:sender_name]  = "Dr. #{sender.name}"
  end

end