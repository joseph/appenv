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
    source = _compile_source_env
    blk.call(self, source)
  end


  # If you are computing a complex value (say, a conditional one), you might
  # like to set the value via a block. eg:
  #
  #    # Simple variable assignment:
  #    env.var1 = src.var_one
  #
  #    # Variable assignment with `set`:
  #    env.set(:var2) {
  #      if abcd?
  #        'xyz'
  #      else
  #        'foo'
  #      end
  #    }
  #
  def set(property, &blk)
    self.send("#{property}=", blk.call)
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
