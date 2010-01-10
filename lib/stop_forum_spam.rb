$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'httparty'
require 'stop_forum_spam/spammer'
require 'stop_forum_spam/client'

module StopForumSpam
  VERSION = '0.0.1'
end