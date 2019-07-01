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

    result = HTTParty.get(OdsWrapper::ODS_URL, query:query).body
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

    result = HTTParty.get(OdsWrapper::ODS_URL, query:query).body
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

      name    = fields.dig('denominationunitelegale')? fields.dig('denominationunitelegale') : fields.dig('nomunitelegale') + ' ' + fields.dig('prenom1unitelegale')
      address = fields.dig('adresseetablissement')
      zipcode = fields.dig('codepostaletablissement')
      city    = fields.dig('libellecommuneetablissement')
      siret   = fields.dig('siret')
      ape     = fields.dig('activiteprincipaleunitelegale').gsub('.', '')

      response.push({
        name:    name,
        address: address,
        zipcode: zipcode,
        city:    city,
        siret:   siret,
        ape:     ape
      })
    end

    return response
  end

end
