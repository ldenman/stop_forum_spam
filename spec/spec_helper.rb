require 'rubygems'
require 'active_support'
require 'spec'
require 'fakeweb'

require File.join(File.dirname(__FILE__), '..', 'lib', 'stop_forum_spam')

def fake_get_response(options={})
  id_type = [:ip, :email, :username].select { |k| options.has_key?(k) }.first.to_s
  url = "http://stopforumspam.com/api?#{id_type}=#{options[id_type.to_sym]}"
  options[:type] = id_type
  options[:string] = format_options(options)
  FakeWeb.register_uri(:get, url, options)
end

def fake_post_response(api_key, ip_addr, email, username, options={})
  FakeWeb.register_uri(:post, "http://stopforumspam.com:80/post.php", options)
end

def format_options(options)
  appears = options[:appears]
  frequency = options[:frequency]
  last_seen = options[:last_seen]
  "<response success='true'><type>#{options[:type]}</type><appears>#{appears ? 'yes' : 'no'}</appears><frequency>#{appears ? '0' : frequency}</frequency><lastseen>#{last_seen}</lastseen></response>"
end
