#!/usr/bin/env ruby
# Script to manage Atlas Box Repository. It's used after a packer build was
# done.
# License is MIT and Copyritght is Fernando Ike <fike@midstorm.org>
#
require 'json'
require 'yaml'
require 'net/http'
require 'uri'
require 'optparse'

@packerdir = ARGV[1]
ARGV << '-h' if ARGV.empty?

options = {}
optparser = OptionParser.new do|opts|
  opts.banner = "Usage: atlaswaiter.rb [options] PackerDir"
  opts.on('-c', '--create PackerDir', 'Create Atlas Box Repository') do |c|
    options[:create] = c
  end

  opts.on('-d', '--delete PackerDIr', 'Atlas box name to delete') do |d|
    options[:delete] = d
  end

  opts.on('-m', '--up-desc PackerDIr', 'Update the description of Atlas') do |ud|
    options[:updescription] = ud
  end

  opts.on('-s', '--up-short-desc PackerDIr', 'Update the Short Description of Atlas Respoisitory') do |us|
    options[:upshortdesc] = us
  end

  opts.on('-u', '--upload-box PackerDIr', 'Upload box to Atlas') do |up|
    options[:upload] = up
  end

  opts.on_tail('-h', '--help', 'Displays Help') do |help|
    puts opts
    exit
  end
end

optparser.parse!

atlasconf             = YAML.load_file(@packerdir + '/atlas/atlas.yml')
@atlastoken           = atlasconf.fetch('box')['atlas_token']
if @atlastoken == nil
  @atlastoken = ENV["ATLAS_TOKEN"]
end
@boxname              = atlasconf.fetch('box')['boxname']
@username             = atlasconf.fetch('box')['username']
@private              = atlasconf.fetch('box')['private']
@provider             = atlasconf.fetch('box')['provider']
@short_description    = atlasconf.fetch('box')['short_description']
@version              = atlasconf.fetch('box')['version'].to_s
@description_box      = File.read(@packerdir + '/atlas/description_box.md')
@description_version  = File.read(@packerdir + '/atlas/description_version.md')


def create_box_repo
  uri = URI.parse('https://atlas.hashicorp.com/api/v1/boxes/')
  req = Net::HTTP::Post.new(uri)
  res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    req['X-Atlas-Token'] = @atlastoken
    req['Content-Type'] = 'application/json'
    req.set_form_data('box[name]' => @boxname, 'box[username]' => @username, 'box[is_private]' => @private, 'box[short_description]' => @short_description, 'box[description]' => @description)
    #req.body = JSON.pretty_generate(name: @boxname, username: @username,
    #  is_private: @private, short_description: @short_description,
    #  description: @description_box, versions: @version)
    http.request(req)
  end
  if res.code == '200'
    puts 'Created box respository: ' + @boxname
  else
    puts 'Can\'t create ' + @boxname + ' repository'
    exit
  end
  create_box_version
  create_box_provider
end

def create_box_version
  uri = URI.parse('https://atlas.hashicorp.com/api/v1/box/' + @username + '/' + @boxname + '/versions')
  req = Net::HTTP::Post.new(uri)
  res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    req['X-Atlas-Token'] = @atlastoken
    req.set_form_data('version[version]' => @version, 'version[description]' => @description_version)
    http.request(req)
  end
  if res.code == '200'
    puts 'Created ' + @boxname + 'box ' + @version
  else
    puts 'Can\'t removed ' + @boxname + ' repository'
    puts "#{res.code} #{res.message}"
    puts "#{res.body}"
    exit
  end
end

def create_box_provider
  uri = URI.parse('https://atlas.hashicorp.com/api/v1/box/' + @username + '/' + @boxname + '/version/' + @version + '/providers')
  req = Net::HTTP::Post.new(uri)
  res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    req['X-Atlas-Token'] = @atlastoken
    req.set_form_data('provider[name]' => @provider)
    http.request(req)
  end
  if res.code == '200'
    puts 'Created box ' + @provider
  else
    puts 'Can\'t removed ' + @boxname + ' repository'
    puts "#{res.code} #{res.message}"
    puts "#{res.body}"
    exit
  end
end

def del_box_repo
  uri = URI.parse('https://atlas.hashicorp.com/api/v1/box/' + @username + '/' + @boxname)
  req = Net::HTTP::Delete.new(uri)
  res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    req['X-Atlas-Token'] = @atlastoken
    http.request(req)
  end
  if res.code == '200'
    puts 'Removed box respository: ' + @boxname
  else
    puts 'Can\'t removed ' + @boxname + ' repository'
    puts "#{res.code} #{res.message}"
    puts "#{res.body}"
    exit
  end
end

def release_box
  uri = URI.parse('https://atlas.hashicorp.com/api/v1/box/' + @username + '/' + @boxname + '/version/' + @version + '/release')
  req = Net::HTTP::Put.new(uri)
  res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    req['X-Atlas-Token'] = @atlastoken
    res = http.request(req)
  end
  if res.code == '200'
    puts 'Released ' + @boxname + ' ' + @version
  else
    puts 'Can\'t release ' + @boxname + ' ' + @version
    puts "#{res.code} #{res.message}"
    puts "#{res.body}"
    exit
  end
end

def update_box_description
  uri = URI.parse('https://atlas.hashicorp.com/api/v1/box/' + @username + '/' + @boxname)
  req = Net::HTTP::Put.new(uri)
  res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    req['X-Atlas-Token'] = @atlastoken
    req.set_form_data('box[short_description]' => @short_description)
    #req.body = JSON.pretty_generate(:description => @description_version, :description_markdown => @description_version,)
    http.request(req)
  end
  puts res
end

def update_version_description
  uri = URI.parse('https://atlas.hashicorp.com/api/v1/box/' + @username + '/' + @boxname + '/version/' + @version)
  req = Net::HTTP::Put.new(uri)
  res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    req['X-Atlas-Token'] = @atlastoken
    req.set_form_data('version[description]' => @description_version)
    #req.body = JSON.pretty_generate(:description => @description_version, :description_markdown => @description_version,)
    http.request(req)
  end
  puts res
end

def upload_box
  create_box_version
  create_box_provider
  uri = URI.parse('https://atlas.hashicorp.com/api/v1/box/' + @username + '/' + @boxname + '/version/' + @version + '/provider/' + @provider + '/upload')
  req = Net::HTTP::Get.new(uri)
  res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    req['X-Atlas-Token'] = @atlastoken
    http.request(req)
  end

  if res.code == '200'
    uri = URI.parse(JSON.parse("#{res.body}").fetch('upload_path'))
    puts 'Fetched URI to upload:  ' + uri.to_s
    puts 'Uploading...'
    #puts uri
    #uri = URI.parse('http://127.0.0.1' + uri.path)
    #puts uri
    req = Net::HTTP::Put.new(uri)
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      req['Content-Length'] = File.size(@packerdir + '/' + @packerdir + '.box')
      req['Expect'] = "100-continue"
      req.body_stream = @packerdir + '/' + @packerdir + '.box'
      http.request(req)
    end
    if res.code == '200'
      puts 'Uploaded ' + @boxname
      release_box
    else
      puts 'Can\'t uploaded ' + @boxname
      puts "#{res.code} #{res.message}"
      puts "#{res.body}"
      exit
    end
  else
    puts 'Can\'t got URI to upload'
    puts "#{res.code} #{res.message}"
    puts "#{res.body}"
    exit
  end

end

if options[:create]
  create_box_repo
elsif options[:delete]
  del_box_repo
elsif options[:updescription]
  update_version_description
elsif options[:upshortdesc]
  update_box_description
elsif options[:upload]
  upload_box
else
  options.help
end
