{ config, lib, pkgs, ... }:

{
  services.openssh = {
    knownHosts = {
      github =
        {
          hostNames = [ "github.com" ];
          publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==";
        };
      fraamgit = {
        hostNames = [ "git.fraam.de" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKqi/Ley5IzAX4+x7446j/mEKFekN4pdfYSxesxO48LP";
      };
      metrics = {
        hostNames = [ "metrics.fraam.de" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIVCuMb35umJyD/Co9EY6P7s0pelnrTodn0yO6dJhV70";
      };
      anon-demo = {
        hostNames = [ "anon-demo.fraam.de" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPN1rMMgRREOD1uww7k6WKYy+F0x8sAj9xYq60M+8LHj";
      };
      # https://docs.hetzner.com/de/robot/storage-box/access/access-ssh-rsync-borg/#ssh-host-keys
      "hetzner-storage-box-rsa" = {
        hostNames = [ "u276121.your-storagebox.de" "[u276121.your-storagebox.de]:23" ];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA5EB5p/5Hp3hGW1oHok+PIOH9Pbn7cnUiGmUEBrCVjnAw+HrKyN8bYVV0dIGllswYXwkG/+bgiBlE6IVIBAq+JwVWu1Sss3KarHY3OvFJUXZoZyRRg/Gc/+LRCE7lyKpwWQ70dbelGRyyJFH36eNv6ySXoUYtGkwlU5IVaHPApOxe4LHPZa/qhSRbPo2hwoh0orCtgejRebNtW5nlx00DNFgsvn8Svz2cIYLxsPVzKgUxs8Zxsxgn+Q/UvR7uq4AbAhyBMLxv7DjJ1pc7PJocuTno2Rw9uMZi1gkjbnmiOh6TTXIEWbnroyIhwc8555uto9melEUmWNQ+C+PwAK+MPw==";
      };
    };
  };

  environment.systemPackages = with pkgs;[ foot.terminfo ];

  nix = {
    binaryCaches = [
      "https://fraam.cachix.org"
    ];
    binaryCachePublicKeys = [
      "fraam.cachix.org-1:jli8HeFa594XmjkCbP7ZgDPaWI8kvdXloTJIIfaxJLw="
    ];
  };

  security.polkit.enable = lib.mkDefault false;
}
