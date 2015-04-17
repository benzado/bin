#!/usr/bin/env ruby
require 'pathname'
require 'sqlite3'

WORDS_SOURCE_PATH = Pathname.new('/usr/share/dict/words')
WORDS_CACHE_PATH = Pathname.new(ENV['HOME']).join('Library/Caches/com.benzado.random-words.db')

# conditionally rebuild

db = SQLite3::Database.new(WORDS_CACHE_PATH.to_path)
db.execute %Q[
  CREATE TABLE IF NOT EXISTS words (
    word TEXT NOT NULL,
    length INT NOT NULL
  );
  CREATE INDEX IF NOT EXISTS words_length ON words (length);
]

count = db.get_first_value 'SELECT COUNT(*) FROM words'

if count.nil? or count == 0
  last_status_time = Time.now
  insert = db.prepare 'INSERT INTO words VALUES (:w, LENGTH(:w))'
  total_size = WORDS_SOURCE_PATH.size.to_f / 100.0
  WORDS_SOURCE_PATH.open('r') do |file|
    while line = file.gets
      word = line.chomp
      insert.execute!(w: word)
      count += 1
      if (Time.now - last_status_time) > 1
        $stderr.printf "\rBuilding index (%4.1f%%)", (file.pos.to_f / total_size)
        last_status_time = Time.now
      end
    end
    $stderr.puts "...Done"
  end
end

select = db.prepare 'SELECT word FROM words WHERE length = 5 ORDER BY RANDOM() LIMIT ?'
select.execute!((ARGV.last || 1).to_i).each do |word|
  $stdout.puts word
end

# select = db.prepare 'SELECT word FROM words WHERE rowid = ?'
# (ARGV.last || 1).to_i.times do
#   word = select.execute!(1 + rand(count)).first
#   $stdout.puts word
# end
