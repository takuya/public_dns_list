#!/usr/bin/env bash


function get_known_dns_list(){
  curl -s -L 'https://adguard-dns.io/kb/general/dns-providers#adguard-dns' \
  | xmllint --html --xpath '//code/text()' - 2>/dev/null
}
function list_to_ip(){
  ignore=$(ignore_list)
  list_names=$(cat  "$1" \
    |  sed -E 's!(https|quic|tls)://!!' \
    |  sed -E 's|/.+||'  \
    |  sed 's|/.*$||'       \
    |  sed -E 's|:[0-9]+||' \
    | grep -vE "${ignore}"  \
  )
  list_1=$( echo "${list_names[@]}" \
    | xargs -n 1 dig +short a \
    | grep -v '[a-z]'
  )
  list_2=$( echo "${list_names[@]}" | xargs -n1 echo |  grep  -E '[0-9]{1,3}$')
  (echo "$list_1"; echo "$list_2") | sort -V | uniq | grep -vE '^$';
}
function dos_to_ip(){
  list_to_ip  dns-list-doh.txt  | tee dns-list-doh-as-ip.txt
  list_to_ip  dns-list-dot.txt  | tee dns-list-dot-as-ip.txt
}
function ignore_list(){
 ARR=();
 for i  in $(cat  ignore-list.txt | sort | uniq  ) ; do
  ARR+=( $i );
 done ;
 list=$( IFS=\|; echo "${ARR[*]}" );
 echo "${list}"
}
function merge_ipv4_list() {
  dot_host_ips=$(cat dns-list-dot-as-ip.txt)
  doh_host_ips=$(cat dns-list-doh-as-ip.txt)
  dns_host_ips=$(cat dns-list-ipv4.txt| sed -E 's/:[0-9]{1,4}$//' )

  (echo "$doh_host_ips";echo "$dot_host_ips";echo "$dns_host_ips") | sort -V | uniq | tee public_dns_ip_list.txt

}

function main() {


  list=$(get_known_dns_list | sort | uniq)
  echo $list;
  echo "$list" | xargs -0 | grep 'tls://' | tee dns-list-dot.txt
  echo "$list" | xargs -0 | grep 'https://' | tee dns-list-doh.txt
  echo "$list" | xargs -0 | grep 'quic://' | tee dns-list-doq.txt
  echo "$list" | xargs -0 | grep -P '^\d+\.\d+\.\d+\.\d+' | sort -t . -n | tee dns-list-ipv4.txt
  echo "$list" | xargs -0 | grep -P '^\[?[a-fA-F0-9:\]]+$' | sort -t :  -n | tee dns-list-ipv6.txt
  echo "$list" | xargs -0 | grep -P '[a-z\.0-9]+\.[a-z]+(/dns-query)?$' \
   | sed 's|/dns-query||' \
   | sed -r 's%(https|tls|quic)://%%' \
   | sort | uniq | tee dns-list-domain.txt
  #
  dos_to_ip
  merge_ipv4_list

}



main;

