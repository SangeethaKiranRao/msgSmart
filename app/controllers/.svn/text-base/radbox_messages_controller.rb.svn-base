class RadboxMessagesController < ApplicationController

  layout "nurse", :only => [:new, :create, :outbox]
  before_filter :fetch_sender
  
  def inbox
    fetch_receiver
    @radbox_messages = @recipient.received_messages.empty? ? "" : @recipient.received_messages.paginate(:page => params[:page], :per_page => 14)
    render :action => "inbox", :layout => "application"
  end
  
  def show
    @radbox_message = RadboxMessage.read(params[:id], @nurse)
    layout = params[:inbox] ? "application" : "nurse"
    render :action => "show", :layout => layout
  end
  
  def new
    @radbox_message = RadboxMessage.new

    if params[:reply_to]
      @reply_to = @nurse.received_messages.find(params[:reply_to])
      unless @reply_to.nil?
        @radbox_message.to = @reply_to.sender.login
        @radbox_message.subject = "Re: #{@reply_to.subject}"
        @radbox_message.body = "\n\n*Original message*\n\n #{@reply_to.body}"
      end
    end
  end
  
  def create
    flash[:error]  = ""
    flash[:error] += "Please enter the To address.<br>" if params[:message].blank?
    flash[:error] += "Please enter the Subject.<br>" if params[:radbox_message][:subject].empty?
    flash[:error] += "Please enter the Message Body." if params[:radbox_message][:body].empty?
    
    unless flash[:error].empty?
      @radbox_message = RadboxMessage.new(params[:radbox_message])
      render :action => "new"
    else
      recipients = Doctor.find_all_by_email(params[:message][:to])
      if recipients.empty?
        flash[:error] = "Unable to find Doctor(s) with emailid(s) #{params[:message][:to]}"
        @radbox_message = RadboxMessage.new(params[:radbox_message])
        render :action => "new"
      else
        recipients.each do |doc|
          @radbox_message = RadboxMessage.new(params[:radbox_message])
          @radbox_message.sender = @nurse
          @radbox_message.recipient = doc
          @radbox_message.save
        end
        flash[:error] = "Message sent"
        redirect_to new_nurse_radbox_message_path
      end
    end
  end
  
  def delete_selected
    if request.post?
      if params[:delete]
        params[:delete].each { |id|
          @radbox_message = RadboxMessage.find(:first, :conditions => ["radbox_messages.id = ? AND (sender_id = ? OR recipient_id = ?)", id, @nurse, @nurse])
          @radbox_message.mark_deleted(@nurse) unless @radbox_message.nil?
        }
        flash[:notice] = "Messages deleted"
      end
      # redirect_to nurse_radbox_message_path(@nurse, @radbox_messages)
      redirect_to new_nurse_radbox_message_path
    end
  end

  def outbox
    @radbox_sent_messages = @nurse.sent_messages.empty? ? "" : @nurse.sent_messages.paginate(:page => params[:page], :per_page => 14)
  end
  
  private
    def fetch_sender
      #@nurse = Nurse.find(params[:nurse_id])
      #
      # currently there's no user management system done for nurses
      # hence all nurses will access same interface
      @nurse = Nurse.find(1)
    end

    def fetch_receiver
      @recipient = Doctor.find(params[:doctor_id])
    end
end