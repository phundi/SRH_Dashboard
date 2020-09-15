class ReportController < ApplicationController
  def index 
		@reports = [
				["SRH Report", "/report/srh_report"], 
				["User Audit Report", "/report/user_audit_report"],
				["Report X", "/report/report_x"] 
			]

  end 

  def srh_report
		

		@indicators = ["Number of trained  change agents SRHR-HIV amongst non migrants,  migrants, AYP and SWs", 
									"Indicator 2", "Indicator 3", "Indicator 4", "Indicator 5", "Indicator 6", "Indicator 7"]
		@age_break_down = {
												"10-14" => 0,
												"15-19"	=> 0,
												"20-24"	=> 0,
												"25-29" => 0,
												"30-34" => 0,
												">=34"  => 0
											}

		@breakdown  = {
										"Host Community (Total)" => {
																					"Male" => @age_break_down,
																					"Female" => @age_break_down
																			},
										"Migrants (Total)" => {
																					"Male" => @age_break_down,
																					"Female" => @age_break_down
																			},
										"Sex Workers (Total)" => {
																					"Male" => @age_break_down,
																					"Female" => @age_break_down
																			}
									}
  end
end
