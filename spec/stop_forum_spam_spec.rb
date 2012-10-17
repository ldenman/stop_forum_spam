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
  
  describe "#post" do
    subject { client.post(parameters) }

    let(:client) { StopForumSpam::Client.new('123456789') }

    context 'with a valid ip address, email address, and username' do
      let(:parameters) { {:ip_address => '127.0.0.1', :email => 'spammer@ru.com', :username => 'spammer500'} }

      before(:each) do
        fake_post_response('123456789', '127.0.0.1', 'spammer%40ru.com', 'spammer500', :body => "valid post")
      end

      it { should be_true }
    end

    context "without an ip address" do
      let(:parameters) { {:email => 'spammer@ru.com', :username => 'spammer500'} }

      it("raises") { expect { subject }.to raise_error(StopForumSpam::IncompleteSubmission) }
    end

    context "without a username" do
      let(:parameters) { {:ip_address => '127.0.0.1', :email => 'spammer@ru.com'} }

      it("raises") { expect { subject }.to raise_error(StopForumSpam::IncompleteSubmission) }
    end

    context "without an email address" do
      let(:parameters) { {:username => 'spammer500', :ip_address => '127.0.0.1'} }

      it("raises") { expect { subject }.to raise_error(StopForumSpam::IncompleteSubmission) }
    end
  end
end
