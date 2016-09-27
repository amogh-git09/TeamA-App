module Domain
  class Answer
    def self.nearest_member_id(questions, answers)
      # TODO: いい感じに近いメンバーを計算する
      
    end
    def self.answer_write(question_id, answer, csv_file_name)
      file = File.open('./domain/answers/' + csv_file_name, 'a')
      file.puts question_id + ',' + answer
      file.close
    end
  end
end
