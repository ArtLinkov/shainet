require "./spec_helper"

# Extract train data
system("cd #{__DIR__}/test_data && tar xvf tests.tar.xz")

describe SHAInet::Data do

  it "can be initialised" do
    data = SHAInet::Data.new_with_csv_input_target(__DIR__ + "/test_data/iris.csv", 0..3, 4)
    data.should be_a(SHAInet::Data)
  end

  it "can be split into a test set and a training set according to a given fraction" do
    data = SHAInet::Data.new_with_csv_input_target(__DIR__ + "/test_data/iris.csv", 0..3, 4)
    training_set, test_set = data.split(0.67)
    training_set.should be_a(SHAInet::TrainingData)
    test_set.should be_a(SHAInet::TestData)
    training_set.data.size.should eq(100)
    test_set.data.size.should eq(50)
  end

  it "can auto-detect labels" do
    data = SHAInet::Data.new_with_csv_input_target(__DIR__ + "/test_data/iris.csv", 0..3, 4)
    data.labels.should eq(["setosa", "versicolor", "virginica"])
  end

end

# Remove train data
system("cd #{__DIR__}/test_data && rm *.csv")
