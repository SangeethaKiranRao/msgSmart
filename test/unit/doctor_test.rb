require File.dirname(__FILE__) + '/../test_helper'

class DoctorTest < ActiveSupport::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :doctors

  def test_should_create_doctor
    assert_difference 'Doctor.count' do
      doctor = create_doctor
      assert !doctor.new_record?, "#{doctor.errors.full_messages.to_sentence}"
    end
  end

  def test_should_initialize_activation_code_upon_creation
    doctor = create_doctor
    doctor.reload
    assert_not_nil doctor.activation_code
  end

  def test_should_create_and_start_in_pending_state
    doctor = create_doctor
    doctor.reload
    assert doctor.pending?
  end


  def test_should_require_login
    assert_no_difference 'Doctor.count' do
      u = create_doctor(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'Doctor.count' do
      u = create_doctor(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'Doctor.count' do
      u = create_doctor(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'Doctor.count' do
      u = create_doctor(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    doctors(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal doctors(:quentin), Doctor.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    doctors(:quentin).update_attributes(:login => 'quentin2')
    assert_equal doctors(:quentin), Doctor.authenticate('quentin2', 'monkey')
  end

  def test_should_authenticate_doctor
    assert_equal doctors(:quentin), Doctor.authenticate('quentin', 'monkey')
  end

  def test_should_set_remember_token
    doctors(:quentin).remember_me
    assert_not_nil doctors(:quentin).remember_token
    assert_not_nil doctors(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    doctors(:quentin).remember_me
    assert_not_nil doctors(:quentin).remember_token
    doctors(:quentin).forget_me
    assert_nil doctors(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    doctors(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil doctors(:quentin).remember_token
    assert_not_nil doctors(:quentin).remember_token_expires_at
    assert doctors(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    doctors(:quentin).remember_me_until time
    assert_not_nil doctors(:quentin).remember_token
    assert_not_nil doctors(:quentin).remember_token_expires_at
    assert_equal doctors(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    doctors(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil doctors(:quentin).remember_token
    assert_not_nil doctors(:quentin).remember_token_expires_at
    assert doctors(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_register_passive_doctor
    doctor = create_doctor(:password => nil, :password_confirmation => nil)
    assert doctor.passive?
    doctor.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    doctor.register!
    assert doctor.pending?
  end

  def test_should_suspend_doctor
    doctors(:quentin).suspend!
    assert doctors(:quentin).suspended?
  end

  def test_suspended_doctor_should_not_authenticate
    doctors(:quentin).suspend!
    assert_not_equal doctors(:quentin), Doctor.authenticate('quentin', 'test')
  end

  def test_should_unsuspend_doctor_to_active_state
    doctors(:quentin).suspend!
    assert doctors(:quentin).suspended?
    doctors(:quentin).unsuspend!
    assert doctors(:quentin).active?
  end

  def test_should_unsuspend_doctor_with_nil_activation_code_and_activated_at_to_passive_state
    doctors(:quentin).suspend!
    Doctor.update_all :activation_code => nil, :activated_at => nil
    assert doctors(:quentin).suspended?
    doctors(:quentin).reload.unsuspend!
    assert doctors(:quentin).passive?
  end

  def test_should_unsuspend_doctor_with_activation_code_and_nil_activated_at_to_pending_state
    doctors(:quentin).suspend!
    Doctor.update_all :activation_code => 'foo-bar', :activated_at => nil
    assert doctors(:quentin).suspended?
    doctors(:quentin).reload.unsuspend!
    assert doctors(:quentin).pending?
  end

  def test_should_delete_doctor
    assert_nil doctors(:quentin).deleted_at
    doctors(:quentin).delete!
    assert_not_nil doctors(:quentin).deleted_at
    assert doctors(:quentin).deleted?
  end

protected
  def create_doctor(options = {})
    record = Doctor.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69' }.merge(options))
    record.register! if record.valid?
    record
  end
end
