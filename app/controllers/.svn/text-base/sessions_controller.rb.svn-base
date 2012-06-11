# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  layout 'doctors'
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # render new.erb.html
  def new
     @doctor = Doctor.new
     render :text => "",:layout => "doctors" 
  end

  def create
     
    logout_keeping_session!
    doctor = Doctor.authenticate(params[:email], params[:password])
    if doctor
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_doctor = doctor
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
     # redirect_back_or_default('/')
     # flash[:notice] = "Logged in successfully"
      if session[:return_to]
        redirect_to(session[:return_to])
        session[:return_to] = nil
     else
     if doctor.doctor_professional_profile.nil?
       redirect_to :controller => "profile",:action => 'index', :doctor_id => doctor.id
     else
     redirect_to :controller => "home", :action => 'index', :doctor_id => doctor.id  
     end
     end      
    else
      note_failed_signin
      @email       = params[:email]
      @remember_me = params[:remember_me]
      flash[:no_login] = "Please enter correct Email ID or Password."
      redirect_to :controller => 'doctors', :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
     if flash[:notice]
       flash[:secure_info] = flash[:notice] # preserving the flash info in order to display in view, else it'll be lost
     else
       flash[:notice] = "You have been logged out."
     end
     redirect_to :controller => "doctors", :action => "new"
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:email]}'"
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end