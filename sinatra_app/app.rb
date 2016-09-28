require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/cross_origin'
require 'json'
require 'active_support/all'

require_relative 'domain/question.rb'
require_relative 'domain/answer.rb'
require_relative 'domain/member.rb'
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
  erb :home
end

get '/answer' do
  question_id = params['question_id']
  answer = params['answer']
  csv_file_name = params['csv_file_name']
  Domain::Answer.answer_write(question_id, answer, csv_file_name)
end

get '/start' do
  # ユーザーの回答を記録するCSVファイルを作成
  file_number = Dir.glob('./tables/answers/*.csv').count
  csv_file_name = (file_number + 1).to_s + '.csv'
  file_name = './tables/answers/' + csv_file_name
  file = File.open(file_name,'w') do |f|
    f.puts('id, answer')
  end

  content_type 'text/html; charset=utf8'
  darts_score = params['darts_score']
  questions = Infra::Question.read_questions_csv

  @sorted_questions = Domain::Question.sorted(darts_score, questions)
  @csv_file_name = csv_file_name

  erb :index
  #{questions: sorted_questions.map { |q| q.to_h.slice(:id, :statement)}}.to_json
end

get '/result' do
  csv_file_name = params['csv_file_name']
  answers = Domain::Answer.answer_read(csv_file_name)
  members = Domain::Member.member_read()
  questions = Infra::Question.read_questions_csv
  @nearest_member = Domain::Answer.nearest_member(questions, answers, members)
  @nearest_questions = Domain::Answer.nearest_questions(questions, answers, @nearest_member[0])
  
  erb :result
end



get '/debug' do
  content_type 'text/html; charset=utf8'
  erb :index, layout: false
end
