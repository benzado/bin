#!/usr/bin/env ruby

# copylefter.rb
# Copyright 2015 by Benjamin Ragheb
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

PROGRAM_NAME = 'CanOpener'
COPYRIGHT_YEAR = '2015'
COPYRIGHT_HOLDER = 'Benjamin Ragheb'

require 'pathname'
require 'term/ansicolor'

include Term::ANSIColor

IGNORED_TYPES = %w[
  .css
  .html
  .json
  .md
  .pbxproj
  .plist
  .png
  .sql
  .strings
  .txt
  .xcodeproj
  .xcworkspace
  .xib
  .xsl
]

SLASH_STYLE_TYPES = %w[
  .c
  .cpp
  .h
  .js
  .m
  .pch
  .swift
]

HASH_STYLE_TYPES = %w[
  .pl
  .rb
  .sh
]

COPYRIGHT_NOTICE = %Q[This file is part of #{PROGRAM_NAME}.

#{PROGRAM_NAME} is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

#{PROGRAM_NAME} is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with #{PROGRAM_NAME}.  If not, see <http://www.gnu.org/licenses/>.
]

def copyleft_slash_style(path)
  new_content = String.new
  created_by = nil
  path.open('r') do |file|
    header_block_line_count = 0
    while (line = file.gets) =~ %r{^//}
      /Created by .+ on .+\./.match(line) { |m| created_by = m[0].to_s }
      header_block_line_count += 1
    end
    if header_block_line_count == 0
      $stderr.puts red("#{path}: no header block found")
      return
    end
    new_content  = "/*\n"
    new_content << " * #{path.basename}\n"
    new_content << " * #{created_by}\n" if created_by
    new_content << " * Copyright #{COPYRIGHT_YEAR} #{COPYRIGHT_HOLDER}\n"
    new_content << " *\n"
    COPYRIGHT_NOTICE.each_line do |notice_line|
      if notice_line == "\n"
        new_content << " *\n"
      else
        new_content << " * #{notice_line}"
      end
    end
    new_content << " */\n"
    new_content << line
    new_content << file.read
  end
  path.open('w') do |file|
    file.write new_content
  end
  $stderr.puts green("#{path}: copylefted")
end

def copyleft_hash_style(path)
  new_content = String.new
  created_by = nil
  path.open('r') do |file|
    line = file.gets
    if line =~ /^#!/
      new_content << line
    end
    if line =~ /^#/
      while (line = file.gets) =~ %r{(^#)|(^$)}
        /Created by .+ on .+\./.match(line) { |m| created_by = m[0].to_s }
      end
    end
    new_content << "#\n"
    new_content << "# #{path.basename}\n"
    new_content << "# #{created_by}\n" if created_by
    new_content << "# Copyright #{COPYRIGHT_YEAR} #{COPYRIGHT_HOLDER}\n"
    new_content << "#\n"
    COPYRIGHT_NOTICE.each_line do |notice_line|
      if notice_line == "\n"
        new_content << "#\n"
      else
        new_content << "# #{notice_line}"
      end
    end
    new_content << "#\n\n"
    new_content << line
    new_content << file.read
  end
  path.open('w') do |file|
    file.write new_content
  end
  $stderr.puts green("#{path}: copylefted")
end

def copyleft_directory(dir)
  dir.each_child do |path|
    copyleft_path path
  end
end

def ignore?(path)
  return true if IGNORED_TYPES.include?(path.extname)
  return true if path.basename.to_s[0] == '.'
  return false
end

def copyleft_path(path)
  if ignore?(path)
    puts yellow("#{path}: ignored")
  elsif path.directory?
    copyleft_directory path
  elsif SLASH_STYLE_TYPES.include?(path.extname)
    copyleft_slash_style(path)
  elsif HASH_STYLE_TYPES.include?(path.extname)
    copyleft_hash_style(path)
  else
    puts red("#{path}: unknown file type #{path.extname}")
  end
end

copyleft_path Pathname.new('.').realpath
