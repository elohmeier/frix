{ writeShellScriptBin, windows-vm-image, fetchurl, qemu_kvm, virt-viewer, fetchzip, xz }:

# from https://superuser.com/a/1200899
# drvload d:\viostor\w10\amd64\viostor.inf
# dism /image:e:\ /add-driver /driver:d:\viostor\w10\amd64\viostor.inf

let
  virtio-win = fetchurl {
    url = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.196-1/virtio-win.iso";
    sha256 = "1zj53xybygps66m3v5kzi61vqy987zp6bfgk0qin9pja68qq75vx";
    preferLocalBuild = true;
  };


  # TODO: fix rebase
  #${qemu_kvm}/bin/qemu-img rebase -f qcow2 -b "${windows-vm-image}/windows-vm-image.qcow2" -F qcow2 $out/win-vm_viostor_overlay.qcow2
  viostor-driver-overlay = fetchzip {
    url = "https://www.nerdworks.de/dl/win-vm_viostor_overlay.qcow2.xz";
    sha256 = "sha256-vPHa1h4aIP++B/0NFWzmVJGxGPLVHL/lNULAbrKqeuU=";
    postFetch = ''
      mkdir -p $out
      ${xz}/bin/xzcat -d $downloadedFile > $out/win-vm_viostor_overlay.qcow2
    '';
    preferLocalBuild = true;
  };
in
writeShellScriptBin "run-win-vm" ''
  if [ ! -f win-vm.qcow2 ]; then
    echo "generating win-vm.qcow2 overlay image"
    ${qemu_kvm}/bin/qemu-img create \
      -f qcow2 win-vm.qcow2 128G \
      -b "${viostor-driver-overlay}/win-vm_viostor_overlay.qcow2" -F qcow2
  else
    echo "reusing existing win-vm.qcow2 overlay image, delete that file if you need a fresh windows environment"
  fi

  ${qemu_kvm}/bin/qemu-system-x86_64 \
    -daemonize \
    -nodefaults \
    -enable-kvm \
    -cpu host -smp 12 \
    -drive file=win-vm.qcow2,if=virtio \
    -cdrom "${virtio-win}" \
    -net nic -net user,hostname=win-vm \
    -m 4G \
    -vga qxl \
    -spice port=5924,disable-ticketing \
    -usbdevice tablet \
    -device virtio-serial \
    -chardev spicevmc,id=vdagent,name=vdagent \
    -device virtserialport,chardev=vdagent,name=com.redhat.spice.0 \
    "$@"
  
  ${virt-viewer}/bin/remote-viewer --title win-vm spice://127.0.0.1:5924
''
