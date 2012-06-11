module AuthenticatedTestHelper
  # Sets the current doctor in the session from the doctor fixtures.
  def login_as(doctor)
    @request.session[:doctor_id] = doctor ? (doctor.is_a?(Doctor) ? doctor.id : doctors(doctor).id) : nil
  end

  def authorize_as(doctor)
    @request.env["HTTP_AUTHORIZATION"] = doctor ? ActionController::HttpAuthentication::Basic.encode_credentials(doctors(doctor).login, 'monkey') : nil
  end
  
end
