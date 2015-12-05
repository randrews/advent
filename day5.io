Regex

f := File with("5-data.txt")
f openForReading

matches := method(str, regex,
  count := (regex asRegex) matchesIn(str) count;
  if(count == nil, 0, count)
)

isNice := method(str,
  3vowels := matches(str, "[aeiou]") >= 3;
  repeated := matches(str, "(.)\\1") > 0;
  forbidden := matches(str, "(ab)|(cd)|(pq)|(xy)") > 0;

  3vowels and repeated and (forbidden not)
)

isNice2 := method(str,
  repeats := matches(str, "(.).\\1") > 0;
  pairs := matches(str, "(..).*\\1") > 0;

  repeats and pairs
)

niceCount := 0
nice2Count := 0
while(line := f readLine,
  if(isNice(line), niceCount := niceCount+1);
  if(isNice2(line), nice2Count := nice2Count+1)
)

writeln("Part 1: ", niceCount)
writeln("Part 2: ", nice2Count)