require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "d0d3daee56a2c8ee92e80850cd1d72b3"

get "/" do
  view "ask"
end

get "/news" do
    results = Geocoder.search(params["q"])
    lat_long = results.first.coordinates # => array [lat, long]
    
    #send lat_long to the Dark Sky API. Retrieve the result forecasted weather in a user-friendly format.
    forecast = ForecastIO.forecast(lat_long[0],lat_long[1])
    
    #display the current
    @current_temperature = forecast["currently"]["temperature"]
    @conditions = forecast["currently"]["summary"]
    @location = forecast["timezone"]
       
    view "paper"
    
end
        #forecasted weather in a user-friendly format.
        #<ul> 
         #   <%for days in @forecast["daily"]["data"]%>
          #      <li><% "Expect a high temperature of #{days["temperatureHigh"]}, low of #{days["temeratureLow"]} and #{days["summary"]} conditions"%></li>
           # <%end%>
        #</ul>