class ReportDataCalculator

  def initialize
  end

  def create_promotions_report(promotion_id, organization_id)
    UsageReport.create!(promotion_id: promotion_id)
    PromotionOrganization.create!(promotion_id:promotion_id, organization_id: organization_id)
    create_age_ranges(promotion_id)
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.warn(e.message)
  end

  def update_promotion_report(evaluated_promo_info, promotion_id, organization_id)
    update_usage_report(evaluated_promo_info, promotion_id, organization_id)
    if evaluated_promo_info.demographic_data_provided()
      update_country_report(evaluated_promo_info.country, promotion_id) if evaluated_promo_info.provides_country?
      update_city_report(evaluated_promo_info.city, evaluated_promo_info.country , promotion_id) if evaluated_promo_info.provides_country_and_city?
      update_age_report(evaluated_promo_info.birthdate, promotion_id) if evaluated_promo_info.provides_birthdate?
    end
  end

private

  def create_age_ranges(promotion_id)
    ranges = AgeRange.all
    ranges.each do |range|
      puts 'creo edades'
      CountByAgeRange.create!(promotion_id: promotion_id, age_range_id: range.id)
    end
  end

  def update_country_report(country_name, promotion_id)
    puts country_name
    record = CountByCountry.includes(:country).where(:countries => {name: country_name},promotion_id: promotion_id).first
 
    if record.nil?
      # first time promotion is evaluated from that country
      country = get_country(country_name)
      CountByCountry.create(promotion_id: promotion_id, country_id: country.id, count: 1)
    else
      increment_count(record)
    end
  end

  def update_city_report(city, country_name, promotion_id)
    record = CountByCity.includes(city: :country).where(promotion_id: promotion_id, :cities => {name: city, :countries => {name: country_name}}).first
    if record.nil?
      # first time promotion is evaluated from the country
      country = get_country(country_name)
      new_city = City.create!(name: city, country_id: country.id)
      CountByCity.create(promotion_id: promotion_id, city_id: new_city.id, count: 1)
    else
      increment_count(record)
    end
  end

  def get_country(country_name)
    country =  Country.where(name: country_name).first
    if country.nil?
      country = Country.create!(name: country_name)
    end
    return country
  end

  def update_age_report(birth_date, promotion_id)
    age = get_age(birth_date)
    record = CountByAgeRange.includes(:age_range).where(promotion_id: promotion_id, :age_ranges => {from: -Float::INFINITY..(age -1), to: age..Float::INFINITY}).first
    increment_count(record)
  end

  def update_usage_report(evaluated_promo_info, promotion_id, organization_id)
    record = UsageReport.where(promotion_id: promotion_id).first

    if record.nil?
      record = create_promotions_report(promotion_id,organization_id)
    end

    new_invocations_count = record.invocations_count + 1

    if !evaluated_promo_info.applicable
        # if rejected, increment negative responses
        record.negative_responses_count += 1
    end

    puts record.inspect
    puts record.invocations_count
    puts record.average_response_time
    puts evaluated_promo_info.inspect
    
    # update response time
    new_average_response_time = ((record.invocations_count * record.average_response_time) + evaluated_promo_info.response_time)/ new_invocations_count
    record.average_response_time = new_average_response_time

    # update invocations count
    record.invocations_count = new_invocations_count

    # update total money spent
    record.total_money_spent += evaluated_promo_info.total_discounted

    #commit to database
    record.save!
  end

  def get_age(birth_date)
    now = Time.now.utc.to_date
    date = Date.parse(birth_date)
    puts date.inspect
    now.year - date.year - ((now.month > date.month || (now.month == date.month && now.day >= date.day)) ? 0 : 1)
  end
  
  def increment_count(record)
    record.update(count: (record.count + 1))
  end

end