require 'sinatra'
require 'json'
require 'faker'
require 'SecureRandom'

set :port, 9123

get '/training_sessions' do
  content_type :json
  dateRequested = params['date']
  typeOfTraining = ['easy', 'longRun', 'tempoRun', 'interval', 'fartlek']
  timeOfDay = ['AM', 'PM']
  numOfSessions = Faker::Number.between(0, 2)
  sessions = { :trainingSessions => [] }
  startCount = 0
  loop do
    break if startCount >= numOfSessions
    startCount += 1
    sessions[:trainingSessions].append({
                                         :id => SecureRandom.uuid,
                                         :date => dateRequested,
                                         :type => typeOfTraining[Faker::Number.between(0, 4)],
                                         :distanceInKm => Faker::Number.between(1, 20),
                                         :timeOfDay => timeOfDay[Faker::Number.between(0, 1)],
                                         :coachComments => Faker::ChuckNorris.fact
                                       })
  end
  sessions.to_json
end

put '/training_sessions/:id' do
  puts "TrainingSession Updated - #{params['id']}"
  request.body.rewind
  training_session_params = JSON.parse(request.body.read)
  puts training_session_params.inspect
  status 201
  body ''
end