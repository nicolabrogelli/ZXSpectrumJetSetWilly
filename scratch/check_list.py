import re

with open("jet set willy.list", "r") as f:
    lines = f.readlines()

for line in lines:
    if "datavariable.asm" in line or "clock" in line or "counter" in line or "fdf0" in line:
        print(line.strip()[:100])
