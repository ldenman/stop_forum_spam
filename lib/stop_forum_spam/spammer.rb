module StopForumSpam
  class Spammer   
    class << self
      # Finds the first occurance of a spammer that matches the given id.
      #
      def find(id)
        where(guess_type(id) => id).first
      end

      def guess_type(id)
        return :ip if id.match(/\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/)
        return :email if id.match(/.*@.*/)
        return :username
      end

      # Returns whether a spammer exists in the SFS database by the given id.
      #
      def is_spammer?(id)
        where(guess_type(id) => id).any?
      end

      # Submits a general query to the SFS API using the given parameters and
      # returns an array of Spammers.
      #
      def query(params = {})
        raise ArgumentError.new unless params.is_a?(Hash)

        client = StopForumSpam::Client.new
        response = client.get(:query => params)

        case response['response']['type']
        when Array
          response['response']['type'].length.times.map { |i| from_response(params, response, i) }
        else
          [from_response(params, response)]
        end
      end

      # Queries for spammers that match the given parameters and appear in the
      # SFS database.
      #
      def where(params)
        query(params).select { |spammer| spammer.appears? }
      end

      private

      def from_response(params, response, i = nil)
        response = response['response']

        attributes = [:type, :frequency, :last_seen, :appears].inject({}) do |attributes,name|
          response_name = (name == :last_seen ? :lastseen : name).to_s
          attributes[name] = i ? response[response_name][i] : response[response_name]
          attributes
        end

        # Convert types
        attributes[:appears] = attributes[:appears] == 'yes' ? true : false
        attributes[:frequency] = attributes[:frequency].to_i
        attributes[:last_seen] = Time.parse("#{attributes[:last_seen]} UTC") rescue nil

        new(params[(i ? response['type'][i] : response['type']).to_sym], attributes)
      end
    end

    attr_reader :id, :type, :frequency, :last_seen, :appears

    alias_method :count, :frequency
    alias_method :appears?, :appears

    def initialize(id, attributes = {})
      @id         = id
      @type       = attributes[:type] || self.class.guess_type(id)
      @frequency  = attributes[:frequency] || 0
      @last_seen  = attributes[:last_seen]
      @appears    = attributes[:appears] || false
    end
  end
end
