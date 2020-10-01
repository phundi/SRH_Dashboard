class ReportController < ApplicationController
  def index 
		@reports = [
				["SRH Report", "/report/srh_report"], 
				["User Audit Report", "/report/user_audit_report"],
				["Report X", "/report/report_x"] 
			]

  end 

  def srh_report
		
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

		@data = JSON.parse(File.read("public/sample_srhr.json"))
		@indicators = @data.keys
  end

	def ajax_srh_report
		
		srh_report_link = YAML.load_file("#{Rails.root}/config/settings.yml")["srh_report_link"]
		url = srh_report_link + "?user=wharry&org_unit_id=n6WeDnrmtBe&start_date=2019-09-01&end_date=2020-09-05"
		puts url
		json_data = RestClient::Request.execute(:method => :get, :url => url, :timeout => 1000, :open_timeout => 1000)
		#File.open("public/sample_srhr.json", "w"){|f| f.write(json_data)}
		render :text => json_data
	end
end
