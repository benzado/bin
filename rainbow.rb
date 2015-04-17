#!/usr/bin/env ruby

# round(36 * (r * 5) + 6 * (g * 5) + (b * 5) + 16)

# green, yellow, orange, red, purple, blue

colors = [
  113,
  113,
  221,
  214,
  203,
  133,
   39,
]

normal = `tput sgr0`

File.open('/etc/motd', 'r') do |f|
  while line = f.gets do
    c = colors.shift || 8
    print `tput setaf #{c}`
    print line.chomp
    puts normal
  end
end
