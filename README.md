> [!WARNING]  
> # UPDATE NOTICE
> This project is deprecated. [This](https://github.com/Croissant-API/Croissant-VPN) one is a better version of it.
> You can still continue to use this one as before but it will not be longer maintened.

---

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

### For Linux (openvpn.sh)
- Linux (tested)
- `openvpn` (2.6+ recommended)
- `git`
- `bash`

### For Windows (openvpn.ps1)
- Windows 10/11 (PowerShell 5+)
- [OpenVPN](https://openvpn.net/community-downloads/) (add `openvpn.exe` to your PATH)
- [Git for Windows](https://gitforwindows.org/) (for `git` command)


## How it works

- Downloads/updates the `auto-ovpn` repo.
- Finds a matching `.ovpn` config.
- Converts `cipher` to `data-ciphers` in a temporary file for OpenVPN 2.6+.
- Launches OpenVPN with the modified config.


## PowerShell version (Windows)

You can use the provided `openvpn.ps1` script to run FreeVPN on Windows with PowerShell:

```
./openvpn.ps1 -InputArg JP -AutoChoose
```
or
```
./openvpn.ps1 -InputArg JP
```

- `-InputArg <country>`: Country code to filter servers (e.g., JP, KR, VN, RU, TH, US)
- `-AutoChoose` (optional): Automatically selects the first matching server if multiple are found.

The script will clone/update the `auto-ovpn` repo, select a config, patch it for OpenVPN 2.6+ compatibility, and launch OpenVPN.

**Dependencies for Windows:**
- PowerShell 5+
- OpenVPN (add to PATH)
- Git (add to PATH)

---
