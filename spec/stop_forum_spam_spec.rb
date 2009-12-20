require 'spec_helper'

describe StopForumSpam::Spammer do
  FakeWeb.allow_net_connect = false

  it "should initialize a spammer by ip" do
    fake_get_response("ip=127.0.0.1")
    spammer = StopForumSpam::Spammer.new('127.0.0.1')
    spammer.type.should == 'ip'
  end

  it 'should initialize a spammer by email' do
    fake_get_response("email=test%40tester.com")
    spammer = StopForumSpam::Spammer.new('test@tester.com')
    spammer.type.should == 'email'
  end

  it 'should initialize a spammer by username' do
    fake_get_response("username=testuser")
    spammer = StopForumSpam::Spammer.new('testuser')
    spammer.type.should == 'username'
  end

  it 'should have attributes from the response' do
    last_seen = "2009-04-16 23:11:19"
    fake_get_response("ip=127.0.0.1", :last_seen => last_seen, :appears => true)
    spammer = StopForumSpam::Spammer.new('127.0.0.1')
    spammer.type.should == "ip"
    spammer.appears?.should be_true
    spammer.last_seen.should == last_seen
  end

  context '#count' do
    it 'should count the amount of times the spammer has been added' do
      fake_get_response("ip=127.0.0.1", :frequency => 41)
      spammer = StopForumSpam::Spammer.new('127.0.0.1')
      spammer.count.should == '41'
    end
  end

  it 'should have an id' do
    fake_get_response("ip=127.0.0.1")
    spammer = StopForumSpam::Spammer.new('127.0.0.1')
    spammer.id.should == '127.0.0.1'
  end

  it "should find a spammer by ip" do
    fake_get_response("ip=127.0.0.1", :appears => true)
    StopForumSpam::Spammer.is_spammer?("127.0.0.1").should be_true
  end

  it "should return false when the spammer is not found by ip" do
    fake_get_response("ip=127.0.0.1", :appears => false)
    StopForumSpam::Spammer.is_spammer?('127.0.0.1').should be_false
  end

  it "should find a spammer by email" do
    fake_get_response("email=test%40tester.com", :appears => true)
    StopForumSpam::Spammer.is_spammer?("test@tester.com").should be_true
  end

  it "should return false when a spammer is not found by email" do
    fake_get_response("email=test%40tester.com", :appears => false)
    StopForumSpam::Spammer.is_spammer?('test@tester.com').should be_false
  end

  it "should find a spammer by username" do
    fake_get_response("username=testuser", :appears => true)
    StopForumSpam::Spammer.is_spammer?('testuser').should be_true
  end

  it "should return false when a spammer is not found by username" do
    fake_get_response("username=testuser", :appears => false)
    StopForumSpam::Spammer.is_spammer?('testuser').should be_false
  end

  context '#guess_type' do
    it 'should return the ip type' do
      StopForumSpam::Spammer.guess_type('127.0.0.1').should == "ip"
    end

    it 'should return the email type ' do
      StopForumSpam::Spammer.guess_type('test@testuser.com').should == "email"
    end

    it 'should return the username type' do
      StopForumSpam::Spammer.guess_type("testuser").should == 'username'
    end
  end
  
end