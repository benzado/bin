#!/usr/bin/env ruby

# Invoke like:
#
# $ git ls-files -z '*.[hmc]' | xargs -0 trim-whitespace.rb
#

def detect_eol(file)
  sample = file.read(128)
  file.rewind

  return nil if sample.nil?

  return nil if sample.start_with?("%PDF".b,
                                   "\x89PNG\r\n".b,
                                   "\xFF\xFE".b,
                                   "\xFE\xFF".b)
  
  iCR = sample.bytes.index(13)
  iLF = sample.bytes.index(10)

  if iCR && iLF
    return "\r\n" if iCR + 1 == iLF
  else
    return "\n" if iLF
    return "\r" if iCR
  end

  return nil
end

def clean_path(path)
  buffer = String.new
  File.open(path, 'rb') do |file|
    eol = detect_eol(file)
    return nil if eol.nil?
    non_blank_length = 0
    file.each_line(eol) do |line|
      s = line.sub(/[[:space:]]+$/m, "\n")
      buffer.concat(s)
      non_blank_length = buffer.length if s != "\n"
    end
    buffer.slice!(non_blank_length..buffer.length)
    buffer if buffer.length != file.pos
  end
end

def main(args)
  should_save_changes = false

  args.each do |path|
    if path == "-i"
      should_save_changes = true
      next
    end
    text = clean_path(path)
    if text
      if should_save_changes
        File.open(path, "w") do |file|
          file.write(text)
        end
        $stderr.puts "#{path}: cleaned"
      else
        $stderr.puts "#{path}: dirty"
      end
    # else
    #   $stderr.puts "#{path}: clean"
    end
  end
end

main(ARGV)
