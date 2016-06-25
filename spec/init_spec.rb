# encoding: utf-8

require 'spec_helper'
require 'models/projects'
require 'action_control'
require 'vboard_call_controller'

describe Init do

  let(:mock_call) { double 'Call', :to => '1112223333', :from => "2223334444" }
  let(:metadata) { {} }
  subject { Init.new(mock_call, metadata) }

  it "should have empty metadata" do
    subject.metadata.should eq({})
  end

end
