module OdsWrapper::Siret
  DATASET = 'sirene_v3@public'.freeze

  def self.query(name, zipcode = '')
    base_query = "etatadministratifetablissement:Actif AND (denominationunitelegale:#{name} OR nomunitelegale:#{name})"

    if zipcode == ''
      query = {
        dataset: OdsWrapper::Siret::DATASET,
        q: base_query,
        rows: 25
      }
    else
      if zipcode.size == 2
        query = {
          dataset: OdsWrapper::Siret::DATASET,
          q: "#{base_query} AND codedepartementetablissement:#{zipcode}",
          rows: 25
        }
      else
        query = {
          dataset: OdsWrapper::Siret::DATASET,
          q: "#{base_query} AND codepostaletablissement:#{zipcode}",
          rows: 25
        }
      end
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

    return JSON.generate({ siret: response })
  end

  def self.reverse_query(siret)
    query = {
      dataset: OdsWrapper::Siret::DATASET,
      q: "siret:#{siret}"
    }

    response = HTTParty.get(OdsWrapper::ODS_URL, query:query)
    return JSON.generate( { error: 'Server temporarily inaccessible' } ) if response.code >= 500 && response.code <= 599

    result = response.body
    hash   = JSON.parse(result)

    if (hash.dig('nhits') || 0) > 0
      response = format_response(hash)
    else
      response = []
    end

    return JSON.generate({ siret: response })
  end

  private

  def self.format_response(hash)
    response = []

    hash['records'].each do |record|
      fields = record['fields']

      # Fetched
      name    = fields.dig('denominationunitelegale')? fields.dig('denominationunitelegale') : "#{fields.dig('nomunitelegale')} #{fields.dig('prenom1unitelegale')}".strip
      address = fields.dig('adresseetablissement')
      zipcode = fields.dig('codepostaletablissement')
      city    = fields.dig('libellecommuneetablissement')
      siret   = fields.dig('siret')
      siren   = fields.dig('siren')
      ape     = fields.dig('activiteprincipaleunitelegale').gsub('.', '')
      geo     = fields.dig('geolocetablissement')

      # Calculated
      vat     = (siren)? 'FR' + ( ( 12 + 3 * ( siren.to_i % 97 ) ) % 97 ).to_s.rjust(2, '0') + siren : ''

      response.push({
        name:    name,
        address: address,
        zipcode: zipcode,
        city:    city,
        siret:   siret,
        siren:   siren,
        ape:     ape,
        vat:     vat,
        geo:     geo
      })
    end

    return response
  end

end
