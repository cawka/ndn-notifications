require 'yaml'
require 'nokogiri'
require 'open-uri'
require 'uri'
require 'cgi'
require 'mail'

config = YAML.load(File.open('config.yaml').read)

doc = Nokogiri::HTML(URI.open(config['source']))

doc.xpath("//a").each do |a|
  if a['href'].start_with?('https://www.google.com/url?q=')
    params = CGI::parse(a['href'].gsub('https://www.google.com/url?',''))

    #puts params
    a['href'] = params['q'][0]
  end
end

hr = doc.xpath("//hr")

node = hr[0].next
hr2 = hr[1]

template = Nokogiri::HTML(File.open("mail-template.html"))
issues = template.css("#issues")[0]

while node != hr2 do
  issues.add_child(node.dup)

  puts node
  node = node.next
end
html = template.to_html

puts html
