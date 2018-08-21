require 'sinatra'
require 'json'
require 'faker'

set :port, 9123

get '/training_sessions' do
  content_type :json
  dateRequested = params['date']
  typeOfTraining = ['easy', 'longRun', 'tempoRun', 'interval', 'fartlek']
  timeOfDay = ['AM', 'PM']
  numOfSessions = Faker::Number.between(0,2)
  sessions = { :trainingSessions => []}
  startCount = 0
  loop do
    break if startCount >= numOfSessions
    startCount += 1
    sessions[:trainingSessions].append({
                                         :date => dateRequested,
                                         :type => typeOfTraining[Faker::Number.between(0,4)],
                                         :distanceInKm => Faker::Number.between(1, 20),
                                         :timeOfDay => timeOfDay[Faker::Number.between(0,1)],
                                         :coachComments => Faker::ChuckNorris.fact
                                       })
  end
  sessions.to_json
end