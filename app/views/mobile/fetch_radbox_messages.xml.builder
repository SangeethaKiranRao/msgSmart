xml.instruct!

xml.mails do
  @radbox_messages.each do |mail|
    xml.mail do
    xml.id(mail.id)
    xml.sender_id(mail.sender_id)
    xml.recipient_id(mail.recipient_id)
    xml.created_at(mail.created_at)
    xml.read_at(mail.read_at)
    xml.sender_deleted(mail.sender_deleted)
    xml.recipient_deleted(mail.recipient_deleted)
    xml.subject(mail.subject)
    xml.body(mail.body)
    xml.sender do
      sender = Nurse.find(mail.sender_id)
      xml.id(sender.id)
      xml.email(sender.email)
      xml.name(sender.name)
    end
    xml.recipient do
        recipient = Doctor.find(mail.recipient_id)
        xml.id(recipient.id)
        xml.email(recipient.email)
        xml.first_name(recipient.doctor_professional_profile.first_name) if recipient.doctor_professional_profile
        xml.last_name(recipient.doctor_professional_profile.last_name) if recipient.doctor_professional_profile
      end

    end
  end
end