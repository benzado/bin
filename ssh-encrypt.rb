#!/usr/bin/env ruby
require 'base64'
require 'openssl'
require 'optparse'
require 'pathname'

# Usage: ssh-encrypt -k ssh-key -i plain-text -o encrypted-text

# Utility for converting OpenSSH public keys into a form OpenSSL can use, so you
# can encrypt data to send to a GitHub user. Because it uses the RSA algorithm
# directly, it only works on small files.

# You can get a GitHub user's public keys from https://github.com/$USER.keys

# Hat Tip: http://blog.oddbit.com/2011/05/08/converting-openssh-public-keys/

class Application
  attr_accessor :key_path, :in_path, :out_path

  def parse_key
    for line in @key_path.each_line
      if line =~ /ssh-rsa /
        bytes = Base64::decode64($')
        fail! "Failed to base64 decode #{@key_path}" if bytes.nil?
        chunks = Array.new
        while bytes && bytes.length > 0
          chunk_length = bytes.unpack('N').first
          chunks << bytes.byteslice(4, chunk_length)
          bytes = bytes.byteslice(4 + chunk_length, bytes.length - chunk_length - 4)
        end
        return chunks
      end
    end
    fail! "Unable to find an RSA key in #{@key_path}"
  end

  def pkcs1_sequence
    chunks = self.parse_key
    e = chunks[1].bytes.inject {|a, b| (a << 8) + b }
    n = chunks[2].bytes.inject {|a, b| (a << 8) + b }
    OpenSSL::ASN1::Sequence.new([
      OpenSSL::ASN1::Integer.new(n),
      OpenSSL::ASN1::Integer.new(e)
    ])
  end

  def key
    OpenSSL::PKey::RSA.new(self.pkcs1_sequence.to_der)
  end

  def encrypted_data
    self.key.public_encrypt(@in_path.read)
  end

  def fail!(message)
    $stderr.puts message
    exit 1
  end

  def run!
    fail! "Use -k to specify a public key." if @key_path.nil?
    fail! "Use -i to specify an input file." if @in_path.nil?
    fail! "Use -o to specify an output file." if @out_path.nil?
    fail! "Output file already exists: #{@out_path}" if @out_path.exist?
    $stderr.puts "Writing #{@out_path}"
    @out_path.open('w') do |f|
      f.write self.encrypted_data
    end
    $stderr.puts "Decrypt with", "\topenssl rsautl -decrypt -inkey ~/.ssh/id_rsa -in #{@out_path}"
    exit 0
  end

end

app = Application.new

OptionParser.new do |opts|
  opts.on('-k', '--key KEYFILE', 'OpenSSH-format public key file') do |path|
    app.key_path = Pathname.new path
  end
  opts.on('-i', '--input FILE', 'Plain text file to encrypt') do |path|
    app.in_path = Pathname.new path
  end
  opts.on('-o', '--output FILE', 'Encrypted file to write') do |path|
    app.out_path = Pathname.new path
  end
end.parse!

app.run!
