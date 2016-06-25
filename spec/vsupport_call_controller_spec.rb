# encoding: utf-8

require 'spec_helper'
require 'models/vsupports'

describe VsupportCallController do

  let(:mock_call) { double 'Call', :to => '1112223333', :from => "2223334444" }
  let(:metadata) { {} }
  subject { VsupportCallController.new(mock_call, metadata) }

  it "should have empty metadata" do
    subject.metadata.should eq({})
  end

end
