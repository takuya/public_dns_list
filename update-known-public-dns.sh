#!/usr/bin/env bash

alias xpath="xmllint --html --xpath"

function get_known_dns_list(){
  curl -s 'https://kb.adguard.com/en/general/dns-providers#adguard-dns' | xpath '//code/text()' - 2>/dev/null
}
function main() {

  which sort
  which xmllint
  which uniq
  type xpath
  echo start

  list=$(get_known_dns_list | sort | uniq)
  echo "$list"
  echo "$list" | xargs -0 | grep 'tls://' | tee dns-list-dot.txt
  echo "$list" | xargs -0 | grep 'https://' | tee dns-list-doh.txt
  echo "$list" | xargs -0 | grep -P '^\d+\.\d+\.\d+\.\d+' | sort -t . -n | tee dns-list-ipv4.txt
  echo "$list" | xargs -0 | grep -P '^\[?[a-fA-F0-9:\]]+$' | sort -t :  -n | tee dns-list-ipv6.txt

}



main;

