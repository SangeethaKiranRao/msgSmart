class HomeController < ApplicationController
      layout "application"
  def index
      @doctor = Doctor.find(params[:doctor_id])
      @doctor_list = []
      @doctor.quick_contacts.each{|qc| @doctor_list << Doctor.find(qc.contact_id) }
      @doctor_list
      #@doctor_list = Doctor.find(:all, :conditions => ["id != ?", params[:doctor_id]], :limit => 10) if @doctor_list.empty?
  end
  
  def compose_message
      flash[:notice] = ""
      @doctor = Doctor.find(params[:doctor_id])
  end
  
  def send_message_from_quick_contact
    @doctor = current_doctor
    @send_doctor = Doctor.find(params[:id])
    render :action => "compose_message"
  end

  def view_profile
    @view_doctor = Doctor.find(params[:doc_id])
  end

  def view_full_profile
      @view_doctor = Doctor.find(params[:doc_id])
  end

  def professional_profile
    @view_doctor = Doctor.find(params[:doc_id])
    render :partial => 'professional_profile'
  end
 
 def contact_profile
   @view_doctor = Doctor.find(params[:doc_id])
   render :partial => 'contact_profile'
 end

 def insurance_profile
   @view_doctor = Doctor.find(params[:doc_id])
   render :partial => 'insurance_profile'
 end
 
 def personal_profile
   @view_doctor = Doctor.find(params[:doc_id])
   render :partial => 'personal_profile'
 end


 def create
   @doctor = current_doctor
   sms_status = ""
   flash[:notice]  = ""
   flash[:notice] += "Please enter the To address.\n" if params[:message].blank?
   flash[:notice] += "Please enter the Subject.\n" if params[:mail][:subject].empty?
   flash[:notice] += "Please enter the Message body.\n" if params[:mail][:body].empty?
   unless flash[:notice].empty?
      @subject = params[:mail][:subject]
      @body = params[:mail][:body]
      render :action => "compose_message"
   else
    rec_doctors = Doctor.find_all_by_email(params[:message][:to])
    sent_mail_message_id = current_doctor.send_message(rec_doctors,params[:mail][:subject],params[:mail][:body]).message_id
    sms_status = handle_messaging(params, @doctor, sent_mail_message_id, rec_doctors)
    flash[:notice] = sms_status
    redirect_to :action => "inbox_messages"
   end
 end  
  
  def inbox_messages
    if !current_doctor.mailbox[:inbox].mail.empty?
    @inbox_messages = current_doctor.mailbox[:inbox].mail.paginate(:page => params[:page], :per_page => 14)
    else
    @inbox_messages = ""
    end
  end
  
  def message_details
    @inbox = true if params[:inbox]
    @mail = Mail.find(params[:id])
    @mail.read = true
    @mail.save
  end
  
  def sent_messages
     if !current_doctor.mailbox[:sentbox].mail.empty? 
    @sent_messages = current_doctor.mailbox[:sentbox].mail.paginate(:page => params[:page], :per_page => 14)
     else
     @sent_messages = ""
     end
  end
  
  def trash_messages
      if !current_doctor.mailbox[:trash].mail.empty? 
    @trash_messages = current_doctor.mailbox[:trash].mail.paginate(:page => params[:page], :per_page => 14)
      else
      @trash_messages = ""
      end
  end
  
  def reply_to_sender
    @mail = Mail.find(params[:mail_id])
    if recipient_logged_in?(@mail.doctor_id)
      @message = @mail.message
      @sender = true
    else
      #session[:return_to] = request.request_uri
      session[:return_to] = "/home/message_details/#{params[:mail_id]}?inbox=true"
      redirect_to :controller => "doctors", :action => "new"
    end  
  end
  
  def reply_to_message
    mail = Mail.find(params[:id])
    reply_mail = current_doctor.reply_to_sender(mail,params[:message][:body],params[:message][:subject])
    sms_status = handle_messaging(params, current_doctor, reply_mail.message_id)
    flash[:notice] = sms_status
    redirect_to :action => "inbox_messages"
  end
  
  def reply_to_all
    @mail = Mail.find(params[:mail_id])
    @message = @mail.message
    @recipients = @message.recipients.map(&:email) - [current_doctor.email] + [@message.sender.email]
    @all = true
    render :action => "reply_to_sender"
  end
  
  def reply_to_all_message
    mail = Mail.find(params[:id])
    reply_all_mail = current_doctor.reply_to_all(mail,params[:message][:body],params[:message][:subject])
    sms_status = handle_messaging(params, current_doctor, reply_all_mail.message_id)
    flash[:notice] = sms_status
    redirect_to :action => "inbox_messages"
  end
  
  def forward_message
    @mail = Mail.find(params[:mail_id])
    @message = @mail.message
    flash[:notice] = ""
  end
  
  def forward_send_message
    @message = Message.find(params[:id])
    if params[:message][:to].blank?
        flash[:notice] = "Please enter To address"
        render :action => "forward_message"
    else
      rec_doctors = Doctor.find_all_by_email(params[:message][:to])
      forward_mail = current_doctor.send_message(rec_doctors,params[:message][:body],params[:message][:subject])
      sms_status = handle_messaging(params, current_doctor, forward_mail.message_id, rec_doctors)
      flash[:notice] = sms_status
      redirect_to :action => "inbox_messages"
    end
  end
  
  def to_trash_message
    mail = Mail.find(params[:mail_id])
    mail.trashed = true
    mail.save
    redirect_to :action => "inbox_messages"
  end
  
  def to_inbox_message
    mail = Mail.find(params[:id])
    mail.trashed = false
    mail.save
    redirect_to :action => "trash_messages"
  end
  
  def delete_message
     mail = Mail.find(params[:id])
     mail.delete()
     redirect_to :action => "trash_messages"
  end
 
  def remove_message
     unless params[:mail].blank?
       mail = Mail.find(params[:mail][:message_id])
       mail.each do |msg|
         msg.trashed = true
         msg.save
       end
   end
   action = params[:action][:name]
   redirect_to :action => action, :doctor_id => current_doctor.id
  end

  def medical_staff_search
    result_ids = []

    case params[:search_type]
    when "A-F"
      result_ids = fetch_medical_search_results(params, ['A','B','C','D','E','F'])
    when "G-K"
      result_ids = fetch_medical_search_results(params, ['G','H','I','J','K'])
    when "L-P"
      result_ids = fetch_medical_search_results(params, ['L','M','N','O','P'])
    when "Q-U"
      result_ids = fetch_medical_search_results(params, ['Q','R','S','T','U'])
    when "V-Z"
      result_ids = fetch_medical_search_results(params, ['V','W','X','Y','Z'])
    when "medical_group"
      params[:medical_group_id] ||= 1  # first medical group in the drop down
      search_cond = ["medical_group_id = ?", params[:medical_group_id]]
      result_ids = DoctorMedicalGroup.find(:all, :conditions => search_cond, :select => "doctor_id").map(&:doctor_id)
      @medical_groups = MedicalGroup.find(:all)
    when "speciality"
      params[:speciality_id] ||= 2  # first specialty in the drop down - Allergy & Immunology
      search_cond = ["speciality_id = ?", params[:speciality_id]] unless params[:speciality_id].nil?
      result_ids = DoctorSpeciality.find(:all, :conditions => search_cond, :select => "doctor_id").map(&:doctor_id)
      @speciality_options = Speciality.speciality_dd_options(params[:speciality_id].to_i)
    else                   
      #insurance - hard code it for now
      result_ids = []
    end

      # remove the current doctor from the list
    result_ids.delete(current_doctor.id)
    @doctors = Doctor.find(:all, :conditions => ["id in (?)", result_ids])
  end

  def add_to_quick_contact
    new_contact = Doctor.find(params[:id])
    unless current_doctor.quick_contacts.map(&:contact_id).include?(params[:id].to_i)
      contact = current_doctor.quick_contacts.build(:contact_id => params[:id])
      contact.save
      flash[:notice] = "Dr.#{new_contact.name} has been added to your quick contacts!"
    else
      flash[:notice] = "Dr.#{new_contact.name} is already in your quick contacts list!"
    end
    redirect_to :action => :medical_staff_search, :search_type => "A-F"
  end
   
  private

  def handle_messaging(params, sender, message_id, doctors = nil)
    doctors ||= Doctor.find_all_by_email(params[:message][:to])
    msg = Mail.find(:first,:conditions => ['message_id in (?) and doctor_id in (?)', message_id, sender.id])
    msg.update_attribute(:encrypt_code, Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join )) if msg
    msg.save if msg
    sms_status = ""

    doctors.each do |doc|
      mail = Mail.find(:first,:conditions => ['message_id in (?) and doctor_id in (?)', message_id, doc.id])
      mail.update_attribute(:encrypt_code, Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join ))
      mail.save
      send_sms = false

      recipient_mobile_number = doc.doctor_contact_info.nil? ? "" : doc.doctor_contact_info.mobile_number
      recipient_mobile_number ||= ""

      unless params[:send_type].nil?
        if params[:send_type][:phone] == "true"
              # if recipient doctor has been registered for phone app send it as a normal message
              # else send sms message
           if doc.mobile_register != "yes"
             send_sms = true
             sms_status += send_secure_message(mail, sender, doc, recipient_mobile_number)
           end
        end

        if params[:send_type][:work_email] == "true"
          DoctorMailer.deliver_send_secure_link(doc,mail)
        end

          #send sms to mobile number
        if params[:send_type][:secure_text] == "true"
              # if sms already sent via phone app do not send it again
          sms_status += send_secure_message(mail, sender, doc, recipient_mobile_number) unless send_sms
        end
      end

    end

    return sms_status
  end

  def send_secure_message(mail, sender, doc, recipient_mobile_number)
     sms_status = ""
     unless recipient_mobile_number.empty?
        clickatell_response = Message.send_secure_text(mail, sender, doc, recipient_mobile_number)
        puts "----------------------- clickatell response ----------------------"
        puts clickatell_response.inspect
        puts "----------------------- clickatell response body -----------------"
        puts clickatell_response.body.inspect
        puts "------------------------------------------------------------------"
        
        if clickatell_response.body.to_s.slice('ERR')
          sms_status = "Message could not be sent to Dr.#{doc.name}. Internal error. \n"
        end
     else
        sms_status = "Message could not be sent to Dr.#{doc.name}. Mobile number not yet registered. \n"
     end
     sms_status
  end

  def fetch_medical_search_results(params, char_arr)
    params[:name_search] = params[:name_search].gsub(/\s/,'') if params[:name_search]
    if params[:name_search] && params[:name_search] != "Please enter a name" && params[:name_search] != ''
      other_search_cond = build_name_search_profile_conditions(params[:name_search])
      doc_search_cond = ["name like ?", "%#{params[:name_search]}%"]
      doc_ids = Doctor.find(:all,:conditions => doc_search_cond, :select => "id").map(&:id)
    else
      params[:name_search] = nil
      other_search_cond = build_character_search_profile_conditions(char_arr)
      doc_search_cond = build_character_search_doc_conditions(char_arr)
      doc_ids = Doctor.find(:all,
                :conditions => [doc_search_cond.transpose.first.join(' or '), *doc_search_cond.transpose.last],
                :select => "id").map(&:id)
    end

    result_ids = DoctorProfessionalProfile.find(:all,
                  :conditions => [other_search_cond.transpose.first.join(' or '), *other_search_cond.transpose.last],
                  :select => "doctor_id").map(&:doctor_id)

    result_ids = result_ids.concat(doc_ids).uniq
  end

  def build_name_search_profile_conditions(search_value)
    cond = []
    cond << ["first_name like ?", "%#{search_value}%"]
    cond << ["middle_name like ?", "%#{search_value}%"]
    cond << ["last_name like ?", "%#{search_value}%"]
    cond
  end

  def build_character_search_profile_conditions(char_arr)
    cond = []
    char_arr.each do |c|
      cond << ["first_name like ?", "#{c}%"]
      cond << ["middle_name like ?", "#{c}%"]
      cond << ["last_name like ?", "#{c}%"]
    end
    cond
  end

  def build_character_search_doc_conditions(char_arr)
    cond = []
    char_arr.each do |c|
      cond << ["name like ?", "#{c}%"]
    end
    cond
  end
   
end
