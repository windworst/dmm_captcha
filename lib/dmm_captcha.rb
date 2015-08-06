require 'json'
require 'net/http'

class DmmCaptcha
  HOST = 'http://localhost:3000'

  private_class_method :new
  def initialize key,image_url
    @key = key
    @image_url = image_url
  end

  def image_url
    @image_url
  end

  def key
    @key
  end

  def valid? value
    uri = URI(HOST + '/api/v1/dmm_captcha/verify')
    uri.query = URI.encode_www_form({key: key, value: value})
    data = JSON.parse Net::HTTP.get(uri)
    if data!=nil && data.has_key?('result')
      return data['result'] == true
    end
    return false
  end

  def self.create
    uri = URI(HOST + '/api/v1/dmm_captcha/get')
    data = JSON.parse(Net::HTTP.get(uri))
    if data!=nil && data.has_key?('key') && data.has_key?('image_url')
      return new data['key'], data['image_url']
    end
  end
end
