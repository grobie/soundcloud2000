require 'bundler/gem_tasks'
require 'rake'
require 'yaml'

def dependencies(file)
  `otool -L #{file}`.split("\n")[1..-1].map {|line| line.split[0] }
end

task :dirs do
  Dir.mkdir 'vendor' rescue nil
  Dir.mkdir 'vendor/bin' rescue nil
  Dir.mkdir 'vendor/lib' rescue nil
  Dir.mkdir 'vendor/dyld' rescue nil
end

task :ruby => :dirs do
  lines = `rvm info`.split("\n")[6..-1]
  ruby = YAML.load(lines.join("\n"))

  version = ruby.keys.first
  home = ruby[version]['homes']['ruby']
  bin = ruby[version]['binaries']['ruby']
  # dylib = dependencies(bin)[0]

  `cp -a #{home}/lib/ruby/1.9.1/* vendor/lib`
  `cp #{bin} vendor/`
  # `cp #{dylib} vendor/dyld`
end

task :libs => :dirs do
  [:audite, :portaudio, :mpg123].each do |name|
    lib = `gem which #{name}`.chomp
    `cp #{lib} vendor/lib`
    if File.extname(lib) == '.bundle'
      dylib = dependencies(lib)[0]
      `cp #{dylib} vendor/dyld`
    end
  end
end

task :package => [:ruby, :libs] do
  `cp soundcloud2000 vendor`
  `cp -a bin/* vendor/bin`
  `cp -a lib/* vendor/lib`
  `tar czf soundcloud2000.tgz vendor`
end
