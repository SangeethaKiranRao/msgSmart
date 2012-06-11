class MobileController < ApplicationController

  protect_from_forgery :except => :send_picture_link
  
   def login
    logout_keeping_session!
    doctor = Doctor.authenticate(params[:email], params[:password])
    if doctor
      self.current_doctor = doctor
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      @doctor = doctor
      #user_details = @user.to_xml(:skip_types => true, :only => [:id,:name,:email,:state], :include => {:awards => {:only => [:id,:name]}, :hospitals => {:only => [:id,:name]}, :specialities => {:only => [:id,:name]}, :user_personal_profile => {:only => [:id,:first_name,:middle_name,:last_name,:gender,:birthdate,:address,:city,:state,:country,:zip_code,:contact1,:contact2,:avatar_file_name]}})
      respond_to do |format|
       # format.xml  { render :xml => user_details, :status => 200 }
         format.xml { render :xml => {:message => "Login Sucessfull",:user_id => @doctor.id},:status => 400}
      end
    else
      note_failed_signin
      @email       = params[:email]
      @remember_me = params[:remember_me]
      respond_to do |format|
        format.xml  { render :status => 400, :xml => {:message => "Login Failure"} }
      end
    end
  end
 
 
 def signup
    logout_keeping_session!
    @doctor = Doctor.new(params[:doctor])
    @doctor.mobile_register = 'yes'
    @doctor.verify_code_mobile = Doctor.random_string(6)
    @doctor.register! if @doctor && @doctor.valid?
    success = @doctor && @doctor.valid?
    if success && @doctor.errors.empty?
      @doctor.reload
      DoctorMailer.deliver_mobile_verify_code(@doctor)
      respond_to do |format|
        format.xml  { render :status => 200, :xml => {:message => "success"} }
      end
    else
      respond_to do |format|
        format.xml  { render :status => 400, :xml => {:message => "Failure"} }
      end
    end
  end
  
  def confirm_code
      logout_keeping_session!
      doctor = Doctor.find_by_verify_code_mobile(params[:code]) unless params[:code].blank?
      if doctor 
        doctor.activate!
        DoctorMailer.deliver_activation(doctor) if  doctor.recently_activated?
         respond_to do |format|
        format.xml  { render :status => 200, :xml => {:message => "logged in successfull"} }
      end
    else
      respond_to do |format|
        format.xml  { render :status => 400, :xml => {:message => "please enter correct confirm code"} }
      end
      end
  end
  
  def doctor_contact_info
      get_doctor
      @doctor_contact_info = @doctor.doctor_contact_info
      if @doctor_contact_info
          respond_to do |format|
          format.xml  { render :status => 200, :xml => @doctor_contact_info }
          end
        else
          respond_to do |format|
        format.xml  { render :status => 400, :xml => {:message => "Contact Info Profile not yet created"} }
      end
      end
  end

  def doctor_contact_share
      get_doctor
      @doctor_contact_share = @doctor.doctor_contact_share
      if @doctor_contact_share
          respond_to do |format|
          format.xml  { render :status => 200, :xml => @doctor_contact_share }
          end
      else
         respond_to do |format|
         format.xml  { render :status => 400, :xml => {:message => "Contact Share not yet created"} }
         end
      end
  end
  
  def hospital_contact_share
      get_doctor
      @hospital_contact_share = @doctor.hospital_contact_share
      if @hospital_contact_share
          respond_to do |format|
          format.xml  { render :status => 200, :xml => @hospital_contact_share }
          end
      else
         respond_to do |format|
         format.xml  { render :status => 400, :xml => {:message => "Contact Share not yet created"} }
         end
      end
  end
  
  def public_contact_share
      get_doctor
      @public_contact_share = @doctor.public_contact_share
      if @public_contact_share
          respond_to do |format|
          format.xml  { render :status => 200, :xml => @public_contact_share }
          end
      else
         respond_to do |format|
         format.xml  { render :status => 400, :xml => {:message => "Contact Share not yet created"} }
         end
      end
  end
  
  def professional_profile
      get_doctor
      @doctor_professional_profile = @doctor.doctor_professional_profile
      if @doctor_professional_profile
         doctor_details = @doctor.to_xml(:skip_types => true, :only => [:id,:name,:email],:include => {:doctor_professional_profile => {:only => [:id,:first_name,:middle_name,:last_name,:office_address,:state,:zip_code,:assistant_name,:degree,:sub_speciality]},:doctor_personal_profile => {:only => [:id,:avatar_file_name,:avatar_content_type]}})   
         respond_to do |format|
          format.xml  { render :status => 200, :xml => doctor_details }
          end
      else
        respond_to do |format|
         format.xml  { render :status => 400, :xml => {:message => "Profile not yet created"} }
         end
      end
  end
   
   def count_read_messages
      get_doctor
      count = @doctor.mailbox[:inbox].mail_count(:read)
      respond_to do |format|
         format.xml  { render :status => 200, :xml => {:count => "#{count}"} }
      end
  end

  def count_unread_messages
      get_doctor
      if params[:from].nil? || params[:to].nil?
        count = @doctor.mailbox[:inbox].mail_count(:unread)
      else
        params[:from] = params[:from].to_s.gsub(/_/, ' ')
        params[:to] = params[:to].to_s.gsub(/_/, ' ')
        #count = @doctor.mailbox[:inbox].mail_count(:unread, :conditions => "created_at >= '#{params[:from]}' and created_at <= '#{params[:to]}'")
        count = Mail.count(:conditions => ["doctor_id = ? and mailbox = ? and created_at between ? and ?", @doctor.id, "inbox", params[:from], params[:to]])
      end
      respond_to do |format|
         format.xml  { render :status => 200, :xml => {:count => "#{count}"} }
      end
  end

  def inbox_messages
      get_doctor
      if params[:from].nil? || params[:to].nil?
        @mailbox = @doctor.mailbox[:inbox].mail
      else
        params[:from] = params[:from].to_s.gsub(/_/, ' ')
        params[:to] = params[:to].to_s.gsub(/_/, ' ')
        #@mailbox = @doctor.mailbox[:inbox].mail(:conditions => "created_at >= '#{params[:from]}' and created_at <= '#{params[:to]}'")
        @mailbox = Mail.find(:all, :conditions => ["doctor_id = ? and mailbox = ? and created_at between ? and ?", @doctor.id, "inbox", params[:from], params[:to]])
      end
      respond_to do |format|
        format.xml  { @mailbox }
      end
  end

  def sent_messages
      get_doctor
      @mailbox = @doctor.mailbox[:sentbox].mail
      respond_to do |format|
        format.xml  { @mailbox }
      end
  end

  def compose_message
    
      sender = Doctor.find(params[:sender_id])
      recipients = Doctor.find_all_by_email(params[:recipient_email])
      
      unless recipients.empty?
        m = sender.send_message(recipients,params[:body],params[:subject])
        msg = Mail.find(:first,:conditions => ['message_id in (?) and doctor_id in (?)',m.message_id,sender.id])
        msg.update_attribute(:encrypt_code, Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join )) if msg
        msg.save if msg

        sms_status = ""

        recipients.each do |doc|
          mail = Mail.find(:first,:conditions => ['message_id in (?) and doctor_id in (?)',m.message_id,doc.id])
          mail.update_attribute(:encrypt_code, Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join )) if mail
          mail.save if mail
          recipient_mobile_number = doc.doctor_contact_info.nil? ? "" : doc.doctor_contact_info.mobile_number
          recipient_mobile_number ||= ""

          if params[:copy_sms] == "true"
            unless recipient_mobile_number.empty?
              clickatell_response = Message.send_secure_text(mail, sender, doc, recipient_mobile_number)
              if clickatell_response.body.to_s.slice('ERR')
                sms_status += "Message could not be sent to Dr.#{doc.name}. Internal error. \n"
              end
            else
              sms_status += "Message could not be sent to Dr.#{doc.name}. Mobile number not yet registered. \n"
            end
          end
          if params[:copy_email] == "true"
            DoctorMailer.deliver_send_secure_link(doc,mail)
          end
        end

        respond_to do |format|
          status_code = 200
          status_message = "Message sucessfully sent"
          if params[:copy_sms] && !sms_status.empty?
            status_code = 400
            status_message = sms_status
          end
          format.xml { render :status => status_code, :xml => {:message => status_message}}
        end
      else
        respond_to do |format|
          format.xml { render :status => 200, :xml => {:message => "Please enter correct recipient email id "}}
        end
    end
 
  end

  def mark_as_read_msg
      mail = Mail.find(params[:mail_id])
      if mail
         mail.mark_as_read()
         respond_to do |format|
           format.xml { render :status => 200, :xml => {:message => "Message marked as read"}}   
         end
     else
         respond_to do |format|
           format.xml { render :status => 400, :xml => {:message => "Message not found"}}   
         end
      end
  end

   def mark_as_unread_msg
      mail = Mail.find(params[:mail_id])
      if mail
         mail.mark_as_unread()
         respond_to do |format|
           format.xml { render :status => 200, :xml => {:message => "Message marked as unread"}}   
         end
     else
         respond_to do |format|
           format.xml { render :status => 400, :xml => {:message => "Message not found"}}   
         end
      end
  end

  def delete_msg
      mail = Mail.find(params[:mail_id])
      if mail
         mail.delete()
         respond_to do |format|
           format.xml { render :status => 200, :xml => {:message => "Message deleted"}}   
       end
     else
         respond_to do |format|
           format.xml { render :status => 400, :xml => {:message => "Message not found"}}   
         end
      end
  end

  def doctor_emails
      emails = Doctor.find(:all,:select => 'email')
      if emails
         respond_to do |format|
           format.xml {render :status => 200, :xml => emails}
       end
     else
         respond_to do |format|
           format.xml { render :status => 400, :xml => {:message => "Doctor list empty"}}   
         end
      end
  end

  def add_to_chat
      get_doctor
      mail = Mail.find(params[:mail_id])
      if @doctor && mail
         reply_mail = @doctor.reply_to_sender(mail,params[:body])
        # @read_conversation = @doctor.read_conversation(mail.conversation_id)
         @read_conversation = Mail.find(:all,:conditions => ['doctor_id in (?) and conversation_id in (?)', @doctor.id,mail.conversation_id])
        # read_messages = @read_conversation.to_xml(:skip_types => true, :only => [:id,:doctor_id,:conversation_id,:read,:trashed,:mailbox,:created_at],:include => {:message => {:only => [:id,:body,:subject,:sender_id,:conversation_id,:sent]}})
          respond_to do |format|
           format.xml { render :xml => @read_conversation}
         end
      else
         respond_to do |format|
           format.xml { render :status => 400, :xml => {:message => "Please send correct Doctor or Mail information"}}   
         end
      end
  end

  def delete_thread_messages
      get_doctor
      mail = Mail.find(:all,:conditions => ['doctor_id in (?) and conversation_id in (?)', @doctor.id,params[:conversation_id]])
      unless mail.empty?
        mail.each do |m|
          m.delete()
        end
        respond_to do |format|
          format.xml { render :xml => {:message => "Deleted Messages in thread"}}
        end
      else
         respond_to do |format|
           format.xml { render :status => 400, :xml => {:message => "Could not find Message."}}   
         end
      end
  end

  def add_to_quick_contact
      get_doctor
      if @doctor
        if  @doctor.quick_contacts.map(&:contact_id).include?(params[:contact_id].to_i)
          else
         contact = @doctor.quick_contacts.build(:contact_id => params[:contact_id])
         contact.save
       end
        respond_to do |format|
          format.xml { render :xml => {:message => "Sucessfully added to contact list"}}
        end
      else
        respond_to do |format|
          format.xml { render :xml => {:message => "Could not find Doctor"}}
        end
      end
  end

  def quick_contact_list
      get_doctor
      contact_list = @doctor.quick_contacts.map(&:contact_id)
      if contact_list.empty?
         respond_to do |format|
          format.xml { render :xml => {:message => "Contact list empty"}}
        end
      else
       @doctors = Doctor.find(contact_list)
       # contact_list = doctor.to_xml(:skip_types => true, :only => [:id,:email],:include => {:doctor_professional_profile => {:only => [:id,:first_name,:middle_name,:last_name,:assistant_name,:degree,:sub_speciality]},:doctor_personal_profile => {:only => [:id,:avatar_file_name,:avatar_content_type]}})
        respond_to do |format|
          format.xml {@doctors}
        end
      end
  end

  def message_conversation
      if (!params[:doctor_id].blank? && !params[:conversation_id].blank? )
      @message_conversation = Mail.find(:all,:conditions => ['doctor_id in (?) and conversation_id in (?)',params[:doctor_id],params[:conversation_id]])
       respond_to do |format|
           format.xml  { @message_conversation }
       end
       
     else
      respond_to do |format|
          format.xml { render :xml => {:message => "Doctor id or conversation id is missing"}}
        end
     end
 end  


  def doctor_names
      @doctors = Doctor.find(:all,:select => 'id,email,name')
      if @doctors
         respond_to do |format|
           format.xml { @doctors}
       end
     else
         respond_to do |format|
           format.xml { render :status => 400, :xml => {:message => "Doctor list empty"}}   
         end
      end
  end

  def adult_speciality_list
    @adult_list = ["Allergy and Immunology","Anesthesiology","Cardiology","Interventional Cardilogy","Dermatology","Emergency Medicine","Endocrinology","ENT","Family Practice","Gastroenterology","Geriatrics","Infectious Disease","Internal Medicine","Nephrology","Neuro Surgery","Neurology","OB and Gyne","Oncology","Ophthalmology",
                   "Orthopedics","Pathology","Pediatrics","Physical Medicine","Plastic Surgery","Preventive Medicine","Psychiatry","Pulmonary Critical Care Medicine","Radiology","Interventional Radiology","Spine Surgery","General Surgery","Vascular Surgery","Urology"]
    doctors =  Doctor.find(:first)
   #@adult_list = {"adult" => [["Allergy and Immunology","Anesthesiology","Cardiology","Interventional Cardilogy","Dermatology"]]}
    respond_to do |format|
           format.xml { doctors}
       end
  end

  def pediatrics_speciality_list
    @pedialtrics_list = ["Pediatric Allergy","Pediatric Anesthesiology","Pediatric Cardiology","Pediatric Cardiothoracic Surgery","Pediatric Critical Care Medicine","Pediatric Emergency Medicine","Pediatric Emergency Medicine-Pediatrics","Pediatric Endocrinology","Pediatric Gastroenterology","Pediatric Hematology-Oncology","Pediatric Infectious Diseases","Pediatric Nephrology","Pediatric Neurological Surgery","Pediatric Ophthalmology","Pediatric Otolaryngology","Pediatric Pathology","Pediatric Pulmonology","Pediatric Radiology","Pediatric Rehabilitation Medicine",
                   "Pediatric Rheumatology","Pediatric Surgery","Pediatric Urology","Pediatrics Orthopedics"]
    doctors =  Doctor.find(:first)
   #@adult_list = {"adult" => [["Allergy and Immunology","Anesthesiology","Cardiology","Interventional Cardilogy","Dermatology"]]}
    respond_to do |format|
           format.xml { doctors}
       end
  end

   def medical_groups
    medical_groups = MedicalGroup.find(:all,:select => 'id,name')
    if medical_groups
       respond_to do |format|
           format.xml {render :status => 200, :xml => medical_groups}
       end
     else
        respond_to do |format|
           format.xml { render :status => 400, :xml => {:message => "Medical Group list empty"}}   
         end
    end
  end

   def doctor_medical_group
    medical_group = MedicalGroup.find(params[:id])
    if medical_group
       ids = medical_group.doctors.map(&:id)
       @doctors = Doctor.find(ids,:select => 'id,name,email')
       respond_to do |format|
           format.xml { @doctors}
       end
     else
        respond_to do |format|
           format.xml { render :status => 400, :xml => {:message => "No Doctor in this Medical Group"}}   
         end
    end
  end

  def fetch_radbox_messages
    get_doctor
    # hardcoding the recipient for demo purpose
    @doctor = Doctor.find(1)
    @radbox_messages = @doctor.received_messages
      respond_to do |format|
         if @radbox_messages.empty?
         format.xml  { render :status => 200, :xml => {:message => "No Messages in inbox"} }
       else
         format.xml  { @radbox_messages }
         end
      end
  end

  def send_picture_link
    
    respond_to do |format|

      if request.post?

        sender = Doctor.find_by_id(params[:sender_id])
        #sender_mail_id = sender.doctor_contact_info.nil? ? sender.email : sender.doctor_contact_info.work_email

        if params[:use_mobile] && params[:recipient_mobile_number].nil?
          format.xml { render :status => 400, :xml => {:message => "Recipient's mobile number not found"}}
        end

        unless params[:use_mobile]
          recipient = Doctor.find_by_id(params[:recipient_id])
          format.xml { render :status => 400, :xml => {:message => "Recipient not yet registered"}} \
            if recipient.nil?
        end
        
        format.xml { render :status => 400, :xml => {:message => "Image file not found"}} \
          if params[:photo].blank?

        unless recipient.nil?
          recipient_mail_id = recipient.doctor_contact_info.nil? ? recipient.email : recipient.doctor_contact_info.work_email
          recipient_mobile_number = recipient.doctor_contact_info.nil? ? "" : recipient.doctor_contact_info.mobile_number
        end
        recipient_mobile_number = params[:recipient_mobile_number] if params[:use_mobile]
        recipient_mobile_number ||= ""

        image_file_name = params[:photo_file_name].to_s

        File.open(image_file_name,"wb") do |file|
          file.write(params[:photo].read)
        end

        f = File.open(image_file_name)

        sent_picture = Picture.new
        sent_picture.recipient_id = params[:recipient_id]
        sent_picture.sender_id = params[:sender_id]
        sent_picture.photo = f
        sent_picture.photo_file_content_type = "image/" + image_file_name.split('.').last

        if sent_picture.save

          if params[:copy_sms] == "true" || params[:use_mobile] == "true"
            unless recipient_mobile_number.empty?
              unless send_picture_link_to_phone(sent_picture.id, sender, recipient_mobile_number)
                format.xml { render :status => 400, :xml => {:message => "Picture could not be sent to the doctor!"}}
              end
            else
              format.xml { render :status => 400, :xml => {:message => "Picture could not be sent to Dr.#{recipient.name}. Mobile number not yet registered. \n"}}
            end
          end
          send_picture_link_to_email(sent_picture.id, sender, recipient_mail_id) if params[:copy_email] == "true"
          format.xml { render :status => 200, :xml => {:message => "Picture sent to the doctor successfully"}}
        else
          format.xml { render :status => 400, :xml => {:message => "Picture could not be sent to the doctor!"}}
        end

        File.delete(image_file_name)
      else
        format.xml { render :status => 400, :xml => {:message => "Invalid Request"}}
      end
    end

  end

  def delete_duplicate_message
    @mail = Mail.find(params[:mail_id])
    if @mail && @mail.destroy
      format.xml { render :status => 200, :xml => {:message => "Duplicate message deleted successfully"} }
    else
      format.xml { render :status => 400, :xml => {:message => "Duplicate message could not be deleted"} }
    end
  end

  private
  
  def get_doctor
    @doctor = Doctor.find(params[:doctor_id])
  end

  def send_picture_link_to_email(picture_id, sender, recipient)
    PictureMailer.deliver_picture_link(picture_id, sender, recipient)
  end

  def send_picture_link_to_phone(picture_id, sender, recipient_mobile_number)
    clickatell_response = Picture.send_picture_sms(picture_id, sender, recipient_mobile_number)
    return clickatell_response.body.to_s.slice('ERR') ? false : true
  end

end
