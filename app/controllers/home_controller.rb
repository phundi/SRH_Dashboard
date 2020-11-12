class HomeController < ApplicationController
  def index 
      url ="http://dhisforiom.org:3000/api/reports/fetch_dashboard_data/"
      #json_data = RestClient::Request.execute(:method => :get, :url => url, :timeout => 1000, :open_timeout => 1000) rescue nil
      #@data = JSON.parse(json_data)
		
    end

 def connection_status
    radius = {}
    #min_radius = 0.25
    #max_radius = 1

    data = YAML.load_file "#{Rails.root}/public/sites_data.yml"

    #population = []
    #data.each do |site, site_data|
     # population << (site_data["count"] rescue 0)
    #end
    #population = population.compact
    connections = {}
    durations = {}

    data.each do |site, site_data|
			#next if site_data["#{params[:prefix]}ping"].blank?
      connections["#{site}"] = site_data["#{params[:prefix]}ping"] rescue false
      durations["#{site}"] = ((Time.now - site_data["#{params[:prefix]}ping_timestamp"].to_time)/60).round.to_s rescue nil

      count = (site_data["count"] rescue 0).to_f
      r = Math.sqrt(count)*(1/Math.sqrt(10000))
      #r = ((population.percentile_rank(count)/100)*(max_radius - min_radius) + min_radius).round(2)
      radius["#{site}"] = [r, count]

    end

    render :text => [connections, durations, radius].to_json
  end

  def connection_lastseen_status

    data = YAML.load_file "#{Rails.root}/public/sites_data.yml"

    connections = {}
    data.each do |site, site_data|

      next if site_data['ping_timestamp'].blank?
      months_diff = ((Time.now - site_data['ping_timestamp'].to_time)/(60*60*24*30)).to_i
      days_diff = ((Time.now - site_data['ping_timestamp'].to_time)/(60*60*24)).to_i
      hrs_diff = ((Time.now - site_data['ping_timestamp'].to_time)/(60*60)).to_i
      min_diff = ((Time.now - site_data['ping_timestamp'].to_time)/(60)).to_i
      sec_diff = (Time.now - site_data['ping_timestamp'].to_time).to_i

      if months_diff > 0
          last_seen = "#{months_diff} months ago"
      elsif days_diff > 0
          last_seen = "#{days_diff} days ago"
      elsif hrs_diff > 0
        last_seen = "#{hrs_diff} hr ago"
      elsif min_diff > 0
        last_seen = "#{min_diff} min ago"
      else
        last_seen = "#{sec_diff.abs} sec ago"
      end

      connections["#{site}"] = last_seen
    end

    render :text => [connections].to_json
  end
end
