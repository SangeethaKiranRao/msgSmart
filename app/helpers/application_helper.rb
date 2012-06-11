# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

def default_values
    @doctor ||= current_doctor
end
  
 def medical_staff_view
    content_tag :div, :class => "left_tab", :id => "staff_view" do 
    "<div class='left_mar'>" + "<div class='left'>" + image_tag("/images/medical_staff_icon.png", :alt => "medical staff") + "</div>" + "<div class='left_home_nav'>" + "Medical Staff"  + "</div>" + "</div>"
    end
  end
  
  def message_view
      content_tag :div, :class => "left_tab" do 
    "<div class='left_mar'>" + "<div class='left'>" + image_tag("/images/messages_icon1.png", :alt => "message") + "</div>" + "<div class='left_home_nav'>" + "Messages"  + "</div>" +  "<div class='msg'>" + "1" + "</div>" + "</div>"
     end
    
  end


end