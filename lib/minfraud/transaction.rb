require 'digest/md5'

module Minfraud

  # This is the container for the data you're sending to MaxMind.
  # A transaction holds data like name, address, IP, order amount, etc.
  class Transaction

    # Required attribute
    attr_accessor :ip

    # Shipping address attribute (optional)
    attr_accessor :city, :state, :postal, :country, :ship_addr, :ship_city, :ship_state, :ship_postal, :ship_country

    # User attribute (optional)
    attr_accessor :email, :phone

    # Credit card attribute (optional)
    attr_accessor :bin

    # Transaction linking attribute (optional)
    attr_accessor :session_id, :user_agent, :accept_language

    # Transaction attribute (optional)
    attr_accessor :txn_id, :amount, :currency, :txn_type

    # Credit card result attribute (optional)
    attr_accessor :avs_result, :cvv_result

    # Miscellaneous attribute (optional)
    attr_accessor :requested_type, :forwarded_ip

    def initialize
      yield self
      unless has_required_attributes?
        raise TransactionError, 'You did not set all the required transaction attributes.'
      end
      validate_attributes
    end

    # Retrieves the risk score from MaxMind.
    # A higher score indicates a higher risk of fraud.
    # For example, a score of 20 indicates a 20% chance that a transaction is fraudulent.
    # @return [Float] 0.01 - 100.0
    def risk_score
      results.risk_score
    end

    def distance
      results.distance
    end

    def country_code
      results.country_code
    end

    def ip_region
      results.ip_region
    end

    def ip_city
      results.ip_city
    end

    def ip_latitude
      results.ip_latitude
    end

    def ip_longitude
      results.ip_longitude
    end

    def high_risk_country
      results.high_risk_country
    end

    def ip_postal_code
      results.ip_postal_code
    end

    def ip_accuracy_radius
      results.ip_accuracy_radius
    end

    def ip_area_code
      results.ip_area_code
    end

    def ip_region_name
      results.ip_region_name
    end

    def ip_country_name
      results.ip_country_name
    end

    # Hash of attributes that have been set
    # @return [Hash] present attributes
    def attributes
      attrs = [:ip, :city, :state, :postal, :country, :license_key, :ship_addr, :ship_city, :ship_state, :ship_postal, :ship_country, :email_domain, :email_md5, :phone, :bin, :session_id, :user_agent, :accept_language, :txn_id, :amount, :currency, :txn_type, :avs_result, :cvv_result, :requested_type, :forwarded_ip]
      attrs.map! do |a|
        [a, send(a)]
      end
      Hash[attrs]
    end

    # Uses the requested_type set on the instance, or if not present, the requested_type set during configuration
    # @return [String, nil] requested type
    def requested_type
      @requested_type or Minfraud.requested_type
    end

    private

    # Ensures the required attributes are present
    # @return [Boolean]
    def has_required_attributes?
      ip
    end

    # Validates the types of the attributes
    # @return [nil, TransactionError]
    def validate_attributes
      [:ip].each { |s| validate_string(s) }
    end

    # Given the symbol of an attribute that should be a string,
    # it checks the attribute's type and throws an error if it's not a string.
    # @param attr_name [Symbol] name of the attribute to validate
    # @return [nil, TransactionError]
    def validate_string(attr_name)
      attribute = self.send(attr_name)
      unless attribute.instance_of?(String)
        raise TransactionError, "Transaction.#{attr_name} must be a string"
      end
    end

    # Sends transaction to MaxMind in order to get risk data on it.
    # Caches response object in @response.
    # @return [Response]
    def results
      @response ||= Request.get(self)
    end

    # @return [String, nil] domain of the email address
    def email_domain
      email.to_s.split('@').last
    end

    # @return [String, nil] MD5 hash of the whole email address
    def email_md5
      Digest::MD5.hexdigest(email.to_s)
    end

    # @return [String] license key set during configuration
    def license_key
      Minfraud.license_key
    end

  end
end
