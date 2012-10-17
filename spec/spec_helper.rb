require 'cgi'

require 'rubygems'
require 'bundler/setup'

Bundler.require(:default, :test)

require File.join(File.dirname(__FILE__), '..', 'lib', 'stop_forum_spam')

def fake_get_response(options = {})
  options = [options] unless options.is_a?(Array)

  options.length.times do |i|
    options[i][:type] ||= [:ip, :email, :username].find { |k| options[i].has_key?(k) }.to_s
  end

  params = options.map { |opts| "#{opts[:type]}=#{CGI.escape(opts[opts[:type].to_sym])}" }

  url = "http://stopforumspam.com/api?#{params.join('&')}"

  FakeWeb.register_uri(:get, url, :body => format_options(options))
end

def fake_post_response(api_key, ip_addr, email, username, options={})
  FakeWeb.register_uri(:post, "http://stopforumspam.com/add.php", options)
end

def format_options(options)
  options = [options] unless options.is_a?(Array)

  xml = "<response success='true'>"

  options.each do |options|
    appears = options[:appears]
    frequency = options[:frequency]
    last_seen = options[:last_seen]

    xml += <<-end
      <type>#{options[:type]}</type>
      <appears>#{appears ? 'yes' : 'no'}</appears>
      <frequency>#{appears ? frequency : 0}</frequency>
      <lastseen>#{last_seen}</lastseen>
    end
  end

  xml += "</response>"
end
