class ModuleController < ApplicationController

  def view_module

    @client = Client.find(params[:client_id])
    @client_type = ClientType.find(@client.client_type_id).name
    @trail_label = "Patient #{params[:module]} History"

    @common_encounters = []
    @common_encounters << ['Presenting Complaints', "2", "complaints/#{@client.id}"]
    @common_encounters << ['Vitals', "34", "vitals/#{@client.id}"]
    @common_encounters << ['Diagnosis', '4', "diagnosis/#{@client.id}"]
    @common_encounters << ['Prescribe Drugs', '4', "prescribe/#{@client.id}"]
    @common_encounters << ['Dispense Drugs', '23', "dispense/#{@client.id}"]

    @data = [{
                 "title"   => "Vitals",
                 "content" => "Temperature: 39 oC, Height: 165cm, BP: 66/98 - <span class='cost'>K90</span>",
                 "data"    => [["Temperature Reading", "Value1"], ["Drug2", "Value 2 pills"], ["Concept1", "Value1"], ["Drug2", "Value 2 pills"]],
                 "date"    => 9.days.ago.strftime("%Y-%b-%d  &nbsp; %H:%M"),
                 "user"    => "Test User"
             },

             {
                 "title"   => "Dispensation",
                 "content" => "29 tabs Paracetamol, 2 Inject DCN - <span class='cost'>K1200</span>",
                 "data"    => [["Concept1", "Value1"], ["Drug2", "Value 2 pills"]],
                 "date"    => 7.days.ago.strftime("%Y-%b-%d &nbsp; %H:%M"),
                 "user"    => "Test User"
             }].sort_by{|h| h['date']}
  end
end