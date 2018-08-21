require 'sinatra'
require 'json'

set :port, 9123

get '/training_sessions' do
  content_type :json
  dateRequested = params['date']
  training_sessions = { :trainingSessions => [
    {
      :date => dateRequested,
      :type => 'easy',
      :distanceInKm => 10,
      :timeOfDay => 'AM',
      :coachComments => 'stubbed coach comments'
    }
  ] }.to_json
  puts training_sessions
  training_sessions
end