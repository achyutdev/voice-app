# encoding: utf-8

require 'spec_helper'
require 'models/projects'
require 'models/questions'
require 'models/child_questions'
# require 'models/responses'
require 'models/answers'

describe ActionControl do

  let(:mock_call) { double 'Call', :to => '1112223333', :from => "2223334444" }
  let(:metadata) { {} }
  subject { ActionControl.new(mock_call, metadata) }

  it "should have empty metadata" do
    subject.metadata.should eq({})
  end

end
