require "test_helper"

class ODS::WrapperTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ODS::VERSION
  end
end
