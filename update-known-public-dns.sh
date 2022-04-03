#!/usr/bin/env bash


function get_known_dns_list(){
  curl -s 'https://kb.adguard.com/en/general/dns-providers#adguard-dns' | xmllint --html --xpath '//code/text()' - 2>/dev/null
}
function main() {

  list=$(get_known_dns_list | sort | uniq)
  echo "$list" | xargs -0 | grep 'tls://' | tee dns-list-dot.txt
  echo "$list" | xargs -0 | grep 'https://' | tee dns-list-doh.txt
  echo "$list" | xargs -0 | grep 'quic://' | tee dns-list-doq.txt
  echo "$list" | xargs -0 | grep -P '^\d+\.\d+\.\d+\.\d+' | sort -t . -n | tee dns-list-ipv4.txt
  echo "$list" | xargs -0 | grep -P '^\[?[a-fA-F0-9:\]]+$' | sort -t :  -n | tee dns-list-ipv6.txt
  echo "$list" | xargs -0 | grep -P '[a-z\.0-9]+\.[a-z]+(/dns-query)?$' \
   | sed 's|/dns-query||' \
   | sed -r 's%(https|tls|quic)://%%' \
   | sort | uniq | tee dns-list-domain.txt

}



main;

