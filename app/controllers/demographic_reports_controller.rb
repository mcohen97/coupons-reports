class DemographicReportsController < ApplicationController

  def show
    puts "organization id #{@organization_id}"
    report = Services.report_generator.get_demographic_report(params[:promotion_id], @organization_id)
    render json: report 
  end
end
