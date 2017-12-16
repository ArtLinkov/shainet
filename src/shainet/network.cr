module SHAInet
  class NeuralNet
    # property :
    getter :synapses

    def initialize(input_size : Int32, hidden_layers : Array(Int32), output_size : Int32)
      raise NeuralNetInitalizationError.new("Cannot initialize a network without hidden layers") if hidden_layers.empty?
      @input_layer = Array(Neuron).new(input_size, Neuron.new)
      @output_layer = Array(Neuron).new(output_layer, Neuron.new)
      @hidden_layers = Array(Layer).new
      hidden_layer.each do |l|
        @hidden_layer << Array(Neuron).new(l, Neuron.new)
      end
      @synapses = Array(Synapse).new
    end

    def inspect
      p @input_layer
      p @hidden_layer
      p @output_layer
      p @synapses
    end

    def randomize_all_wights
      @synapses.each &.randomize_weight
    end

    def fully_connect
      # Fully connect Input to first Hidden layer
      @input_layer.each do |master_neuron|
        @hidden_layer.first.each do |slave_neuron|
          synapse = Synapse.new(master_neuron, slave_neuron, 0.0.to_f64)
          @synapses << synapse
        end
      end
      # Fully connect Hidden Layers
      @hidden_layer.each_with_index do |layer, index|
        break if (index + 1) >= @hidden_layer.size
        layer.each do |master_neuron|
          @hidden_layer[index + 1].each do |slave_neuron|
            synapse = Synapse.new(master_neuron, slave_neuron, 0.0.to_f64)
            @synapses << synapse
          end
        end
      end
      # Fully connect last hidden layer to output layer
      @hidden_layer.last.each do |master_neuron|
        @output_layer.each do |slave_neuron|
          synapse = Synapse.new(master_neuron, slave_neuron, 0.0.to_f64)
          @synapses << synapse
        end
      end
    end
  end
end
