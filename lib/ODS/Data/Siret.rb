module ODS::Siret
  DATASET = "sirene@public"

  def self.query(name, zipcode = "")
    if zipcode == ""
      query = {dataset:ODS::Siret::DATASET, q:"nomen_long:" + name}
    else
      query = {dataset:ODS::Siret::DATASET, q:"nomen_long:" + name + " AND codpos:" + zipcode}
    end

    result = HTTParty.get(ODS::ODS_URL, query:query).body
    hash = JSON.parse(result)

    nhits = hash["nhits"]

    response = []

    if nhits > 0
      hash["records"].each do |record|
        name    = record["fields"]["l1_normalisee"]
        address = record["fields"]["l4_normalisee"]
        zipcode = record["fields"]["l6_normalisee"].split(" ", 2)[0]
        city    = record["fields"]["l6_normalisee"].split(" ", 2)[1]
        siret   = record["fields"]["siren"] + record["fields"]["nic"]

        response.push({
          name: name,
          address: address,
          zipcode: zipcode,
          city: city,
          siret: siret
        })
      end
    end

    return JSON.generate({ siret: response })

  end

end
