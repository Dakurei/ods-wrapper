module OdsWrapper::MeteoAlert
  DATASET = 'risques-meteorologiques-copy@public'.freeze

  def self.query(dep = '')
    if dep == ''
      query = {
        dataset: OdsWrapper::MeteoAlert::DATASET,
        q: '',
        rows: 10000
      }
    else
      query = {
        dataset: OdsWrapper::MeteoAlert::DATASET,
        q: "dep:#{dep}",
        rows: 10000
      }
    end

    response = HTTParty.get(OdsWrapper::ODS_URL, query:query)
    return JSON.generate( { error: 'Server temporarily inaccessible' } ) if response.code >= 500 && response.code <= 599

    result = response.body
    hash   = JSON.parse(result)

    if (hash.dig('nhits') || 0) > 0
      response = format_response(hash)
    else
      response = []
    end

    return JSON.generate({ meteo_alert: response })
  end

  private

  def self.format_response(hash)
    response = []

    hash['records'].each do |record|
      fields = record['fields']

      dep_code       = fields.dig('dep')
      dep_name       = fields.dig('nom_dept')
      reg_name       = fields.dig('nom_reg')
      deadline       = fields.dig('echeance')
      start_date     = fields.dig('daterun')
      predicted_date = fields.dig('dateprevue')
      comment        = fields.dig('vigilancecommentaire_texte')
      tips           = fields.dig('vigilanceconseil_texte')

      wind_state         = fields.dig('etat_vent')
      rain_flood_state   = fields.dig('etat_pluie_inondation')
      flood_state        = fields.dig('etat_inondation')
      thunderstorm_state = fields.dig('etat_orage')
      snow_state         = fields.dig('etat_neige')
      hot_state          = fields.dig('etat_canicule')
      cold_state         = fields.dig('etat_grand_froid')
      avalanche_state    = fields.dig('etat_avalanches')
      wave_state         = fields.dig('etat_vague_submersion')

      response.push({
        dep_code:       dep_code,
        dep_name:       dep_name,
        reg_name:       reg_name,
        deadline_hour:  deadline,
        start_date:     start_date,
        predicted_date: predicted_date,
        comment:        comment,
        tips:           tips,
        states: {
          wind: wind_state,
          rain_flood: rain_flood_state,
          flood: flood_state,
          thunderstorm: thunderstorm_state,
          snow: snow_state,
          hot: hot_state,
          cold: cold_state,
          avalanche: avalanche_state,
          wave: wave_state
        }
      })
    end

    return response
  end

end
