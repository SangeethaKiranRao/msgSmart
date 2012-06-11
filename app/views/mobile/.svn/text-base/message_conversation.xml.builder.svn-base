xml.instruct!

xml.mails do
  @message_conversation.each do |mail|
    xml.mail do 
    xml.id(mail.id)
    xml.doctor_id(mail.doctor_id)
    xml.conversation_id(mail.conversation_id)
    xml.created_at(mail.created_at)
    xml.mailbox(mail.mailbox)
    xml.read(mail.read)
    xml.trashed(mail.trashed)
    xml.message do
      xml.id(mail.message.id)
      xml.conversation_id(mail.message.conversation_id)
      xml.subject(mail.message.subject)
      xml.body(mail.message.body)
      xml.sent(mail.message.sent)
      xml.sender do 
        sender = Doctor.find(mail.message.sender_id)
        xml.id(sender.id)
        xml.email(sender.email)
        xml.first_name(sender.doctor_professional_profile.first_name) if sender.doctor_professional_profile
        xml.last_name(sender.doctor_professional_profile.last_name)  if sender.doctor_professional_profile
      end
      
      end
      
    end
  end
end