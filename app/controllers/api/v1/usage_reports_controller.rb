module Api
  module V1

    class UsageReportsController < ApplicationController

      def show
        report = Services.report_generator.get_usage_report(params[:promotion_id], @organization_id, @permissions)
        render json: report 
      end
    end

  end
end