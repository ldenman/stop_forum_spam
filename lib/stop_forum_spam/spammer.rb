module StopForumSpam
  class Spammer   
    include HTTParty
    format :xml
    base_uri("http://stopforumspam.com")
    
    attr_reader :type, :id, :frequency, :last_seen
    
    def initialize(id)
      @id = id
      
      if @id.match(/\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/)
        @type = 'ip'
      elsif @id.match(/.*@.*/)
        @type = 'email'
      else
        @type = 'username'
      end

      @frequency = response['response']["frequency"]
      @last_seen = response['response']["lastseen"]
      @appears   = response['response']['appears'] == 'yes' ? true : false
    end
    
    def appears?
      @appears
    end
        
    def self.is_spammer?(id)
      new(id).appears?
    end
    
    private
      def response
        @response ||= self.class.get('/api', :query => {@type.to_sym => @id})
      end
  end
end