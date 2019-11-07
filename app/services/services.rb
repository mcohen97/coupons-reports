class Services

  def self.report_generator
    @services ||= services
    @services[:report_generator]
  end

  def self.report_data_calculator
    @services ||= services
    @services[:report_data_calculator]
  end

  def self.services
    report_data_calculator = ReportDataCalculator.new()
    report_generator = ReportGenerator.new()

    { report_generator: report_generator,
      report_data_calculator: report_data_calculator }
  end
end