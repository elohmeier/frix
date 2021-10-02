#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3 -p nasm

from subprocess import Popen, PIPE
from tempfile import TemporaryDirectory


def nasm(code: str) -> str:
    with TemporaryDirectory() as tdir:
        with open(f"{tdir}/input", "wb") as ifp:
            ifp.write(code.encode())
        with Popen(
            ["nasm", "-o", f"{tdir}/output", f"{tdir}/input"], stdout=PIPE
        ) as proc:
            err = proc.stdout.readline().decode()
            if err != "":
                print(err)
            if proc.wait() != 0:
                return ""

        with Popen(["ndisasm", f"{tdir}/output"], stdout=PIPE) as proc:
            return proc.stdout.readline().decode()


if __name__ == "__main__":
    while True:
        try:
            line = input("> ")
        except KeyboardInterrupt:
            break
        print(nasm(line))
