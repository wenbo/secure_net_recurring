require 'active_merchant'

module ActiveMerchant
  module Billing
    class SecureNetGateway < Gateway

      #self.test_url = 'https://certify.securenet.com/API/gateway.svc/webHttp/ProcessTransaction' 
      self.recurring_url = 'https://gateway.securenet.com/API/data/service.svc/webHttp/AddABAccount' 

      def recurring
        puts self.recurring_url
      end
    end
  end
end
