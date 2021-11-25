#!/usr/bin/env ruby

$stderr.puts "^D to exit"

while line = $stdin.gets
  /([[:alpha:]]{3}) +(\d{1,2}), +(\d{4})/.match(line) do |m|
    @month = %w[Nil
                Jan Feb Mar
                Apr May Jun
                Jul Aug Sep
                Oct Nov Dec].index(m[1])
    @day = m[2].to_i
    @year = m[3].to_i
    # puts m.inspect
    # puts "#{m.to_s} => #{@year}-#{@month}-#{@day}"
  end
  /(\d{1,2}):(\d\d)/.match(line) do |m|
    @hour = m[1].to_i
    @minute = m[2].to_i
    s = m.to_s
    t = Time.local(@year, @month, @day, @hour, @minute)
    puts "#{s} => #{t} => #{t.to_i}"
  end
  # /\d{10}/.match(line) do |m|
    # s = m.to_s
    # t = Time.at(s.to_i)
    # puts "#{s} => #{t} / #{t.utc}"
  # end
end
