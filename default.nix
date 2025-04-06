{ pkgs ? import <nixpkgs> {} }:
with pkgs; let
  replaces = {
    "#!/bin/bash" = ''
      #!/bin/env ${lib.getExe bash}
      export PATH=$PATH:${lib.makeBinPath [
        findutils
      ]}
    '';
    "nasm" = lib.getExe' coreboot-toolchain.x64 "nasm";
    " ld " = " ${lib.getExe' coreboot-toolchain.x64 "x86_64-elf-ld"} ";
    "aarch64-linux-gnu-as" = lib.getExe' coreboot-toolchain.aarch64 "aarch64-elf-as";
    "aarch64-linux-gnu-ld" = lib.getExe' coreboot-toolchain.aarch64 "aarch64-elf-ld";
    "arm-none-eabi-as" = lib.getExe' coreboot-toolchain.arm "arm-eabi-as";
    "arm-none-eabi-ld" = lib.getExe' coreboot-toolchain.arm "arm-eabi-ld";
    "\"upgrade\")" = "\"upgrade\") echo \"upgrade command doesn't available in nix version\" >&2; exit 1;";
  };
  executable = lib.pipe ./src/basham.sh [
    (lib.fileContents)
    (lib.replaceStrings (lib.attrNames replaces) (lib.attrValues replaces))
    (writeScriptBin "basham.sh")
  ];
in executable
