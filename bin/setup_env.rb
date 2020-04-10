require 'openssl'
require 'base64'

cipher = OpenSSL::Cipher::AES.new(128, :CBC)
cipher.encrypt
key = cipher.random_key
iv = cipher.random_iv

File.open('.env', 'w+') do |f|
  example_file = File.open('.env.example', 'r')
  f.puts example_file.readlines
  example_file.close

  f.puts "key=#{Base64.encode64(key).encode('ascii-8bit')}"
  f.puts "iv=#{Base64.encode64(iv).encode('ascii-8bit')}"
end
