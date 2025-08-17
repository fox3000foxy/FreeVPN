# FreeVPN

FreeVPN is a simple VPN launcher that uses [VPNGate](https://www.vpngate.net/) servers via OpenVPN, leveraging the [auto-ovpn](https://github.com/9xN/auto-ovpn) project to keep an up-to-date list of working `.ovpn` configuration files.

## Features

- **Automatic update** of VPN server configs via `auto-ovpn` (GitHub).
- **Compatibility fix**: Converts legacy `cipher` directive to `data-ciphers` for OpenVPN 2.6+ compatibility, without modifying the original config files.
- **Easy selection**: Choose a country code (e.g., JP, KR, VN, RU, TH, US) to auto-select a server, or pick manually if multiple are available.
- **No config editing required**: All changes are done on-the-fly with a temporary file.

## Usage

```bash
./openvpn.sh [--autochoose] <JP|KR|VN|RU|TH|US>
```

- `--autochoose` (optional): Automatically selects the first matching server if multiple are found.
- `<country>`: Country code to filter servers (e.g., JP for Japan).

**Example:**

```bash
./openvpn.sh JP
```

If multiple configs are found, you will be prompted to select one (unless `--autochoose` is used).

## Requirements

- Linux (tested)
- `openvpn` (2.6+ recommended)
- `git`
- `bash`

## How it works

- Downloads/updates the `auto-ovpn` repo.
- Finds a matching `.ovpn` config.
- Converts `cipher` to `data-ciphers` in a temporary file for OpenVPN 2.6+.
- Launches OpenVPN with the modified config.

## TODO

- Add PowerShell script for Windows
