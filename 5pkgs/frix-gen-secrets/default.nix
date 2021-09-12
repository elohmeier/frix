{ writers
, coreutils
, pwgen
, hashPassword
, openssh
, wireguard
, openssl
, pass
, syncthing-device-id
}:
writers.writeDashBin "frix-gen-secrets" ''
  HOSTNAME="''${1?must provide hostname}"
  TMPDIR=$(${coreutils}/bin/mktemp -d)
  PASSWORD=$(${pwgen}/bin/pwgen 25 1)
  HASHED_PASSWORD=$(echo $PASSWORD | ${hashPassword}/bin/hashPassword -s) > /dev/null

  ${openssh}/bin/ssh-keygen -t ed25519 -f $TMPDIR/ssh.id_ed25519 -P "" -C "" >/dev/null
  ${openssh}/bin/ssh-keygen -t ed25519 -f $TMPDIR/borgbackup.id_ed25519 -P "" -C "" >/dev/null
  ${wireguard}/bin/wg genkey > $TMPDIR/frixvpn.key 2>/dev/null
  ${coreutils}/bin/cat $TMPDIR/frixvpn.key | ${wireguard}/bin/wg pubkey > $TMPDIR/frixvpn.pub
  ${pwgen}/bin/pwgen 25 1 > $TMPDIR/borgbackup.borgkey
  ${openssl}/bin/openssl ecparam -name secp384r1 -genkey -noout -out $TMPDIR/syncthing.key 2>/dev/null > /dev/null
  ${openssl}/bin/openssl req -new -x509 -key $TMPDIR/syncthing.key -out $TMPDIR/syncthing.crt -days 10000 -subj "/CN=syncthing" 2>/dev/null > /dev/null

  echo $HASHED_PASSWORD > $TMPDIR/mainUser.passwd
  echo $HASHED_PASSWORD > $TMPDIR/root.passwd

  cd $TMPDIR
  for x in *; do
    ${coreutils}/bin/cat $x | ${pass}/bin/pass insert -m frix/hosts/$HOSTNAME/$x > /dev/null
  done
  echo $PASSWORD | ${pass}/bin/pass insert -m frix/admin/$HOSTNAME/pass > /dev/null

  cat <<EOF
  $HOSTNAME = {
    nets = {
      frixvpn = {
        ip4.addr = "changeme";
        aliases = [
          "$HOSTNAME.frix"
        ];
        wireguard.pubkey = "$(cat $TMPDIR/frixvpn.pub)";
      };
    };
    borg.pubkey = "$(cat $TMPDIR/borgbackup.id_ed25519.pub)";
    ssh.pubkey = "$(cat $TMPDIR/ssh.id_ed25519.pub)";
    syncthing.id = "$(${syncthing-device-id}/bin/syncthing-device-id $TMPDIR/syncthing.crt)";
  };
  EOF

  rm -rf $TMPDIR
''