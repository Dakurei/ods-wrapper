require 'ods_wrapper/version'
require 'ods_wrapper/data/Siret'
require 'ods_wrapper/data/MeteoAlert'

require 'json'
require 'httparty'

module OdsWrapper
  ODS_URL= 'https://data.opendatasoft.com/api/records/1.0/search'.freeze
end
