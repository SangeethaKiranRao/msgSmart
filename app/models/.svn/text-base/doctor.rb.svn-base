require 'digest/sha1'

class Doctor < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::StatefulRoles

  has_private_messages :class_name => 'RadboxMessage', :receiver => true
  
  acts_as_messageable

#  removing mobile number field from sign up
#  attr_accessor :doc_mobile_number

  validates_presence_of     :name #, :message => "Full name cannot be blank"
  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message
  validates_length_of       :name,     :within => 3..40

  validates_presence_of     :email#, :message => "Email cannot be blank"
  #r@a.wk
  validates_length_of       :email,    :within => 6..100#, :message => "Invalid Email Address"
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

#  validates_presence_of :mobile_number#, :message => "Mobile number cannot be blank" #, :allow_nil => true
#  validates_format_of :doc_mobile_number,  :with => /^(\(?\d\d\d\)?)?( |-|\.)?\d\d\d( |-|\.)?\d{4,4}(( |-|\.)?[ext\.]+ ?\d+)?$/
#  validates_uniqueness_of   :mobile_number#, :message => "Mobile number already registered"

  validates_uniqueness_of   :email#, :message => "Email address already registered"

  has_one  :doctor_professional_profile, :dependent => :destroy
  has_one  :doctor_contact_info, :dependent => :destroy
  has_one  :doctor_contact_share, :dependent => :destroy
  has_one  :hospital_contact_share, :dependent => :destroy
  has_one  :public_contact_share, :dependent => :destroy
  has_one  :doctor_personal_profile, :dependent => :destroy
  has_many :doctor_specialities
  has_many :specialities, :through => :doctor_specialities
  has_many :doctor_medical_groups
  has_many :medical_groups, :through => :doctor_medical_groups
  has_many :doctor_hospitals
  has_many :hospitals, :through => :doctor_hospitals
  has_many :quick_contacts, :dependent => :destroy  
  has_many :pictures

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :web_login_status, :mobile_login_status, :web_register, :mobile_register, :verify_code_mobile



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find_in_state :first, :active, :conditions => {:email => email.downcase} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

#  def email=(value)
#    write_attribute :email, (value ? value.downcase : nil)
#  end

#  def doc_mobile_number
#    unless self.mobile_number.nil?
#      cell_no = self.mobile_number.to_s
#      '(' + cell_no[0,3] + ')-' + cell_no[3,3] + '-' + cell_no[6,4]
#    end
#  end
#
#  def doc_mobile_number=(value)
#    if value.nil?
#      self.errors.add_to_base("Mobile number cannot be blank")
#    elsif value =~ /^(\(?\d\d\d\)?)?( |-|\.)?\d\d\d( |-|\.)?\d{4,4}(( |-|\.)?[ext\.]+ ?\d+)?$/
#      self.mobile_number = value.gsub(/\(|\)|\.|-|\s/, '')
#    else
#      self.errors.add_to_base("Invalid mobile number")
#    end
#  end

  def create_reset_code
    @reset = true
    self.update_attribute(:reset_code, Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join ))
    save(false)
  end
  
  def recently_reset?
    @reset
  end 
  
  def delete_reset_code
    self.attributes = {:reset_code => nil}
    save(false)
  end

  def self.doctor_data(doctor_id)
    @u = find(:all,:conditions => ['id not in (?)',doctor_id],:select => "email")
    len = @u.count - 1
    str = ""
    #@arr = Array.new
    @u.each_with_index do |u,i|
      if i == len
        str += "{email:'#{u.email}' }"
     else
       str += "{email:'#{u.email}' },"
     end
      
  end
  return str
end

    protected
      def make_activation_code
            self.deleted_at = nil
            self.activation_code = self.class.make_token
      end
      
   private
   
   def self.random_string(len) 
    #generat a random password consisting of strings and digits
        chars = ("a".."h").to_a + ("j".."k").to_a + ("m".."n").to_a+ ("p".."u").to_a+ ("w".."z").to_a + ("A".."H").to_a + ("J".."K").to_a+ ("M".."N").to_a+ ("P".."u").to_a+ ("w".."Z").to_a  + ("2".."9").to_a
        #chars = ("0".."9").to_a
        newpass = ""
        1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
    end
  
end
