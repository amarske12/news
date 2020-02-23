require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "d0d3daee56a2c8ee92e80850cd1d72b3"

# news API key

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
    @forecast = forecast["daily"]["data"]   
    
   
    # news is now a Hash you can pretty print (pp) and parse for your output
    url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=8a141cb88eb549ffa3ca0be56acf1321"
    news = HTTParty.get(url).parsed_response.to_hash

    @headlines = news["articles"]
    
    view "paper"
end
        