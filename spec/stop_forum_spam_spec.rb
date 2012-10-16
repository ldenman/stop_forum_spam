require 'spec_helper'

describe StopForumSpam::Client do

  context "a new client" do
    it "should instantiate" do
      StopForumSpam::Client.new.class.should == StopForumSpam::Client
    end

    it "should initialize with an optional api key" do
      client = StopForumSpam::Client.new('123456789')
      client.api_key.should == '123456789'
    end
  end
  
  context 'posts a spammer' do
    context 'with a valid ip address, email address, and username' do
      before do
        fake_post_response('123456789', '127.0.0.1', 'spammer%40ru.com', 'spammer500', :body => "valid post")
        client = StopForumSpam::Client.new('123456789')
        @response = client.post(:id_address => '127.0.0.1', :email => 'spammer@ru.com', :username => 'spammer500')
      end
    
      it "should return true " do
        @response.should be_true
      end
    end
  end
end
