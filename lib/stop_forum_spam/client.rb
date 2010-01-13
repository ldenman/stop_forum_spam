module StopForumSpam
  class Client
    include HTTParty
    format :xml
    base_uri("http://stopforumspam.com")
    
    attr_accessor :api_key
    
    def initialize(api_key=nil)
      @api_key = api_key
    end
    
    def post(options={})
      self.class.post('/post.php', 
        :body => {
          :ip_addr => options[:ip_address], 
          :email => options[:email], 
          :username => options[:username], 
          :api_key => api_key })
    end
    
    def get(options={})
      self.class.get('/api', options)
    end
  end
end
