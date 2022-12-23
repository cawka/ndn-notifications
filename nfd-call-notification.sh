#!/bin/bash

php -r '
$dom = new DOMDocument();
$doc = $dom->loadHTMLFile("https://docs.google.com/document/d/1a8yXkYg6AZ6EafUbXsKDXgac_aDZPQU8t5Q3p2I1K5M/pub");

$xpath = new DOMXPath($doc);
foreach ($xpath->query("//script") as $node) {
  $node->parentNode->removeChild($node);
}
foreach ($xpath->query("//div[@id=\"header\"]") as $node) {
  $node->parentNode->removeChild($node);
}
foreach ($xpath->query("//div[@id=\"footer\"]") as $node) {
  $node->parentNode->removeChild($node);
}

$html = $doc->saveHTML();
$html = str_replace("><", ">\n<", $html);
$html = str_replace("&Acirc;", " ", $html);
$html = str_replace("&nbsp;", " ", $html);
file_put_contents("/tmp/nfd-call-notification.htm", $html);
'

(
  echo '<p>Dear folks</p>'
  echo '<p>This is a reminder of the upcoming NFD call using Zoom'
  echo '<a href="https://arizona.zoom.us/j/82909523174?pwd=bEc2VXk4M3ZrdC95SGlxUHVzRVFyUT09">https://arizona.zoom.us/j/82909523174?pwd=bEc2VXk4M3ZrdC95SGlxUHVzRVFyUT09</a>.'
  echo 'The current call time is every Friday 09:00-11:00 Pacific Time.'
  echo 'The current agenda includes the following issues:</p>'
  awk 'BEGIN { inIssues=false } $1=="<hr>" { inIssues=!inIssues } inIssues { print }' /tmp/nfd-call-notification.htm
) |\
#mail -a 'From: NFD call notification <noreply@named-data.net>' \
#     -a 'Content-Type: text/html; charset=utf-8' \
#     -s 'NFD call '$(date --date="tomorrow" +%Y%m%d) \
#     nfd-dev@lists.cs.ucla.edu

# for A in \
#     jefft0@remap.ucla.edu \
#     philoliang2011@gmail.com \
#     yingdi@cs.ucla.edu \
#     bzhang@cs.arizona.edu \
#     spiros.mastorakis@gmail.com \
#     jburke@remap.ucla.edu \
#     lybmath2009@gmail.com \
#   ;
# do
#   cat /tmp/nfd-call-notification.htm |\
#   mail -a 'From: NFD call notification <noreply@named-data.net>' \
#        -a 'Content-Type: text/html; charset=utf-8' \
#        -s 'NFD call '$(date +%Y%m%d) \
#        $A
# done

rm /tmp/nfd-call-notification.htm
