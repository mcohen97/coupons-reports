module Api
  module V1

    class DemographicReportsController < ApplicationController

      def show
        report = Services.report_generator.get_demographic_report(params[:promotion_id], @organization_id, @permissions)
        render json: report 
      end
    end
    
  end
end
