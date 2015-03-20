# Ruby interface to the MaxMind minFraud API

Compatible with version minFraud API v1.3  
[minFraud API documentation](http://dev.maxmind.com/minfraud/)  
[minFraud](http://www.maxmind.com/en/ccv_overview)

Modified so the only required values are a license key and an IP address.
Also exposed more of the response attributes in the object.

[![Build Status](https://travis-ci.org/rdpitts/minfraud-ruby.svg?branch=master)](https://travis-ci.org/rdpitts/minfraud-ruby)
[![Code Climate](https://codeclimate.com/github/rdpitts/minfraud-ruby.png)](https://codeclimate.com/github/rdpitts/minfraud-ruby)

[Rubydoc documentation](http://rubydoc.info/github/rdpitts/minfraud-ruby/master/frames)

## Configuration

Your license key is how MaxMind will identify you, so it is required.

```ruby
Minfraud.configure do |c|
  c.license_key = 'abcd1234'
  c.requested_type = 'standard'
end
```

`requested_type` can be set during configuration to use that default value or it can be set on the transaction. If unset minFraud will default to the highest level of service available to you.

## Usage

```ruby
transaction = Minfraud::Transaction.new do |t|
  # Required fields
  t.ip = '1.2.3.4'
  # Other fields listed are optional, but will provide a more accurate risk score
  t.city = 'richmond'
  t.state = 'virginia'
  t.postal = '12345'
  t.country = 'US' # http://en.wikipedia.org/wiki/ISO_3166-1
  # ...
end

transaction.risk_score
# => 3.48

Other attributes available in the transaction are as follows:
transaction.distance
# => 0
transaction.country_code
# => US
transaction.ip_region
# => VA
transaction.ip_city
# => Richmond
transaction.ip_latitude
# => 37.5409
transaction.ip_longitude
# => -77.4801
transaction.high_risk_country
# => No
transaction.ip_postal_code
# => 23284
transaction.ip_accuracy_radius
# => 16
transaction.ip_area_code
# => 804
transaction.ip_region_name
# => Virginia
transaction.ip_country_name
# => United States
transaction.anonymous_proxy
# => No
transaction.corporate_proxy
# => No
```

### Exception handling

There are three different exceptions that this gem may raise. Please be prepared to handle them:

```ruby
# Raised if configuration is invalid
class ConfigurationError < ArgumentError; end

# Raised if a transaction is invalid
class TransactionError < ArgumentError; end

# Raised if minFraud returns an error, or if there is an HTTP error
class ResponseError < StandardError; end
```

### Transaction fields

#### Required

| name          | type (length)         | example                             | description |
| ------------- | --------------------- | ----------------------------------- | ----------- |
| ip            | string                | `t.ip = '1.2.3.4'`                  | Customer IP address |

#### Optional

| name               | type (length)      | description |
| ------------------ | ------------------ | ----------- |
| city          | string                | `t.city = 'new york'`               | Customer city |
| state         | string                | `t.state = 'new york'`              | Customer state/province/region |
| postal        | string                | `t.postal = '10014'`                | Customer zip/postal code |
| country       | string                | `t.country = 'US'`                  | Customer ISO 3166-1 country code |
| ship_addr          | string             | |
| ship_city          | string             | |
| ship_state         | string             | |
| ship_postal        | string             | |
| ship_country       | string             | |
| email              | string             | We will hash the email for you |
| phone              | string             | Any format acceptable |
| bin                | string             | CC bin number (first 6 digits) |
| session_id         | string             | Used for linking transactions |
| user_agent         | string             | Used for linking transactions |
| accept_language    | string             | Used for linking transactions |
| txn_id             | string             | Transaction/order id |
| amount             | string             | Transaction amount |
| currency           | string             | ISO 4217 currency code |
| txn_type           | string             | creditcard/debitcard/paypal/google/other/lead/survey/sitereg |
| avs_result         | string             | Standard AVS response code |
| cvv_result         | string             | Y/N |
| requested_type     | string             | standard/premium |
| forwarded_ip       | string             | The end user’s IP address, as forwarded by a transparent proxy |

## Contributing

1. Fork it ( http://github.com/rdpitts/minfraud-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
