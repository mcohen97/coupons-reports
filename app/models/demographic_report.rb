class DemographicReport

  def initialize(counts_by_country, counts_by_city, counts_by_age)
    @countries = create_cities_and_countries_section(counts_by_country, counts_by_city)
    @ages = create_ages_section(counts_by_age)
  end

private

  def create_cities_and_countries_section(counts_by_country, counts_by_city)
    index = {}
    counts_by_country.each do |record|
      index[record.country.name] = {count: record.count, cities: {}}
    end
    counts_by_city.each do |record|
      index[record.city.country.name][:cities][record.city.name] = {count: record.count}
    end
    return index
  end

  def create_ages_section(counts_by_age)
    index = {}
    counts_by_age.each do |age|
      index["#{age.age_range.from}-#{age.age_range.to}"] = {count: age.count}
    end
    return index
  end

end