module Infra
  require 'csv'
  class Question
    def self.all_questions
      member = Struct.new(:id, :name, :score)
      question = Struct.new(:id, :statement, :is_odd, :members)

      csv = CSV.read(
        './infra/questions.csv',
        headers: true,
        converters: :numeric
      )
      member_names = csv.headers[2..6]

      csv.map do |row|
        members = member_names.each_with_index.map do |name, i|
          member.new(i+1, name, row[name])
        end
        question.new(row['id'], row['質問文'], row['変わった質問かどうか'], members)
      end
    end
  end
end
