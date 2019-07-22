require "test_helper"

class OdsWrapper::OdsWrapperTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::OdsWrapper::VERSION
  end

  def test_ods_url_present
    refute_nil ::OdsWrapper::ODS_URL
  end
end
