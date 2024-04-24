# public_dns_list

Known public dns list  ips and domains


# original 

https://adguard-dns.io/kb/general/dns-providers/#adguard-dns


# update frequency 

1'th day of every month. 

## files
## File and types

by scraping 

| type                        | proto       |          filename |
|:----------------------------|:------------|------------------:|
| DoH / public DNS over HTTPS | https://    |  dns-list-doh.txt | 
| DoH / public DNS over HTTPS | quic://     |  dns-list-doq.txt | 
| DoT / public DNS over TLS   | tls://      |  dns-list-dot.txt | 
| ipv4 / public dns servers   | inet4:port  | dns-list-ipv4.txt | 
| ipv6 / public dns servers   | inet6:port  | dns-list-ipv6.txt |

Combimed.

These files are for dns blocking, resolve tracking purpose.

|                 filename | data         | descrition                               |
|-------------------------:|:-------------|:-----------------------------------------|
|      dns-list-domain.txt | Domain names | public dns names. dot,dos,quick Combined |
|   dns-list-dot-as-ip.txt | ipv4         | public dns dot, dns resolved             |
|   dns-list-doh-as-ip.txt | ipv4         | public dns doh, dns resolved             |
|   public_dns_ip_list.txt | ipv4         | all combimed, only address               |
| public_dns_ipv6_list.txt | ipv6         | all combimed, only address               |

misc

|        filename | data         | descrition                        |
|----------------:|:-------------|:----------------------------------|
| ignore-list.txt | Domain names | no exists domain, or not resolved |

# history 

- 2022-07-06 update url
