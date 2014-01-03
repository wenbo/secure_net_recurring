require 'active_merchant'

module ActiveMerchant
  module Billing
    class SecureNetGateway < Gateway

      class_attribute :recurring_url

      #self.test_url = 'https://gateway.securenet.com/api/Gateway.svc/webHttp/ProcessTransaction'   this url works.
      #self.test_url = 'https://gateway.securenet.com/API/Gateway.svc/webHttp/ProcessTransaction' 
      self.recurring_url = 'https://gateway.securenet.com/API/Gateway.svc/webHttp/AddABAccount' 

      def recurring(money, creditcard, options = {})
        recurring_commit(build_recurring_plan_ab(creditcard, options, :recurring, money))
      end

       private
       def recurring_commit(request)
         xml = build_request(request)
         url = self.recurring_url 
         data = ssl_post(url, xml, "Content-Type" => "text/xml")
         response = parse(data)

         Response.new(success?(response), message_from(response), response,
                      :test => test?,
                      :authorization => build_authorization(response),
                      :avs_result => { :code => response[:avs_result_code] },
                      :cvv_result => response[:card_code_response_code]
         )
       end

       def build_request(request)
        xml = Builder::XmlMarkup.new

        xml.instruct!
        xml.tag!("PLAN_AB", XML_ATTRIBUTES) do
          xml << request
        end

        xml.target!
      end

      def build_recurring_plan_ab(creditcard, options, action, money)
        xml = Builder::XmlMarkup.new

        xml.tag! 'CUSTOMERID', creditcard.number
        add_installment(xml, creditcard, money)
        add_merchant_key(xml, options) 
        xml.tag! 'PAYMENTID', creditcard.number
        add_recurring(xml, creditcard, money)
        add_schedule(xml, creditcard)
        xml.tag! 'STARTDATE', "02202014"
        xml.tag! 'TYPE', "REC"

        xml.target!
      end

      def add_options(xml, creditcard)
        xml.tag!("OPTIONS") do
          xml.tag! 'CYCLE', 'M'
          xml.tag! 'DAY', 5 #Integer / 2 
          xml.tag! 'FREQUENCY', 1 #Integer / 2 
        end
      end

      def add_installment(xml, creditcard, money)
        xml.tag!("INSTALLMENT") do
          xml.tag! 'CYCLE', 'M'
          xml.tag! 'DAY', 5 #Integer / 2 
          xml.tag! 'FREQUENCY', 1 #Integer / 2 
          xml.tag! 'AMOUNT', amount(money) 
          xml.tag! 'AUTOCALC_OPTION', 'A'
          xml.tag! 'BALLOON_AMOUNT', 0
          xml.tag! 'BALLOON_OPTION', 1
          xml.tag! 'COUNT', 1
          xml.tag! 'REMAINDER_OPTION', 1
        end
      end

      def add_recurring(xml, creditcard, money)
        xml.tag!("RECURRING") do
          xml.tag! 'CYCLE', 'M'
          xml.tag! 'DAY', 5 #Integer / 2 
          xml.tag! 'FREQUENCY', 1 #Integer / 2 
          xml.tag! 'AMOUNT', amount(money) 
          xml.tag! 'NOEND_FLAG', 1
        end
      end

      def add_schedule(xml, creditcard)
        xml.tag!("SCHEDULE") do
        end
      end

    end
  end
end
