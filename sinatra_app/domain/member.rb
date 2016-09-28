module Domain
  class Member
  	def self.member_read()
  		csv = CSV.read(
        	'./tables/members/members.csv',
        	headers: true,
        	converters: :numeric
      	)
      	return csv
  	end
  end
end