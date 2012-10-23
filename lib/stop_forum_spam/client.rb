module StopForumSpam
  class UnsuccessfulResponse < StandardError; end
  class IncompleteSubmission < StandardError; end

  class Client
    include HTTParty

    REQUIRED_PARAMETERS = [:ip_address, :username, :email]

    format :xml
    base_uri("http://stopforumspam.com")

    attr_accessor :api_key, :test_mode

    alias test_mode? test_mode

    def initialize(options = {})
      options = {:api_key => options} unless options.is_a?(Hash)
      options = {:test_mode => false}.merge(options)

      @api_key = options[:api_key]
      @test_mode = options[:test_mode]
    end
    
    def post(options = {})
      raise IncompleteSubmission.new unless REQUIRED_PARAMETERS.all? { |p| options.include?(p) }

      self.class.post('/add.php', 
        :body => process_options(
          :ip_addr => options[:ip_address], 
          :email => options[:email], 
          :username => options[:username], 
          :api_key => api_key))
    end
    
    def get(options = {})
      ensure_success { self.class.get('/api', process_options(options)) }
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

    # Augments options with any defaults.
    #
    def process_options(options)
      options[:testmode] = true if test_mode?
      options
    end
  end
end
