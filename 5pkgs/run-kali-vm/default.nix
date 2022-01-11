{ writeShellScriptBin, kali-vm-image }:

writeShellScriptBin "run-kali-vm" ''
  if [ ! -f kali-vm.qcow2 ]; then
    echo "generating kali-vm.qcow2 overlay image"
    qemu-img create \
      -f qcow2 kali-vm.qcow2 80G \
      -b "${kali-vm-image}/kali-vm-image.qcow2" -F qcow2
  else
    echo "reusing existing kali-vm.qcow2 overlay image, delete that file if you need a fresh kali environment"
  fi

  qemu-system-x86_64 \
    -nodefaults \
    -enable-kvm \
    -cpu host -smp 12 \
    -drive file=kali-vm.qcow2,if=virtio \
    -net nic -net user,hostname=kali-vm \
    -m 4G \
    -monitor stdio \
    -name kali-vm \
    -device usb-ehci,id=ehci \
    -device usb-tablet,bus=ehci.0 \
    -vga std
''
