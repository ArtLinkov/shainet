require "./spec_helper"

describe SHAInet::Neuron do
  puts "############################################################"
  it "Initialize neuron" do
    puts "\n"
    neuron = SHAInet::Neuron.new("memory")
    neuron.should be_a(SHAInet::Neuron)
  end
end
