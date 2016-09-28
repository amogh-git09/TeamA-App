module Domain
  class Question
    def self.sorted(darts_score, questions)
      # TODO: いい感じに並べ替える

      darts_score = darts_score.to_i
      random_questions = questions.sort_by{rand}

      if 100 <= darts_score then
      	darts_score = 100
      elsif darts_score < 10
      	darts_score = 10
      end
      
      question_number = 10
      eccentric_question_number = (darts_score / 10).floor # * 2
      normal_question_number = question_number - eccentric_question_number
     
      sorted_questions = []
      eccentric_question_count = 0
      normal_question_count = 0      

      random_questions.map do |row|
      	question = [row['id'],row['質問文']]
      	if row['変わった質問かどうか'] == 1 && eccentric_question_count < eccentric_question_number then
      		sorted_questions.push( question )
      		eccentric_question_count = 1 + eccentric_question_count
      	elsif row['変わった質問かどうか'] == 0 && normal_question_count < normal_question_number then
      		sorted_questions.push( question ) 	 
      		normal_question_count = 1 + normal_question_count
      	end

      	if question_number <= eccentric_question_count + normal_question_count then
      		break;
      	end
      	
      end


      
      return sorted_questions
    end
  end
end
