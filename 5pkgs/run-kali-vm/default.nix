{ writeShellScriptBin, kali-vm-image, qemu_kvm, virt-viewer }:

# for integration:
# 1. install spice-vdagent in kali vm using `sudo apt install spice-vdagent`
# 2. reboot or start service manually
# 3. resizing can be triggered by running `xrandr --output Virtual-1 --auto`
# see also https://itectec.com/superuser/linux-no-auto-resize-with-spice-and-virt-manager/
writeShellScriptBin "run-kali-vm" ''
  if [ ! -f kali-vm.qcow2 ]; then
    echo "generating kali-vm.qcow2 overlay image"
    ${qemu_kvm}/bin/qemu-img create \
      -f qcow2 kali-vm.qcow2 80G \
      -b "${kali-vm-image}/kali-vm-image.qcow2" -F qcow2
  else
    echo "reusing existing kali-vm.qcow2 overlay image, delete that file if you need a fresh kali environment"
  fi

  ${qemu_kvm}/bin/qemu-system-x86_64 \
    -daemonize \
    -nodefaults \
    -enable-kvm \
    -cpu host -smp 12 \
    -drive file=kali-vm.qcow2,if=virtio \
    -net nic -net user,hostname=kali-vm \
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
