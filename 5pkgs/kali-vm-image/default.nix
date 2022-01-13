{ stdenv, fetchurl, p7zip, qemu-utils }:

stdenv.mkDerivation rec {
  pname = "kali-vm-image";
  version = "2021.4a";

  src = fetchurl {
    url = "https://kali.download/virtual-images/kali-${version}/kali-linux-${version}-vmware-amd64.7z";
    sha256 = "0hnbfpsvpkdl07bn9if3xq2nz13gglb5nvl6zzm0lr9a41lvdnpm";
  };
  dontUnpack = true;

  buildPhase = ''
    ${p7zip}/bin/7z x $src
  '';

  installPhase = ''
    mkdir -p $out
    ${qemu-utils}/bin/qemu-img convert -f vmdk -O qcow2 "Kali-Linux-${version}-vmware-amd64.vmwarevm/Kali-Linux-${version}-vmware-amd64.vmdk" $out/kali-vm-image.qcow2
  '';

  preferLocalBuild = true;
}
