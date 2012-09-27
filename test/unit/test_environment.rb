require 'test_helper'

class AppEnv::TestEnvironment < Test::Unit::TestCase

  def test_sanity
    assert_nothing_raised {
      @env = AppEnv::Environment.new('test/data/env') { |env, src|
        env.var1 = src.var_one
        env.set(:var2) { src.var_two }
        env.var3 = src.var_three || 'grault'
      }
    }
    assert_equal('foo', @env.var1)
    assert_equal('bar', @env.var2)
    assert_equal('grault', @env.var3)
  end

end
