# pip install vyattaconfparser
import vyattaconfparser
import json
conf_str = '''
interfaces {
  ethernet eth1 {
      mtu 1500
      address 192.168.0.2/29
      duplex auto
      speed auto
      vif 0 {
            bridge-group br0
      }
      vrrp {
          vrrp-group 99 {
              priority 150
              rfc-compatibility
              virtual-address 172.16.0.24
          }
          vrrp-group 98 {
              priority 250
              virtual-address 172.16.0.1
          }
      }
  }
}'''

conf_dict = vyattaconfparser.parse_conf(conf_str)
print(json.dumps(conf_dict,indent=2))
