class Conversation < ActiveRecord::Base
  attr_reader :originator, :original_message, :last_sender, :last_message, :doctors
  has_many :messages
  has_many :mails
  before_create :clean
  #looks like shit but isnt too bad
  #has_many :users, :through :messages, :source => :recipients, :uniq => true doesnt work due to recipients being a habtm association
  has_many :recipients, :class_name => 'Doctor', :finder_sql => 
    'SELECT doctors.* FROM conversations 
    INNER JOIN messages ON conversations.id = messages.conversation_id 
    INNER JOIN messages_recipients ON messages_recipients.message_id = messages.id 
    INNER JOIN doctors ON messages_recipients.recipient_id = doctors.id
    WHERE conversations.id = #{self.id} GROUP BY doctors.id;'
  
  #originator of the conversation.
  def originator()
    @orignator = self.original_message.sender if @originator.nil?
    return @orignator
  end
  
  #first message of the conversation.
  def original_message()
    @original_message = self.messages.find(:first, :order => 'created_at') if @original_message.nil?
    return @original_message
  end
  
  #sender of the last message.
  def last_sender()
     @last_sender = self.last_message.sender if @last_sender.nil?
    return @last_sender
  end
  
  #last message in the conversation.
  def last_message()
    @last_message = self.messages.find(:first, :order => 'created_at DESC') if @last_message.nil?
    return @last_message
  end
  
  #all users involved in the conversation.
  def users()
    if(@doctors.nil?)
      @doctors = self.recipients.clone
      @doctors << self.originator unless @doctors.include?(self.originator) 
    end
    return @doctors
  end
  
  protected
  #[empty method]
  #
  #this gets called before_create. Implement this if you wish to clean out illegal content such as scripts or anything that will break layout. This is left empty because what is considered illegal content varies.
  def clean()
    return if(subject.nil?)
    #strip all illegal content here. (scripts, shit that will break layout, etc.)
  end
end
