require 'rubygems'
require 'activesupport'
require 'spec'
require 'fakeweb'

require File.join(File.dirname(__FILE__), '..', 'lib', 'stop_forum_spam')

def fake_get_response(params, options={})
  url = "http://stopforumspam.com/api?" + params
  type, value = params.split('=')
  options[:body] = format_options(options)
  FakeWeb.register_uri(:get, url, options)
end

def format_options(options)
  appears = options[:appears]
  frequency = options[:frequency]
  last_seen = options[:last_seen]
  
  response = "<response success='true'><type>#{type}</type><appears>#{appears ? 'yes' : 'no'}</appears><frequency>#{appears ? '0' : frequency}</frequency><lastseen>#{last_seen}</lastseen></response>"
  
end