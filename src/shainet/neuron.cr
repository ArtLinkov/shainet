module SHAInet
  # Each type of neuron uses and propogates data differently
  NEURON_TYPES     = [:memory, :eraser, :amplifier, :fader, :sensor]
  ACTIVATION_TYPES = [:tanh, :sigmoid, :bp_sigmoid, :log_sigmoid, :relu, :l_relu]

  class Neuron
    property :n_type, :synapses_in, :synapses_out, activation : Float64, error : Float64, bias : Float64, prev_bias : Float64
    getter :input_sum, :sigma_prime

    def initialize(@n_type : Symbol)
      raise NeuralNetInitalizationError.new("Must choose currect neuron types, if you're not sure choose :memory as a standard neuron") if NEURON_TYPES.any? { |x| x == @n_type } == false
      @synapses_in = [] of Synapse
      @synapses_out = [] of Synapse
      @error = Float64.new(0)             # Error of the neuron, sometimes refered to as delta
      @bias = rand(-1.0..1.0).to_f64      # Activation threshhold (b)
      @prev_bias = rand(-1.0..1.0).to_f64 # Needed for delta rule improvement
      @activation = Float64.new(0)        # Activation of neuron after squashing function (a)
      @input_sum = Float64.new(0)         # Sum of activations*weights from input neurons (z)
      @sigma_prime = Float64.new(1)       # derivative of input_sum based on activation function used (s')
    end

    # This is the forward propogation
    # Allows the neuron to absorb the activation from its' own input neurons through the synapses
    # Then, it sums the information and an activation function is applied to normalize the data
    def activate(activation_function : Symbol = :sigmoid) : Float64
      raise NeuralNetRunError.new("Propogation requires a valid activation function.") unless ACTIVATION_TYPES.includes?(activation_function)

      new_memory = Array(Float64).new
      @synapses_in.each do |synapse| # Claclulate activation from each incoming neuron with applied weights, returns Array(Float64)
        new_memory << synapse.propagate_forward
      end
      @input_sum = new_memory.reduce { |acc, i| acc + i } # Sum all the information from input neurons, returns Float64
      @input_sum += @bias                                 # Add neuron bias (activation threshold)
      case activation_function                            # Apply squashing function
      when :tanh
        @activation = SHAInet.tanh(@input_sum)
        @sigma_prime = SHAInet.tanh_prime(@input_sum) # Activation function derivative
      when :sigmoid
        @activation = SHAInet.sigmoid(@input_sum)
        @sigma_prime = SHAInet.sigmoid_prime(@input_sum)
      when :bp_sigmoid
        @activation = SHAInet.bp_sigmoid(@input_sum)
      when :log_sigmoid
        @activation = SHAInet.log_sigmoid(@input_sum)
      when :relu
        @activation = SHAInet.relu(@input_sum)
      when :l_relu
        @activation = SHAInet.l_relu(@input_sum, 0.2) # value of 0.2 is the slope for x<0
      else
        raise NeuralNetRunError.new("Propogation requires a valid activation function.")
      end
    end

    # This is the backward propogation of the hidden layers
    # Allows the neuron to absorb the error from its' own target neurons through the synapses
    # Then, it sums the information and a derivative of the activation function is applied to normalize the data
    def hidden_error_prop(activation_function : Symbol = :sigmoid) : Float64
      new_errors = [] of Float64
      @synapses_out.each do |synapse| # Calculate weighted error from each target neuron, returns Array(Float64)
        new_errors << synapse.propagate_backward
      end
      weighted_error_sum = new_errors.reduce { |acc, i| acc + i } # Sum weighted error from target neurons (instead of using w_matrix*delta), returns Float64
      case activation_function                                    # Take into account the derivative of the squashing function
      when :tanh
        @error = weighted_error_sum*@sigma_prime # New error of the neuron
      when :sigmoid
        @error = weighted_error_sum*@sigma_prime
        # when :bp_sigmoid
        #   @error = SHAInet.bp_sigmoid(z)
        # when :log_sigmoid
        #   @error = SHAInet.log_sigmoid(z)
        # when :relu
        #   @error = SHAInet.relu(z)
        # when :l_relu
        #   @error = SHAInet.l_relu(z, 0.2) # value of 0.2 is the slope for x<0
      else
        raise NeuralNetRunError.new("Propogation requires a valid activation function.")
      end
    end

    def inspect
      pp @n_type
      pp @activation
      pp @error
      pp @sigma_prime
      pp @synapses_in
      pp @synapses_out
    end

    def randomize_bias
      @bias = rand(-1.0..1.0).to_f64
    end

    def update_bias(value : Float64)
      @bias = value
    end
  end
end
