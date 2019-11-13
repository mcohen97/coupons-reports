require './lib/error/promotion_not_found_error.rb'
require './lib/error/not_authorized_error.rb'

class ReportGenerator

  USAGE_REPORT_PERMISSIONS = ['GET_USAGE_REPORT']
  DEMOGRAPHIC_REPORT_PERMISSIONS = ['GET_DEMOGRAPHIC_REPORT']
  
  def get_usage_report(promotion_id, organization_id, permissions)

    check_organization(promotion_id, organization_id)
    check_permissions(permissions, USAGE_REPORT_PERMISSIONS)

    metadata = UsageReport.where(promotion_id: promotion_id).first

    if metadata.nil?
      raise PromotionNotFoundError
    end

    total_invocations = metadata[:invocations_count]
    positive_responses_count = total_invocations - metadata[:negative_responses_count]
    positive_response_ratio = total_invocations > 0 ? (positive_responses_count / total_invocations) : 0.0
    negative_response_ratio = total_invocations > 0 ? (metadata[:negative_responses_count] / total_invocations) : 0.0

    report = UsageReportDto.new(invocations_count: metadata.invocations_count, negative_response_ratio: negative_response_ratio, 
      positive_response_ratio: positive_response_ratio, average_response_time: metadata[:average_response_time], 
      last_time_updated: metadata[:updated_at], total_money_spent: metadata[:total_money_spent])

    return report
  end

  def get_demographic_report(promotion_id, organization_id, permissions)

    check_organization(promotion_id, organization_id)
    check_permissions(permissions, DEMOGRAPHIC_REPORT_PERMISSIONS)

    by_country = CountByCountry.includes(:country).where(promotion_id: promotion_id)
    by_city = CountByCity.includes(:city).where(promotion_id: promotion_id)
    by_age_range = CountByAgeRange.includes(:age_range).where(promotion_id: promotion_id)
    
    return DemographicReport.new(by_country, by_city, by_age_range)
  end

private

  def check_organization(promotion_id, organization_id)
    promo = PromotionOrganization.find_by(promotion_id: promotion_id)
    if promo.nil?
      raise PromotionNotFoundError
    end
    if promo.organization_id != organization_id
      raise NotAuthorizedError, "You can't access other organizations promotions' reports"
    end
  end

  def check_permissions(user_permissions, permissions_required)

    authorized = (permissions_required - user_permissions).empty?

    unless authorized
      raise NotAuthorizedError, "You don't have permissions to access this service"
    end
  end

end