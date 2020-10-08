class ReportController < ApplicationController
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
					sheet.add_row ["#", "INDICATOR", "TOTAL"]													
				end

				p.serialize('srh_report.xlsx')		
			end

			#render file
		end
	end
end

