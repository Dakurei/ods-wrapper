require 'ods_wrapper/version'
require 'ods_wrapper/data/siret'
require 'ods_wrapper/data/meteo_alert'

require 'json'
require 'httparty'

module OdsWrapper
  ODS_URL= 'https://data.opendatasoft.com/api/records/1.0/search'.freeze
end
