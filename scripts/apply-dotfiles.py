#!/usr/bin/env python3
from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
from datetime import datetime
from pathlib import Path

DEFAULT_MODULES = ["zsh", "tmux", "git", "nvim", "kitty", "bin"]


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Apply dotfiles modules with stow or a symlink fallback.")
    p.add_argument("--repo", default=str(Path(__file__).resolve().parents[1]))
    p.add_argument("--target", default=str(Path.home()))
    p.add_argument("modules", nargs="*", default=DEFAULT_MODULES)
    return p.parse_args()


def rel_files(module_root: Path):
    for path in sorted(module_root.rglob("*")):
        if path.is_file() or path.is_symlink():
            yield path.relative_to(module_root)


def is_owned_link(path: Path, repo: Path) -> bool:
    if not path.is_symlink():
        return False
    try:
        return path.resolve().is_relative_to(repo.resolve())
    except AttributeError:
        return str(path.resolve()).startswith(str(repo.resolve()))


def apply_fallback(repo: Path, target: Path, modules: list[str]) -> None:
    stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    for module in modules:
        module_root = repo / module
        if not module_root.is_dir():
            continue
        print(f"   -> Linking {module} with fallback symlinker")
        for rel in rel_files(module_root):
            src = module_root / rel
            dst = target / rel
            dst.parent.mkdir(parents=True, exist_ok=True)
            if dst.exists() or dst.is_symlink():
                try:
                    if dst.resolve() == src.resolve():
                        continue
                except OSError:
                    pass
                if is_owned_link(dst, repo):
                    dst.unlink()
                else:
                    backup = dst.with_name(dst.name + f".pre-dotfiles-{stamp}")
                    print(f"      backing up {dst} -> {backup}")
                    shutil.move(str(dst), str(backup))
            dst.symlink_to(src)


def main() -> int:
    a = parse_args()
    repo = Path(a.repo).resolve()
    target = Path(a.target).resolve()
    modules = a.modules

    stow = shutil.which("stow")
    if stow:
      print("🔗 Linking configurations with GNU Stow...")
      subprocess.run([stow, "-R", "-t", str(target), *modules], cwd=repo, check=True)
      return 0

    print("🔗 GNU Stow not found; using built-in symlink fallback...")
    apply_fallback(repo, target, modules)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
