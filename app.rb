require 'sinatra'

get '/' do
  <<-HTML
    <h1>Welcome!</h1>
    <p><a href="/track">Go to JD Sports</a></p>
  HTML
end

get '/track' do
  ip = request.ip
  puts "User clicked the link from IP: #{ip}"
  redirect 'https://www.jdsports.com'
end
