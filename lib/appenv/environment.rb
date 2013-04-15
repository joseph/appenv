class AppEnv::Environment < ActiveSupport::OrderedOptions

  def initialize(file = '.env', &blk)
    super(&nil)
    @file = file
    source = _compile_source_env
    blk.call(self, source)
  end


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
      return src  unless File.exists?(@file)
      File.open(@file, 'r').each_line { |ln|
        cln = ln.strip.sub(/^export\s+/, '')
        next  if cln.match(/^#/)
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
