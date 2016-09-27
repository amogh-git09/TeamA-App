require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/cross_origin'
require 'json'
require 'active_support/all'

require_relative 'domain/question.rb'
require_relative 'domain/answer.rb'
require_relative 'infra/question.rb'

=begin
before do
  content_type :json
  Dir::chdir(settings.root)
end

configure do
  enable :cross_origin
  enable :logging
  use Rack::CommonLogger, Logger.new("#{settings.root}/log/#{settings.environment}.log", 'daily')
  set :server, :puma
end
=end

not_found do
  {error_code: 404, error_message: 'not found'}.to_json
end

error 500 do
  {error_code: 500, error_message: 'internal server error'}.to_json
end

error 400 do
  {error_code: 400, error_message: 'bad request'}.to_json
end

get '/home' do
  @foo = 'foo'
  erb :home
end

get '/index' do
  content_type 'text/html; charset=utf8'
  erb :index
end

get '/answer' do
  question_id = params['question_id']
  answer = params['answer']
  csv_file_name = params['csv_file_name']
  Domain::Answer.answer_write(question_id, answer, csv_file_name)
end

get '/start' do
  # ユーザーの回答を記録するCSVファイルを作成
  file_number = Dir.glob('./domain/answers/*.csv').count
  csv_file_name = (file_number + 1).to_s + '.csv'
  file_name = './domain/answers/' + csv_file_name
  File.open(file_name,'w'){|file| file = nil}

  content_type 'text/html; charset=utf8'
  user_name = params['user_name']
  score = params['score']
  questions = Infra::Question.all_questions
  @sorted_questions = Domain::Question.sorted(user_name, score, questions)
  @csv_file_name = csv_file_name
  erb :index
  #{questions: sorted_questions.map { |q| q.to_h.slice(:id, :statement)}}.to_json
end

post '/end' do
  begin
    body = JSON.parse request.body.read
  rescue JSON::ParserError => e
    halt 400
  end
  answers = body
  questions = Infra::Question.all_questions
  member_id = Domain::Answer.nearest_member_id(questions, answers)
  member = questions[0].members.find do |member|
    member.id == member_id
  end
  {member: member}.to_json
end

get '/debug' do
  content_type 'text/html; charset=utf8'
  erb :index, layout: false
end
