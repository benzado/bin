#!/usr/bin/env ruby

if ARGV.length < 3
  $stderr.puts "Usage: rgb-to-xterm256.rb R G B"
  $stderr.puts "where {R,G,B} are values in the range 0-255"
  exit 1
end

r, g, b = ARGV.map(&:to_f).map { |n| n / 255.0 }

# Green:  94 182 77  => 113
# Yellow: 253 181 51 => 221
# Orange: 252 129 39 => 214
# Red:    228 62 62  => 203
# Purple: 151 71 149 => 133
# Blue:   26 161 219 =>  39

code = (16 + (36 * (6*r).to_i) + ( 6 * (6*g).to_i) + (     (6*b).to_i))

tput_setaf = `tput setaf #{code}`
tput_setab = `tput setab #{code}`
tput_sgr0  = `tput sgr0`

puts "R=#{r} G=#{g} B=#{b}"
puts "Color Code: #{code}"
puts "#{tput_setaf}Foreground Color#{tput_sgr0}"
puts "#{tput_setab}Background Color#{tput_sgr0}"
