spec = Gem::Specification.new do |s|
  s.name = 'stop_forum_spam'
  s.version = '0.0.1'
  s.summary = "API Wrapper for http://stopforumspam.com"
  s.description = %{Small api wrapper for querying a spammer based on ip, email, or username information stored on http://stopforumspam.com}
  s.files = Dir['lib/**/*.rb'] + Dir['spec/**/*.rb']
  s.require_path = 'lib'
  s.autorequire = 'httparty'
  s.has_rdoc = false
  s.author = "Lake Denman"
  s.email = "lake@lakedenman.com"
  s.homepage = "http://lakedenman.com"
end
