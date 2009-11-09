require 'spec_helper'

describe StopForumSpam::Spammer do
  
  it "should initialize a spammer by ip" do
    FakeWeb.register_uri(:get, "http://stopforumspam.com/api?username=127.0.0.1", 
      :string => "<response success='true'><type>ip</type><appears>yes</appears><frequency>10</frequency></response>")
    spammer = StopForumSpam::Spammer.new('127.0.0.1')
  end
  
  it 'should initialize a spammer by email' do
    FakeWeb.register_uri(:get, "http://stopforumspam.com/api?username=test@tester.com", 
      :string => "<response success='true'><type>email</type><appears>yes</appears><frequency>10</frequency></response>")
    spammer = StopForumSpam::Spammer.new('test@tester.com')
    spammer.type.should == 'email'
  end
  
  it 'should initialize a spammer by username' do
    FakeWeb.register_uri(:get, "http://stopforumspam.com/api?username=testuser", 
      :string => "<response success='true'><type>username</type><appears>yes</appears><frequency>10</frequency></response>")
    spammer = StopForumSpam::Spammer.new('testuser')
    spammer.type.should == 'username'
  end
  
  it 'should have attributes from the response' do
    FakeWeb.register_uri(:get, "http://stopforumspam.com/api?ip=127.0.0.1", 
      :string => "<response success='true'><type>ip</type><appears>yes</appears><lastseen>2009-04-16 23:11:19</lastseen><frequency>41</frequency></response>")
    spammer = StopForumSpam::Spammer.new('127.0.0.1')
    spammer.type.should == "ip"
    spammer.appears?.should be_true
    spammer.last_seen.should == "2009-04-16 23:11:19"
    spammer.frequency == '41'
  end
  
  it 'should have an id' do
    FakeWeb.register_uri(:get, "http://stopforumspam.com/api?ip=127.0.0.1", 
      :string => "<response success='true'><type>ip</type><appears>yes</appears><lastseen>2009-04-16 23:11:19</lastseen><frequency>41</frequency></response>")
    spammer = StopForumSpam::Spammer.new('127.0.0.1')
    spammer.id.should == '127.0.0.1'
  end
  
  it "should find a spammer by ip" do
    FakeWeb.allow_net_connect = false
    FakeWeb.register_uri(:get, "http://stopforumspam.com/api?ip=127.0.0.1", 
      :string => "<response success='true'><type>ip</type><appears>yes</appears><lastseen>2009-04-16 23:11:19</lastseen><frequency>41</frequency></response>")
    StopForumSpam::Spammer.is_spammer?("127.0.0.1").should be_true
  end
  
  it "should return false when the spammer is not found by ip" do
    FakeWeb.register_uri(:get, "http://stopforumspam.com/api?ip=127.0.0.1", 
      :string => "<response success='true'><type>ip</type><appears>no</appears><frequency>0</frequency></response>")
    StopForumSpam::Spammer.is_spammer?('127.0.0.1').should be_false
  end
  
  it "should find a spammer by email" do
    FakeWeb.register_uri(:get, "http://stopforumspam.com/api?email=test%40tester.com", 
      :string => "<response success='true'><type>email</type><appears>yes</appears><lastseen>2009-06-25 00:24:29</lastseen><frequency>2</frequency></response>")
    StopForumSpam::Spammer.is_spammer?("test@tester.com").should be_true
  end
  
  it "should return false when a spammer is not found by email" do
    FakeWeb.register_uri(:get, "http://stopforumspam.com/api?email=test%40tester.com", 
      :string => "<response success='true'><type>email</type><appears>no</appears><frequency>0</frequency></response>")
    StopForumSpam::Spammer.is_spammer?('test@tester.com').should be_false
  end
  
  it "should find a spammer by username" do
    FakeWeb.register_uri(:get, "http://stopforumspam.com/api?username=testuser", 
      :string => "<response success='true'><type>username</type><appears>yes</appears><frequency>10</frequency></response>")
    StopForumSpam::Spammer.is_spammer?('testuser')
  end
  
  it "should return false when a spammer is not found by username" do
    FakeWeb.register_uri(:get, "http://stopforumspam.com/api?username=testuser", 
      :string => "<response success='true'><type>username</type><appears>no</appears><frequency>0</frequency></response>")
    StopForumSpam::Spammer.is_spammer?('testuser')
  end  
end