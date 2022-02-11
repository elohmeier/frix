# frix

fraam nix configurations


## Running a Windows VM

Run the command `nix run .#run-win-vm` from the frix folder.
If you don't have the VM image in your Nix store already, Nix will download it for you.
The download progress might not be visible from the Nix output, you can run the following
command prior to running the above command to prefetch the VM image:
`nix-prefetch-url https://download.microsoft.com/download/9/0/8/90881435-55c1-4cf2-81f8-aae807702467/WinDev2112Eval.HyperVGen1.zip` (look up the concrete url from `./5pkgs/windows-vm-image/default.nix`).
The preparation of the VM image requires a image format conversion to qcow2 which requires 
around 40GiB of temporary space in `/tmp`. Ensure you have enough space available.
You can modify the size of a mounted tmpfs using e.g. the command `sudo mount -o remount,size=40G /tmp`.

