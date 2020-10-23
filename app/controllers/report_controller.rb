class ReportController < ApplicationController
	skip_before_action :verify_authenticity_token
  
	def index 
		@reports = [
				["SRH Report", "/report/srh_report"], 
				["User Audit Report", "/report/user_audit_report"],
				["Travellers Report", "/report/travellers_report"] 
			]

  end 

  def srh_report
		
		srh_ou_link = YAML.load_file("#{Rails.root}/config/settings.yml")["srh_ou_link"]
		json_data = RestClient::Request.execute(:method => :get, :url => srh_ou_link, :timeout => 1000, :open_timeout => 1000) rescue nil
		@organisation_units = JSON.parse(json_data) rescue []

        mappings =  { "indicator1"=>"Number of migrants,  AYP and SWs reached with SRHR and HIV  Education",
                        "indicator2"=>"Number of migrants, AYP and SWs referred for SRHR -HIV services",
                        "indicator3"=>"Number of migrants, AYP and SWs referred for SRHR-HIV services who received services at the referral destination",
                        "indicator4"=>"Number of individuals referred for HIV testing (subset of total referred)",
                        "indicator5"=>"Number of individuals referred for HIV testing who recieved their HIV test results at the referral destination",
                        "indicator6"=>"Number of individuals referred for ART Treatment (subset of total referred)",
                        "indicator7"=>"Number of individuals referred for ART Treatment who recieved treatment  at the referral destination (subset of total referred and receiving treatment)",
                        "indicator8"=>"Number of individuals referred for antenatal care (subset of total referred)",
                        "indicator9"=>"Number of individuals referred for and received antenatal care  at referral destination  (sub-set of the total antenatal cases identified and referred)",
                        "indicator10"=>"Number of individuals referred for family planning  (subset of total referred)",
                        "indicator11"=>"Number of individuals referred for family planning who receive family planning (FP) services (sub-set of the total FP cases identified and referred)",
                        "indicator12"=>"Number of SGBV survivors identified and referred to service providers for support and protection",
                        "indicator13"=>"Number referred for non-health services ( paralegal, judiciary, social welfare, counsellors, police)",
                        "indicator14"=>"Number of SGBV victims identified and referred to service providers for support and protection who received services at the referral destination (sub-set of the total SGBV cases identified and referred)",
                        "indicator15"=>"Number referred for non-health that receive services at the referral destination ( paralegal, judiciary, social welfare, counsellors, police)"
                  }              
		#@data = JSON.parse(File.read("public/sample_srhr.json"))
		@indicators = mappings.values
		File.delete("srh_report.xlsx") if File.exists? "srh_report.xlsx"
  end

 	def user_audit_report
		
		File.delete("user_audit_report.xlsx") if File.exists? "user_audit_report.xlsx"
	end

	def travellers_report
		
		File.delete("travellers_report.xlsx") if File.exists? "travellers_report.xlsx"
	end

	def ajax_srh_report
		
		srh_report_link = YAML.load_file("#{Rails.root}/config/settings.yml")["srh_report_link"]
		url = srh_report_link + "?user=#{params[:change_agent_name]}&org_unit_id=#{params[:ou_id]}&start_date=#{params[:start_date].to_date.to_s(:db)}&end_date=#{params[:end_date].to_date.to_s(:db)}"
		#url = srh_report_link + "?user=wharry&org_unit_id=n6WeDnrmtBe&start_date=2019-09-01&end_date=2020-09-05"		
		puts url
		json_data = RestClient::Request.execute(:method => :get, :url => url, :timeout => 1000, :open_timeout => 1000)
		File.open("public/sample_srhr.json", "w"){|f| f.write(json_data)}
		render :text => json_data
	end

	def ajax_ou_users
		ca_url = YAML.load_file("#{Rails.root}/config/settings.yml")["srh_users_link"]
		ca_url += "?username=#{params[:username]}&org_id=#{params[:org_id]}"
		
		users = RestClient::Request.execute(:method => :get, :url => ca_url, :timeout => 1000, :open_timeout => 1000)
		render :text => users
	end

	def download_excel
        file_name = "#{params[:ou].gsub(" ","_")}[#{params[:username]}]-SRHR_Report[#{params[:start].to_date.to_s rescue ''}-#{params[:end].to_date.to_s rescue ''}].xlsx"
		if request.post?
			Axlsx::Package.new do |p|

				p.workbook.add_worksheet(:name => "SRHR") do |sheet|

					sheet.add_row ["#", "INDICATOR", "TOTAL"], :style => p.workbook.styles.add_style({:alignment => {:horizontal => :left, :vertical => :center, :wrap_text => true}, 
																																								:b => true, 
																																								:bg_color => "E7E7E7", 
																																								:sz => 13})						
					#Adding data values in sheet
					index = 0
					params[:data].each do |i, d|
						row = i.to_i + 2
						if ["indicator"].include?(d[2])
							index += 1
							sheet.add_row [index, d[0], d[1]], :height => 50, :style => p.workbook.styles.add_style({:alignment => {:horizontal => :left, :wrap_text => true}, 
																																								:b => true, 
																																								:bg_color => "CCCCCC", 
																																								:sz => 12}  )
						elsif ["category"].include?(d[2])
							sheet.add_row ["", d[0], d[1]], :style => p.workbook.styles.add_style({:alignment => {:horizontal => :left, :wrap_text => true}, 
																																								:b => true, 
																																								:bg_color => "E0E9E9", 
																																								:sz => 12}  )

						elsif ["gender"].include?(d[2])
							sheet.add_row ["", d[0], d[1]], :style => p.workbook.styles.add_style({:alignment => {:horizontal => :right, :vertical => :center, :wrap_text => false}, 
																																								:b => true}  )
						else
							sheet.add_row ["", d[0], d[1]], :style => p.workbook.styles.add_style({:alignment => {:horizontal => :right, :vertical => :center, :wrap_text => false}}  )
						end

						col_widths= [nil,100, nil]
						sheet.column_widths *col_widths										
					end											
				end
				p.serialize(file_name)		
			end
			render :text => true and return
		else
	  	send_file(file_name)
		end		
	end

	def download_user_audit_excel
		file_name = "#{params[:ou].gsub(" ","_")}-SRHR_Report[#{params[:start].to_date.to_s rescue ''}-#{params[:end].to_date.to_s rescue ''}].xlsx"
		if request.post?
			Axlsx::Package.new do |p|

				p.workbook.add_worksheet(:name => "User Audit Report") do |sheet|

					sheet.add_row ["#", "USERNAME", "FIRST NAME", "LAST NAME", "MALES", "FEMALES", "TOTAL"], :style => p.workbook.styles.add_style({:alignment => {:horizontal => :left, :vertical => :center, :wrap_text => true}, 
																																								:b => true, 
																																								:bg_color => "E7E7E7", 
																																								:sz => 13})						
					#Adding data values in sheet
					params[:data].each do |index, d|

							sheet.add_row [d[0], d[1], d[2], d[3], d[4], d[5], d[6]], :height => 20, :style => p.workbook.styles.add_style({:alignment => {:horizontal => :left, :wrap_text => true}, 
																																								:sz => 12}  )																
					end											
				end

				p.serialize(file_name)		
			end
			render :text => true and return
		else

	  	send_file(file_name)
		end		
	end

	def ajax_user_audit_report
		
		user_audit_report_link = YAML.load_file("#{Rails.root}/config/settings.yml")["user_audit_link"]
		url = user_audit_report_link + "?org_unit_id=#{params[:ou_id]}&start_date=#{params[:start_date].to_date.to_s(:db)}&end_date=#{params[:end_date].to_date.to_s(:db)}"

		puts url
		json_data = RestClient::Request.execute(:method => :get, :url => url, :timeout => 1000, :open_timeout => 1000)
		render :text => json_data
	end

	def ajax_travellers_report
		
		travellers_link = YAML.load_file("#{Rails.root}/config/settings.yml")["travellers_link"]
		url = travellers_link + "?org_unit_id=#{params[:ou_id]}&start_date=#{params[:start_date].to_date.to_s(:db)}&end_date=#{params[:end_date].to_date.to_s(:db)}"

		#url = "http://dhisforiom.org:3000/api/reports/potential_travellers_report?org_unit_id=n6WeDnrmtBe&start_date=2019-09-01&end_date=2020-09-25"
		puts url
		json_data = RestClient::Request.execute(:method => :get, :url => url, :timeout => 1000, :open_timeout => 1000)

		render :text => json_data
	end

	def download_travellers_excel

		if request.post?
			Axlsx::Package.new do |p|

				p.workbook.add_worksheet(:name => "Travellers Report") do |sheet|

					sheet.add_row ["#", "CATEGORY", "TOTAL"], :style => p.workbook.styles.add_style({:alignment => {:horizontal => :left, :vertical => :center, :wrap_text => true}, 
																																								:b => true, 
																																								:bg_color => "E7E7E7", 
																																								:sz => 13})						
					#Adding data values in sheet
					params[:data].each do |index, d|

							sheet.add_row [d[0], d[1], d[2]], :height => 20, :style => p.workbook.styles.add_style({:alignment => {:horizontal => :left, :wrap_text => true}, 
																																								:sz => 12}  )																
					end	
					
					col_widths= [nil,75, nil]
					sheet.column_widths *col_widths	
				end				

				p.serialize('travellers_report.xlsx')		
			end
			render :text => true and return
		else

	  	send_file("travellers_report.xlsx")
		end		
	end
end

