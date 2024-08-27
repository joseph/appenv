class AppEnv::Environment < ActiveSupport::OrderedOptions

  def initialize(file = '.env', &blk)
    super(&nil)
    @file = file
    expand(&blk)
  end


  # You can use `expand` to add more values to the environment after
  # initialization. eg:
  #
  #    # Create the environment:
  #    @env = AppEnv::Environment.new('test/data/env') { |env, src|
  #      env.var1 = src.var_one
  #    }
  #
  #    # Later, expand it:
  #    @env.expand { |env, src|
  #      env.var2 = src.var_two
  #    }
  #
  def expand(&blk)
    @source = _compile_source_env
    blk.call(self, @source)
  end


  # If you are computing a complex value (say, a conditional one), you might
  # like to set the value via a block. eg:
  #
  #    # Simple variable assignment:
  #    env.var1 = src.var_one
  #
  #    # Variable assignment with a block:
  #    env.set(:var2) {
  #      if abcd?
  #        'xyz'
  #      else
  #        'foo'
  #      end
  #    }
  #
  def set(property, value = nil)
    self[property] = block_given? ? yield : value
  end


  # Creates a property in the env, taking the value from the source hash.
  # If you want to modify the value from the source before setting it in
  # the env, supply a block that takes the src value and returns the env value.
  #
  # Options:
  # * :from -- if the source property name differs, supply it
  # * :required -- raise an error if the property is not assigned a value
  #
  def apply(property, options = {})
    if options.kind_of?(String) || options.kind_of?(Symbol)
      options = { :from => options }
    end
    val = @source[options[:from] || property]
    self[property] = block_given? ? yield(val) : val
    assert(property)  if options[:required]
    self[property]
  end


  # Collect all the source properties that match the pattern as a hash.
  # If a block is given, yield the hash to the block, which can modify values.
  # Then merge the hash into the env.
  #
  def splat(pattern)
    hash = ActiveSupport::OrderedOptions.new
    @source.each_pair { |k, v| hash[k] ||= v  if k.to_s.match(pattern) }
    yield(hash)  if block_given?
    self.update(hash)
  end


  # After setting all the environment properties, assert which
  # properties should exist. The Configurator will raise an
  # exception listing the missing properties, if any.
  #
  def assert(*properties)
    missing = properties.collect { |prop|
      prop.to_s.upcase  unless self[prop]
    }.compact
    raise("AppEnv requires #{missing.join(', ')}")  if missing.any?
  end


  # Collect a line-by-line list of strings in the form: 'property = value'.
  #
  def to_a
    collect { |k, v| "#{k} = #{v.inspect}" }
  end


  # Print a line-by-line list of env values to STDOUT.
  #
  def print(pad = '')
    puts pad+to_a.join("\n"+pad)
  end


  private

    def _compile_source_env
      src = ActiveSupport::OrderedOptions.new
      _source_env_from_file.each_pair { |k, v| src[k] = v; src[k.downcase] = v }
      ENV.each_pair { |k, v| src[k] = v; src[k.downcase] = v }
      src
    end


    def _source_env_from_file
      src = {}
      return src  unless File.exist?(@file)
      File.open(@file, 'r').each_line { |ln|
        cln = ln.strip.sub(/^export\s+/, '')
        next  if cln.match(/^#/)
        next  if cln.empty?
        if m = cln.match(/\A([A-Za-z_0-9]+)=(.*)\z/)
          k = m[1]
          v = m[2]
          if v =~ /\A'(.*)'\z/
            v = $1
          elsif v =~ /\A"(.*)"\z/
            v = $1.gsub(/\\(.)/, '\1')
          end
          src[k] = v
        else
          raise ".env parse error: #{ln}"
        end
      }
      src
    end

end
