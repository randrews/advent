# Encoding: utf-8

s = File.read("1-data.txt")
s = s.split ''
puts(s.count('(') - s.count(')'))

#####

cnt = 0;
floors = []
s.each_with_index{|f,i|
  cnt += (f == '(' ? 1 : -1)
  if cnt== -1
    floors << i+1
  end
}

puts floors.first
