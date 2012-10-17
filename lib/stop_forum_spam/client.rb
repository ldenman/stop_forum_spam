module StopForumSpam
  class UnsuccessfulResponse < StandardError; end
  class IncompleteSubmission < StandardError; end

  class Client
    include HTTParty

    REQUIRED_PARAMETERS = [:ip_address, :username, :email]

    format :xml
    base_uri("http://stopforumspam.com")

    attr_accessor :api_key
    
    def initialize(api_key=nil)
      @api_key = api_key
    end
    
    def post(options={})
      raise IncompleteSubmission.new unless REQUIRED_PARAMETERS.all? { |p| options.include?(p) }

      self.class.post('/add.php', 
        :body => {
          :ip_addr => options[:ip_address], 
          :email => options[:email], 
          :username => options[:username], 
          :api_key => api_key })
    end
    
    def get(options={})
      ensure_success { self.class.get('/api', options) }
    end

    private

    # Wraps the given request block to ensure that the response's success
    # flag is true.
    #
    def ensure_success
      result = yield
      raise UnsuccessfulResponse.new unless result['response']['success'] == 'true'
      result
    end
  end
end
