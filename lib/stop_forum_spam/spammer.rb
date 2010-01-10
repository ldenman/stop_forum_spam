module StopForumSpam
  class Spammer   
    attr_reader :id, :type, :frequency, :last_seen, :appears
    
    alias_method :count, :frequency
    alias_method :appears?, :appears
    
    def initialize(id)
      @id         = id
      @type       = self.class.guess_type(id)
      @frequency  = response["frequency"]
      @last_seen  = response["lastseen"]
      @appears    = response['appears'] == 'yes' ? true : false
    end
    
    def self.is_spammer?(id)
      new(id).appears?
    end

    def self.guess_type(id)
      return 'ip' if id.match(/\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/)
      return 'email' if id.match(/.*@.*/)
      return 'username'
    end
    
    private  
      def response
        @response ||= make_request['response']
      end
      def make_request
        client = StopForumSpam::Client.new
        client.get(:query => {@type.to_sym => @id})
      end
  end
end