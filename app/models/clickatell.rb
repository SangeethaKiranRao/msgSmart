class Clickatell < ActiveRecord::Base
require 'net/http'

  protected
    CLICKATELL_API_KEY             = 3375902
    CLICKATELL_USER_NAME           = "rameshmd"
    CLICKATELL_PASSWORD            = "Ramesh01$"
    CLICKATELL_TWO_WAY_NUMBER      = 12013457334
    CLICKATELL_GET_ACKNOWLEDGEMENT = 1

    def self.make_http_request_for_sms(sms_info, sms_link, recipient_mobile_number)

      sms_message  = sms_info
      sms_message += "Click here to open securely via msgSMART\n"
      sms_message += sms_link

        # sanitize the mobile number & add the country code
      recipient_mobile_number  = ("1" + recipient_mobile_number).to_s.gsub(/\(|\)|\.|-|\s/, '')

      url = URI.parse('http://api.clickatell.com/http/sendmsg')
      post_args = {}
      post_args["password"] = CLICKATELL_PASSWORD
      post_args["user"]     = CLICKATELL_USER_NAME
      post_args["api_id"]   = CLICKATELL_API_KEY
      post_args["to"]       = recipient_mobile_number
      post_args["text"]     = sms_message
      post_args["from"]     = CLICKATELL_TWO_WAY_NUMBER
      post_args["mo"]       = CLICKATELL_GET_ACKNOWLEDGEMENT

      return Net::HTTP.post_form(url, post_args)

    end
end