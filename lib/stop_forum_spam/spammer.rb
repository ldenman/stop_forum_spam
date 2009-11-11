module StopForumSpam
  class Spammer   
    include HTTParty
    format :xml
    base_uri("http://stopforumspam.com")
    
    attr_reader :id, :type, :frequency, :last_seen, :appears
    
    def initialize(id)
      @id         = id
      @type       = guess_type
      @frequency  = response["frequency"]
      @last_seen  = response["lastseen"]
      @appears    = response['appears'] == 'yes' ? true : false
    end
    
    def appears?
      appears
    end
    
    def count
      frequency
    end
        
    def self.is_spammer?(id)
      new(id).appears?
    end
    
    private
      
      def guess_type
        return 'ip' if @id.match(/\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/)
        return 'email' if @id.match(/.*@.*/)
        return 'username'
      end
      
      def response
        @response ||= make_request['response']
      end
      def make_request
        self.class.get('/api', :query => {@type.to_sym => @id})
      end
  end
end