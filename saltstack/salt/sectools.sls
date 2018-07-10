System hardening:
  pkg.installed:
    - pkgs:
      # - paxd
      - checksec
      - pax-utils
      - paxtest

Vulnerability scan/management:
  pkg.installed:
    - pkgs:
      - openvas

Intrusion detection:
  pkg.installed:
    - pkgs:
      - aide

Anti-infoleak/privacy:
  pkg.installed:
    - pkgs:
      - perl-image-exiftool

Sandboxing:
  pkg.installed:
    - pkgs:
      - firejail

Hashing:
  pkg.installed:
    - pkgs:
      - rhash
      - cfv

Cryptographic:
  pkg.installed:
    - pkgs:
      - ccrypt
      - gnupg
      - gpa
      - veracrypt

Anti-malware:
  pkg.installed:
    - pkgs:
      - rkhunter

Auditing:
  pkg.installed:
    - pkgs:
      - lynis

VPN:
  pkg.installed:
    - pkgs:
      - openvpn
