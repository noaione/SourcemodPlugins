"""
MIT License

Copyright (c) 2019-2021 noaione

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

import os
import shutil
import subprocess as sp
import time
from pathlib import Path
from typing import List

base_dir = Path(__file__).absolute().parent.parent
build_dir = base_dir / "build"
build_dir.mkdir(exist_ok=True)
print(f"📜 Working directory: {base_dir}")

plugins = list((base_dir / "plugins").glob("*"))
print(f"📍 Found {len(plugins)} plugins!")


def parse_extract_sp(sp_result: bytes):
    decoded = sp_result.decode("utf-8")
    lines = decoded.split("\n")

    valid_lines = {
        "code": "0 bytes",
        "data": "0 bytes",
    }
    for line in lines:
        if "size" in line.casefold():
            split_l = line.strip().split(" ")
            slast = " ".join(split_l[-2:])
            if split_l[0].casefold() in valid_lines:
                valid_lines[split_l[0].lower()] = slast
    return valid_lines


def find_error(sp_result: bytes):
    decoded = sp_result.decode("utf-8")

    lines = decoded.split("\n")
    error_thing: List[str] = []
    for ix, line in enumerate(lines):
        if ix == 0:
            continue
        if "copyright (c)" in line.casefold():
            continue
        if "size" in line.casefold():
            continue
        if line.strip() == "":
            continue
        error_thing.append(line.strip())
    return "\n".join(error_thing)


def execute_build(entry: Path):
    mono_start = time.monotonic()
    p = sp.Popen(
        ["spcomp", f"scripting/{entry.name}"],
        stdout=sp.PIPE,
        stderr=sp.PIPE,
    )

    out, _ = p.communicate()
    rc = p.returncode
    mono_end = time.monotonic()
    delta = mono_end - mono_start
    if rc == 0:
        print(f"=> 📦 => 🔨 Build {entry.name} successful! (done in {delta:.2f}s)")
        metadata = parse_extract_sp(out)
        smx_file_candidate = [
            entry.parent / f"{entry.stem}.smx",
            entry.parent.parent / f"{entry.stem}.smx",
        ]
        print(f"=> 📦 => 🔨 => 📊 Code size: {metadata['code']}")
        print(f"=> 📦 => 🔨 => 📊 Compiled size: {metadata['data']}")
        smx_file: Path = None
        for file in smx_file_candidate:
            if file.exists():
                smx_file = file
                break
        return smx_file
    error = find_error(out)
    print(f"=> 📦 => 🔨 => 💥 Build {entry.name} failed!")
    print(f"=> 📦 => 🔨 => 💥 Trace:\n{error}")
    return None


def build_plugin(plugin: Path):
    print(f"=> 📦 Packaging: {plugin.name}")
    collect_script = list(plugin.glob("scripting/*.sp"))
    main_script: Path = None
    for path in collect_script:
        if path.name.casefold() == plugin.name.casefold() + ".sp":
            main_script = path
            break
    if main_script is None:
        print("=> 📦 => ⚠️ Unable to find script entrypoint!")
        return

    target_dir = build_dir / plugin.name / "addons"
    target_dir.mkdir(parents=True, exist_ok=True)

    include_folder = plugin / "scripting" / "include"
    scripting_folder = target_dir / "scripting"
    scripting_folder.mkdir(exist_ok=True)
    target_include_folder: Path = None
    if include_folder.exists():
        target_include_folder = target_dir / "scripting" / "include"
        target_include_folder.mkdir(parents=True, exist_ok=True)

    print(f"=> 📦 => 🔨 Building: {main_script.name}")
    os.chdir(plugin)
    final_smx = execute_build(main_script)
    if final_smx is None:
        return
    for script in collect_script:
        shutil.copyfile(script, scripting_folder / script.name)
    if target_include_folder is not None:
        for include in include_folder.glob("*.inc"):
            shutil.copyfile(include, target_include_folder / include.name)

    target_smx = target_dir / "plugins"
    target_smx.mkdir(parents=True, exist_ok=True)
    shutil.move(final_smx, target_smx / final_smx.name)


for plugin in plugins:
    build_plugin(plugin)

os.chdir(base_dir)

git_ref = os.getenv("GITHUB_REF")
tag_ref: str = None
if git_ref:
    if git_ref.startswith("refs/tags/"):
        tag_ref = git_ref.replace("refs/tags/", "")

if tag_ref:
    print("🎁 Wrapping up build in zip file")
    shutil.make_archive(f"N4O_Sourcemod_Plugins_{tag_ref}", "zip", build_dir)

print("🎉 Build finished!")
