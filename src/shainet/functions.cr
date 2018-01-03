module SHAInet
  # # Activation functions # #

  def self.sigmoid(value : GenNum) : Float64 # Output range (0..1)
    (1.0/(1.0 + Math::E**(-value))).to_f64
  end

  def self.bp_sigmoid(value : GenNum) : Float64 # Output range (-1..1)
    ((1.0 - Math::E**(-value))/(1.0 + Math::E**(-value))).to_f64
  end

  def self.log_sigmoid(value : GenNum) : Float64 # Output range (0..1)
    ((Math::E**(value))/(1.0 + Math::E**(value))).to_f64
  end

  def self.tanh(value : GenNum) : Float64 # Output range (-1..1)
    ((Math::E**(value) - Math::E**(-value))/(Math::E**(value) + Math::E**(-value))).to_f64
  end

  def self.relu(value : GenNum) # Output range (0..inf)
    if value < 0
      (0).to_f64
    else
      value.to_f64
    end
  end

  def self.l_relu(value : GenNum, slope : Float64 = 0.01) : Float64 # Output range (-inf..inf)
    if value < 0
      slope.to_f64*value.to_f64
    else
      value.to_f64
    end
  end

  # # Derivatives of activation functions # #

  def self.sigmoid_prime(value : Float64) : Float64
    sigmoid(value)*(1.0 - sigmoid(value)).to_f64
  end

  def self.bp_sigmoid_prime(value : Float64) : Float64
    (2*Math::E**(value)/(Math::E**(value) + 1)**2).to_f64
  end

  def self.log_sigmoid_prime(value : Float64) : Float64
    (Math::E**(value)/(Math::E**(value) + 1)**2).to_f64
  end

  def self.tanh_prime(value : Float64) : Float64
    (1.0 - tanh(value)**2).to_f64
  end

  def self.relu_prime(value : GenNum) : Float64
    if value < 0
      (0).to_f64
    else
      (1).to_f64
    end
  end

  def self.l_relu_prime(value : GenNum, slope : Float64 = 0.01) : Float64
    if value < 0
      slope
    else
      (1).to_f64
    end
  end

  ##################################################################

  # # Cost functions  # #

  def self.quadratic_cost(expected : Float64, actual : Float64) : Float64
    return (0.5*(actual - expected)**2).to_f64
  end

  def self.cross_entropy_cost(expected : Float64, actual : Float64) : Float64
    # Cost function =
    return ((-1)*(expected*Math.log((actual), Math::E) + (1.0 - expected)*Math.log((1.0 - actual), Math::E))).to_f64
  end

  # # Derivatives of cost functions # #

  def self.quadratic_cost_derivative(expected : Float64, actual : Float64) : Float64
    return (actual - expected).to_f64
  end

  def self.cross_entropy_cost_derivative(expected : Float64, actual : Float64) : Float64
    if actual == expected == 0.0 || actual == expected == 1.0
      a = 0.0
    elsif actual == 0.0 && expected != 0.0
      a = -1.0
    else
      a = ((actual - expected)/((1.0 - actual)*actual)).to_f64
    end
    # puts a
    return a
  end

  ##################################################################

  # # Linear algebra math # #

  # vector elment-by-element multiplication
  def self.vector_mult(array1 : Array(GenNum), array2 : Array(GenNum))
    raise MathError.new("Vectors must be the same size to multiply!") if array1.size != array2.size

    new_vector = [] of Float64
    (0..array1.size - 1).each do |x|
      result = array1[x]*array2[x]
      new_vector << result
    end
    new_vector
  end

  # vector elment-by-element multiplication
  def self.vector_sum(array1 : Array(Float64), array2 : Array(Float64))
    raise MathError.new("Vectors must be the same size to sum!") if array1.size != array2.size

    new_vector = [] of Float64
    (0..array1.size - 1).each do |x|
      result = array1[x] + array2[x]
      new_vector << result
    end
    new_vector
  end

  def self.dot_product(m1 : Array(Array(GenNum)), m2 : Array(Array(GenNum)))
    out_matrix = [] of Array(Float64)
    m2 = m2.transpose
    m1.each do |v1|
      new_row = [] of Float64
      m2.each do |v2|
        new_vector = vector_mult(v1, v2)
        new_row << new_vector.reduce { |acc, i| acc + i }
      end
      out_matrix << new_row
    end
    out_matrix
  end

  ##################################################################

  # # Data manipulation # #

  # translate an array of strings to one-hot vector matrix and hash dictionary
  def self.normalize_stcv(payloads : Array(String))
    s = payloads.max_by &.size # Find biggest string, all strings will be padded to its' size
    input_size = s.size
    payloads_c = Array(Array(String)).new
    payloads_v = Array(Array(Array(Int32))).new
    vocabulary = [] of String
    vocabulary_v = Hash(String, Array(Int32)).new

    # Split payloads and update vocabulary
    payloads.each do |str|
      x = str.split("")

      # add new unique chars to vocabulary
      x.each { |char| vocabulary << char }

      # save strings as arrays of chars
      payloads_c << x
    end

    # create hash of char-to-vector (vector size = all possible chars)
    vocabulary.uniq!
    (0..vocabulary.size - 1).each do |x|
      char_v = Array(Int32).new
      (0..vocabulary.size - 1).each do |i|
        if i == x
          char_v << 1
        else
          char_v << 0
        end
      end
      vocabulary_v[vocabulary[x]] = char_v
    end
    zero_v = Array.new(vocabulary.size) { |i| 0 }

    # Translate the strings into arrays of char-vectors
    payloads_c.each do |str|
      str_v = Array(Array(Int32)).new
      str.each { |char| str_v << vocabulary_v[char] }
      payloads_v << str_v
    end

    # Pad all string vectors with 0 vectors for uniform input size
    payloads_v.each do |str|
      while str.size < input_size
        str << zero_v
      end
    end

    return input_size, vocabulary_v, payloads_v
  end

  ##################################################################

  # # Other # #

  # Used in Rprop
  def self.sign(input : GenNum)
    if input > 0
      return +1
    elsif input < 0
      return -1
    else
      return 0
    end
  end

  def self.softmax
    # TODO
  end
end
