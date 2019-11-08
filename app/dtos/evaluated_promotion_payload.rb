class EvaluatedPromotionPayload
  attr_reader :total_discounted, :city, :country, :response_time, :birthdate

  def initialize(data)
    result = data['result']
    @applicable = result['applicable']
    @total_discounted = result['total_discounted']
    @response_time = result['response_time']
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

end