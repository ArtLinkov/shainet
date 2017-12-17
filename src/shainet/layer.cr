module SHAInet
  class Layer
    property :n_type, :neurons, :memory_size

    def initialize(@n_type : Symbol, l_size : Int32, @memory_size : Int32 = 1)
      @neurons = Array(Neuron).new
      l_size.times do
        @neurons << Neuron.new(@n_type, @memory_size)
      end
    end

    # If you don't want neurons to have a blank memory of zeros
    def random_seed
      @neurons.each do |neuron|
        neuron.memory = Array(Float64).new(memory_size) { |i| rand(-1.0..1.0) }
      end
      puts "Layers seeded with random values"
    end

    # If you want to change the memory size of all neurons in a layer
    def memory_change(new_memory_size : Int32)
      @neurons.each do |neuron|
        neuron.memory = Array(Float64).new(new_memory_size) { |i| 0.0 }
      end
      puts "Memory size changed from #{@memory_size} to #{new_memory_size}"
      @memory_size = new_memory_size
    end

    # If you want to change the type of layer including all neuron types within it
    def type_change(new_neuron_type : Symbol)
      raise NeuralNetInitalizationError.new("Must define correct neuron type, if you're not sure choose :memory as a default") if NEURON_TYPES.any? { |x| x == new_neuron_type } == false
      @neurons.each { |neuron| neuron.n_type = new_neuron_type }
      puts "Layer type chaged from #{@n_type} to #{new_neuron_type}"
      @n_type = new_neuron_type
    end

    def inspect
      pp @n_type
      pp @memory_size
      pp @neurons
    end
  end
end
