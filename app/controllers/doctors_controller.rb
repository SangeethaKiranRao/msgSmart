class DoctorsController < ApplicationController
  layout 'doctors'
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_doctor, :only => [:suspend, :unsuspend, :destroy, :purge]
  

  # render new.rhtml
  def new
    @doctor = Doctor.new
#    flash[:notice] = ""
  end
 
  def create
    logout_keeping_session!
    @doctor = Doctor.new(params[:doctor])
    @doctor.register! if @doctor && @doctor.valid?
    success = @doctor && @doctor.valid?
    if success && @doctor.errors.empty?
      @doctor.reload
      DoctorMailer.deliver_signup_notification(@doctor)
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    doctor = Doctor.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && doctor && !doctor.active?
      doctor.activate!
      flash[:info] = "Signup complete! Please sign in to continue."
      DoctorMailer.deliver_activation(doctor) if  doctor.recently_activated?
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a doctor with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def forgot
    if request.post?
      if !params[:doctor][:email].blank?
        doctor = Doctor.find_by_email(params[:doctor][:email])
        if doctor
          doctor.create_reset_code
          DoctorMailer.deliver_reset_notification(doctor) if doctor.recently_reset?
          #flash[:notice] = "Reset code sent to #{doctor.email}"
          flash[:info] = "Reset code sent to #{doctor.email}"
          redirect_back_or_default('/')
        else
          flash[:notice] = "'#{params[:doctor][:email]}'" +" does not exist in system"
          render :action => "forgot"
        end
      else
        flash[:notice] = "Please enter a valid email id"
        render :action => "forgot"
      end
    end
    
  end
  
  
  def reset
    @doctor = Doctor.find_by_reset_code(params[:reset_code]) unless params[:reset_code].nil?
    if request.post?  
      if !params[:doctor][:password].blank? && !params[:doctor][:password_confirmation].blank?
        if @doctor.update_attributes(:password => params[:doctor][:password], :password_confirmation => params[:doctor][:password_confirmation])
          self.current_doctor = @doctor
          @doctor.delete_reset_code
          #flash[:notice] = "Password reset successfully for #{@doctor.email}"
          flash[:info] = "Password reset successfully for #{@doctor.email}"
          redirect_back_or_default('/')
        else
          render :action => :reset
        end
      else
        @doctor.email_blank
        render :action => :reset
      end
    end
  end


  def suspend
    @doctor.suspend! 
    redirect_to doctors_path
  end

  def unsuspend
    @doctor.unsuspend! 
    redirect_to doctors_path
  end

  def destroy
    @doctor.delete!
    redirect_to doctors_path
  end

  def purge
    @doctor.destroy
    redirect_to doctors_path
  end
  
  # There's no page here to update or destroy a doctor.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

  protected
    def find_doctor
      @doctor = Doctor.find(params[:id])
    end
  end