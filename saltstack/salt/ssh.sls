Deploy sshd_config:
  file.managed:
    - name: {{ pillar['ssh']['sshd_config_path'] }}
    - source: salt://sshd_config
    - replace: True
    - require:
      - Make sure sshd is enabled