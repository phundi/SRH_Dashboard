class ReportController < ApplicationController
	skip_before_action :verify_authenticity_token
  
	def index 
		@reports = [
				["SRH Report", "/report/srh_report"], 
				["User Audit Report", "/report/user_audit_report"],
				["Report X", "/report/report_x"] 
			]

  end 

  def srh_report
		
		srh_ou_link = YAML.load_file("#{Rails.root}/config/settings.yml")["srh_ou_link"]
		json_data = RestClient::Request.execute(:method => :get, :url => srh_ou_link, :timeout => 1000, :open_timeout => 1000) rescue nil
		@organisation_units = JSON.parse(json_data) rescue []

		@data = JSON.parse(File.read("public/sample_srhr.json"))
		@indicators = @data.keys
		File.delete("srh_report.xlsx") if File.exists? "srh_report.xlsx"
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

				p.serialize('srh_report.xlsx')		
			end
			render :text => true and return
		else

	  	send_file("srh_report.xlsx")
		end		
	end
end

