require "./spec_helper"

describe SHAInet do
  # TODO: Write tests
  it "check sigmoid" do
    ((0..1).includes?(SHAInet.sigmoid.call(0.5).first)).should eq(true)
  end

  it "check bp_sigmoid" do
    ((-1..1).includes?(SHAInet.bp_sigmoid.call(0.5).first)).should eq(true)
  end

  it "check log_sigmoid" do
    ((0..1).includes?(SHAInet.log_sigmoid.call(0.5).first)).should eq(true)
  end

  it "check tanh" do
    ((-1..1).includes?(SHAInet.tanh.call(0.5).first)).should eq(true)
  end

  it "check relu" do
    ((0..Int64::MAX).includes?(SHAInet.relu.call(0.5).first)).should eq(true)
  end

  it "check l_relu" do
    ((Int64::MIN..Int64::MAX).includes?(SHAInet.l_relu.call(0.5).first)).should eq(true)
  end

  # it "check cross entropy" do
  #   puts SHAInet.cross_entropy_cost(0.0, 1.0)
  # end

  it "check softmax" do
    array = [1, 2, 3, 4]
    sf_array = SHAInet.softmax(array)
    puts sf_array
    puts "Array sum: #{sf_array.sum}"
  end

  it "check log_softmax" do
    puts "log_softmax"
    array = [1, 2, 3, 4]
    sf_array = SHAInet.log_softmax(array)
    puts sf_array
    puts "Array sum: #{sf_array.sum}"
  end
end
