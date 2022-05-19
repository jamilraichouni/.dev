"""Kitten that fuzzy finds any information from KeePassXC."""

# Standard library:
import os
import subprocess
import sys
import typing as t
import webbrowser
from pathlib import Path

# 1st party:
from kitty.boss import Boss  # type: ignore

# to be able to use 3rd party pkgs from system python:
sys.path.insert(
    0, "/Library/Frameworks/Python.framework/Versions/3.10/lib/python3.10/site-packages"
)
# 3rd party:
from pyfzf.pyfzf import FzfPrompt  # noqa

DB_PATH = Path.home() / "My Drive" / "jamil.kdbx"
FZF_EXE = "/usr/local/bin/fzf"
KEYPASSXC_EXE = "/Applications/KeePassXC.app/Contents/MacOS/keepassxc-cli"
MASTER_SECRET = (
    Path(Path.home() / ".config/kitty/mastersecret").read_text().replace("\n", "")
)


def _attr_value_of_secret(secret: str, option: str) -> t.Optional[str]:
    if option in (
        "bookmark",
        "file",
        "url",
    ):
        attr_name = "URL"
    elif option == "user":
        attr_name = "UserName"
    elif option == "password":
        attr_name = "Password"
    else:
        return None
    val = None
    cmd = [
        KEYPASSXC_EXE,
        "show",
        "--quiet",
    ]
    if option == "password":
        cmd.append("--show-protected")
    cmd += [str(DB_PATH), secret]
    stdout, stderr = subprocess.Popen(
        cmd,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
    ).communicate(MASTER_SECRET.encode())
    if stderr:
        _error(stderr.decode())
        return None
    key = f"{attr_name}:"
    attrs = [
        attr.split(key)[1]
        for attr in stdout.decode().splitlines()
        if attr.startswith(key)
    ]
    if attrs and attrs[0].strip():
        val = attrs[0]
    else:
        _error(f"The entry '{secret}' has no filled attribute '{attr_name}'!")
    return val


def _error(msg: str) -> None:
    input(f"{msg}\nPress Enter to quit...")


def select_secret(option: str) -> t.Optional[str]:
    """Select secret from any of all KeePassXC entries that have a user name."""
    secret = None
    stdout, stderr = subprocess.Popen(
        [
            KEYPASSXC_EXE,
            "ls",
            "--quiet",
            "--recursive",
            "--flatten",
            str(DB_PATH),
        ],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
    ).communicate(MASTER_SECRET.encode())
    if stderr:
        _error(stderr.decode())
        return None
    items = [i for i in stdout.decode().splitlines() if not i.endswith("/")]
    if items and option in (
        "bookmark",
        "file",
    ):
        items = [
            item
            for item in items
            if item.startswith(f"Assets/{option.capitalize()}s/")
            and not item.endswith("[empty]")
        ]
    fzf = FzfPrompt(FZF_EXE)
    secret = fzf.prompt(items)
    if secret:
        secret = secret[0]
    else:
        secret = None
    return secret


def main(args: list[str]) -> t.Optional[str]:
    """Entrypoint called when kitten is being executed.

    Parameters
    ----------
    args : optional
        Arguments passed to this kitten

    """
    if len(args) != 2:
        return _error("Invalid number of arguments passed to kitten!")
    elif (option := args[1].lower().strip()) not in (
        "bookmark",
        "file",
        "password",
        "url",
        "user",
    ):
        return _error(
            f"Invalid argument '{args[1]}' passed to kitten. "
            "Expecting one out of 'bookmark', 'file', 'password', 'url', 'user'."
        )
    if not Path(FZF_EXE).exists():
        _error(f"Cannot find FZF at '{FZF_EXE}'!")
        return None
    if (secret := select_secret(option)) is None:
        return None
    answer = _attr_value_of_secret(secret, option)
    if answer is not None:
        answer = answer.strip()  # answer is an URL
    return answer


def handle_result(
    args: list[str],
    answer: str,
    target_window_id: int,
    boss: t.Optional[Boss] = None,  # type: ignore
) -> None:
    """Handle return value from ``main``."""
    option = args[1].lower().strip()
    if option == "bookmark":
        webbrowser.open(answer, autoraise=True)
    elif option == "file":
        subprocess.check_call(
            [
                "open",
                "-a",
                "Preview.app",
                f"{str(Path.home() / 'My Drive/assets')}/{answer}",
            ]
        )
    else:
        if boss is None:
            return
        w = boss.window_id_map.get(target_window_id)
        if w is not None:
            w.paste(answer.strip())
