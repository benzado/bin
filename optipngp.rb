#!/usr/bin/env ruby
require 'pathname'

OPTIPNG_PATH = '/opt/local/bin/optipng'
CPU_COUNT = 4

list = Array.new

ARGV.each do |arg|
  arg_list = Pathname.glob(arg)
  if arg_list.empty?
    $stderr.puts "warning: no such file '#{arg}'"
    exit 1
  else
    list.concat arg_list
  end
end

$stderr.puts "Optimizing #{list.length} files."

def log(message)
  $stderr.puts "[#{Process.pid}] #{message}"
end

def finish(pid, status, pipe)
  log "child #{pid} exited with status #{status.exitstatus}"
  pipe.each_line do |line|
    $stderr.puts "[#{pid}] #{line}"
  end
  pipe.close
end

children = Hash.new

list.each do |path|
  input, output = IO.pipe
  pid = Process.spawn(OPTIPNG_PATH, '-o7', path.to_s, out: output, err: output)
  output.close
  children[pid] = input
  log "forked child #{pid} to work on #{path}"
  while children.size >= CPU_COUNT
    pid, status = Process.wait2
    finish(pid, status, children.delete(pid))
  end
end

Process.waitall.each do |pid, status|
  finish(pid, status, children.delete(pid))
end

if children.size > 0
  log "weird, children unaccounted for: #{children.inspect}"
end
