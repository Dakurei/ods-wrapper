module ODS::Siret
  DATASET = 'sirene_v3@public'.freeze

  def self.query(name, zipcode = '')
    base_query = "etatadministratifetablissement:Actif AND (denominationunitelegale:#{name} OR nomunitelegale:#{name})"

    if zipcode == ''
      query = {
        dataset: ODS::Siret::DATASET,
        q: base_query
      }
    else
      if zipcode.size == 2
        query = {
          dataset: ODS::Siret::DATASET,
          q: "#{base_query} AND codedepartementetablissement:#{zipcode}"
        }
      else
        query = {
          dataset: ODS::Siret::DATASET,
          q: "#{base_query} AND codepostaletablissement:#{zipcode}"
        }
      end
    end

    result = HTTParty.get(ODS::ODS_URL, query:query).body
    hash   = JSON.parse(result)

    nhits = hash.dig('nhits') || 0

    response = []

    if nhits > 0
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
    end

    return JSON.generate({ siret: response })
  end

end
