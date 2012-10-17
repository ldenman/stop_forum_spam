require 'spec_helper'

describe StopForumSpam::Spammer do
  FakeWeb.allow_net_connect = false
  
  describe ".new" do
    subject { StopForumSpam::Spammer.new(id, attributes) }

    let(:attributes) { {} }

    context "where id is an ip" do
      let(:id) { '127.0.0.1' }

      it { should be_a(StopForumSpam::Spammer) }
      its(:id) { should == id }
      its(:type) { should == :ip }
    end

    context "where id is an email address" do
      let(:id) { 'a@bad.example' }

      it { should be_a(StopForumSpam::Spammer) }
      its(:id) { should  == id }
      its(:type) { should == :email }
    end

    context "where id is a username" do
      let(:id) { 'spammer' }

      it { should be_a(StopForumSpam::Spammer) }
      its(:id) { should == id }
      its(:type) { should == :username }
    end
  end

  describe ".find" do
    subject { StopForumSpam::Spammer.find(id) }

    before(:each) { fake_get_response(type => id, :appears => appears) }

    context "given an ip address" do
      let(:id) { '127.0.0.1' }
      let(:type) { :ip }

      context "that appears in the database" do
        let(:appears) { true }

        it { should be_a(StopForumSpam::Spammer) }
        its(:id) { should == '127.0.0.1' }
        its(:type) { should == :ip }
      end

      context "that does not appear in the database" do
        let(:appears) { false }

        it { should be_nil }
      end
    end
  end

  describe ".query" do
    subject { StopForumSpam::Spammer.query(parameters) }

    before(:each) do
      fake_get_response(parameters.map { |(n,v)| {n => v}.merge(:appears => appears) })
    end

    context "given a single parameter" do
      let(:parameters) { {:ip => '127.0.0.1'} }

      context "that does not appear in the database" do
        let(:appears) { false }

        it { should_not be_empty }
      end

      context "that does appear in the database" do
        let(:appears) { true }

        it { should_not be_empty }
      end
    end

    context "given more than one parameter" do
      let(:parameters) { {:ip => '127.0.0.1', :email => 'a@bad.example'} }
      let(:appears) { true }

      it { should_not be_empty }
      its(:length) { should be > 1 }
    end
  end

  describe '#count' do
    it 'should count the amount of times the spammer has been added' do
      fake_get_response(:ip => '127.0.0.1', :frequency => 41, :appears => true)
      spammer = StopForumSpam::Spammer.find('127.0.0.1')
      spammer.count.should == 41
    end
  end

  it "should find a spammer by ip" do
    fake_get_response(:ip => '127.0.0.1', :appears => true)
    StopForumSpam::Spammer.is_spammer?("127.0.0.1").should be_true
  end

  it "should return false when the spammer is not found by ip" do
    fake_get_response(:ip => '127.0.0.1', :appears => false)
    StopForumSpam::Spammer.is_spammer?('127.0.0.1').should be_false
  end

  it "should find a spammer by email" do
    fake_get_response(:email => 'test@tester.com', :appears => true)
    StopForumSpam::Spammer.is_spammer?("test@tester.com").should be_true
  end

  it "should return false when a spammer is not found by email" do
    fake_get_response(:email => 'test@tester.com', :appears => false)
    StopForumSpam::Spammer.is_spammer?('test@tester.com').should be_false
  end

  it "should find a spammer by username" do
    fake_get_response(:username => 'testuser', :appears => true)
    StopForumSpam::Spammer.is_spammer?('testuser').should be_true
  end

  it "should return false when a spammer is not found by username" do
    fake_get_response(:username => 'testuser', :appears => false)
    StopForumSpam::Spammer.is_spammer?('testuser').should be_false
  end

  context '#guess_type' do
    it 'should return the ip type' do
      StopForumSpam::Spammer.guess_type('127.0.0.1').should.eql? "ip"
    end

    it 'should return the email type ' do
      StopForumSpam::Spammer.guess_type('test@testuser.com').should.eql? "email"
    end

    it 'should return the username type' do
      StopForumSpam::Spammer.guess_type("testuser").should.eql? 'username'
    end
  end
  
end
