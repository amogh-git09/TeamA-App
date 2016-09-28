module Domain
  class Answer
    def self.nearest_member(questions, answers, members)
      # TODO: いい感じに近いメンバーを計算する
      
      outside_loop_times = answers.length - 1
      inside_loop_times = questions.length - 1

      member_score = [0,0,0,0,0]

      for i in 0..outside_loop_times do
      	for j in 0..inside_loop_times do
      		if answers[i][0] == questions[j][0] then
      			member_score[0] = 4 - ( answers[i][1] - questions[j][2] ).abs + member_score[0]
      			member_score[1] = 4 - ( answers[i][1] - questions[j][3] ).abs + member_score[1]
      			member_score[2] = 4 - ( answers[i][1] - questions[j][4] ).abs + member_score[2]
      			member_score[3] = 4 - ( answers[i][1] - questions[j][5] ).abs + member_score[3]
      			member_score[4] = 4 - ( answers[i][1] - questions[j][6] ).abs + member_score[4]
      		end
      	end
      end

      index = 0
      max_scores = [ member_score[0], member_score[1], member_score[2], member_score[3], member_score[4] ].max
      for i in 0..4 do
      	if max_scores == member_score[i] then
      		break;
      	end
      	index = 1 + index
      end

      return members[index]

    end

    def self.nearest_questions(questions, answers, member_index)
    
      outside_loop_times = answers.length - 1
      inside_loop_times = questions.length - 1

      nearest_questions = []
      nearer_questions = []

      for i in 0..outside_loop_times do
        for j in 0..inside_loop_times do
          if answers[i][0] == questions[j][0] then
            if ( 4 - ( answers[i][1] - questions[j][member_index + 1] ).abs ) == 4 then
              nearest_questions.push(questions[j][1])
            elsif ( 4 - ( answers[i][1] - questions[j][member_index + 1] ).abs ) == 3  then
              nearer_questions.push(questions[j][1])
            end    
          end
        end
      end

      # 距離が0の質問が3以下だったら、距離1の質問をpush
      if nearest_questions.length < 4 then
        times = 4 - nearest_questions.length
        for i in 0..times do
          nearest_questions.push(nearer_questions[i])
        end
      end

      return nearest_questions
    end

    def self.answer_write(question_id, answer, csv_file_name)
      file = File.open('./tables/answers/' + csv_file_name, 'a')
      file.puts question_id + ',' + answer
      file.close
    end

    def self.answer_read(csv_file_name)
      csv = CSV.read(
        './tables/answers/' + csv_file_name,
        headers: true,
        converters: :numeric
      )
    end
  end
end
