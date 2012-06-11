class Message < ActiveRecord::Base

  #include Clickatell

  #any additional info that needs to be sent in a message (ex. I use these to determine request types)
  serialize :headers
  
  class_inheritable_accessor :on_deliver_callback
  protected :on_deliver_callback
  
  belongs_to :sender, :class_name => 'Doctor', :foreign_key => 'sender_id'
  belongs_to :conversation
  has_and_belongs_to_many :recipients, :class_name => 'Doctor', :join_table => 'messages_recipients', :association_foreign_key => 'recipient_id'
  
  #delivers a message to the the given mailbox of all recipients, calls the on_deliver_callback if initialized.
  #
  #====params:
  #mailbox_type:: the mailbox to send the message to
  #clean:: calls the clean method if this is set (must be implemented)
  #
  def deliver(mailbox_type, clean = true)
    clean() if clean
    self.save()
    self.recipients.each do |r|
      r.mailbox[mailbox_type] << self
    end
    self.on_deliver_callback.call(self, mailbox_type) unless self.on_deliver_callback.nil?
  end
  
  #sets the on_deliver_callback to the passed method. The method call should expect 2 params (message, mailbox_type).
  def self.on_deliver(method)
    self.on_deliver_callback = method
  end

  def self.send_secure_text(mail, sender, recipient, recipient_mobile_number)
    sms_info = "Message from: Dr. #{sender.name}."
    if recipient.doctor_professional_profile && recipient.doctor_professional_profile.use_secure_pin
      sms_link = "http://msgSmart.com/secure_link/#{mail.encrypt_code}"
    else
      sms_link = "http://msgSmart.com/view_message#{mail.id}"
    end
    return Clickatell.make_http_request_for_sms(sms_info, sms_link, recipient_mobile_number)
  end
  
  protected
  #[empty method]
  #
  #this gets called when a message is delivered and the clean param is set (default). Implement this if you wish to clean out illegal content such as scripts or anything that will break layout. This is left empty because what is considered illegal content varies.
  def clean()
    #strip all illegal content here. (scripts, shit that will break layout, etc.)
  end
end

