module ODS::Siret
  DATASET = "sirene@public"

  def self.query(name, zipcode = "")
    if zipcode == ""
      query = {dataset:ODS::Siret::DATASET, q:"nomen_long:" + name}
    else
      if zipcode.size == 2
        query = {dataset:ODS::Siret::DATASET, q:"nomen_long:" + name + " AND depet:" + zipcode}
      else
        query = {dataset:ODS::Siret::DATASET, q:"nomen_long:" + name + " AND codpos:" + zipcode}
      end
    end

    result = HTTParty.get(ODS::ODS_URL, query:query).body
    hash = JSON.parse(result)

    nhits = hash["nhits"]

    response = []

    if nhits > 0
      hash["records"].each do |record|
        name    = record["fields"]["l1_normalisee"]
        address = record["fields"]["l4_normalisee"]
        if !record["fields"]["l6_normalisee"].nil?
          zipcode = record["fields"]["l6_normalisee"].split(" ", 2)[0]
          city    = record["fields"]["l6_normalisee"].split(" ", 2)[1]
        else
          zipcode = ""
          city    = ""
        end
        siret   = record["fields"]["siren"] + record["fields"]["nic"]
        ape     = record["fields"]["apen700"]

        response.push({
          name: name,
          address: address,
          zipcode: zipcode,
          city: city,
          siret: siret,
          ape: ape
        })
      end
    end

    return JSON.generate({ siret: response })

  end

end
