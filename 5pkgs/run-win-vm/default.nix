{ writeShellScriptBin, windows-vm-image }:

writeShellScriptBin "run-win-vm" ''
  if [ ! -f win-vm.qcow2 ]; then
    echo "generating win-vm.qcow2 overlay image"
    qemu-img create \
      -f qcow2 win-vm.qcow2 128G \
      -b "${windows-vm-image}/windows-vm-image.qcow2" -F qcow2
  else
    echo "reusing existing win-vm.qcow2 overlay image, delete that file if you need a fresh windows environment"
  fi

  qemu-system-x86_64 \
    -enable-kvm \
    -cpu host -smp 12 \
    -drive file=win-vm.qcow2,if=ide \
    -net nic -net user,hostname=win-vm \
    -m 4G \
    -monitor stdio \
    -name win-vm \
    -device usb-ehci,id=ehci \
    -device usb-tablet,bus=ehci.0
''
