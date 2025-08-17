# FreeVPN

This is a VPN system that uses VPNGate as OVPN providers
This use auto updated [auto-opvn](https://github.com/9xN/auto-ovpn) to fetch constant usable workings ovpn files.

Meanwhile, those VPN files config uses --cipher, and OpenVPN 2.6+ ask for --data-ciphers, so the openvpn.sh makes a temporary stream that replace the occurences without modifying the file, making those config compatible with OpenVPN 2.6+.

## TODO:
- Add Powershell script for Windows support
