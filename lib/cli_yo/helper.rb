module Helper
	def self.consecutive_counter n
		suffix = "th"
		unless (n >= 10 && n <= 20) || n.to_s[-2] == '1'
			if n.to_s[-1] == '1'
				suffix = "st"
			elsif n.to_s[-1] == '2'
				suffix = "nd"
			elsif n.to_s[-1] == '3'
				suffix = 'rd'
			end
		end
		"#{n}-#{suffix}"
	end

	def self.beautiful_sentence arr
		return nil if arr.size == 0
		return arr[0] if arr.size == 1

		str = ""
		for i in 0...(arr.size - 1) do
			str += ", " unless i == 0
			str += "#{arr[i]}"
		end
		str = "#{str} and #{arr.last}"
	end
end