require './lib/error/invalid_promotion_data_error.rb'


class EvaluatedPromotionPayload
  attr_reader :total_discounted, :city, :country, :response_time, :birthdate

  def initialize(data)
    set_result_data(data)
    demographic = data['demographic_data']
    unless demographic.nil?
      @birthdate = demographic['birthdate']
      @city = demographic['city']
      @country = demographic['country']
    end
  end

  def applicable
    return @applicable.nil? ? false : @applicable
  end

  def provides_country_and_city?
    !@country.nil? && !@city.nil?
  end

  def provides_country?
    !@country.nil?
  end

  def provides_birthdate?
    !@birthdate.nil?
  end  

  def demographic_data_provided
    return !@birthdate.nil? && !@city.nil? && !@country.nil?
  end

private 

  def set_result_data(data)

    if data.nil?
      raise InvalidPromotionDataError, 'Promotion data missing'
    end

    result = data['result']

    if result.nil?
      raise InvalidPromotionDataError, 'The "result" section is nil'
    end

    @applicable = result['applicable']
    @total_discounted = result['total_discounted']
    @response_time = result['response_time']

    if @applicable.nil? && @total_discounted.nil? && @response_time.nil?
      missing_fields = ''
      missing_fields += 'applicable ' if @applicable.nil?
      missing_fields += 'total_discounted ' if @total_discounted.nil?
      missing_fields += 'response_time ' if @response_time.nil?

      raise InvalidPromotionDataError, "The following result fields are missing: #{missing_fields}"
    end

  end

end