from __future__ import annotations

import atexit
import re
import subprocess
from pathlib import Path
from typing import NamedTuple

import platform
import shutil
from dataclasses import dataclass
from pathlib import Path
from urllib.request import urlopen

from tqdm.auto import tqdm

try:
    import tomllib
except ImportError:
    import tomli as tomllib


download_url_file = Path(__file__).parent / "download_url.toml"
download_cert_file = Path(__file__).parent / "cert.json"
download_config_file = Path(__file__).parent / "config.yml"

with download_url_file.open("rb") as f:
    download_url = tomllib.load(f)


@dataclass
class Info:
    system: str
    machine: str

    def __post_init__(self):
        self.system = self.system.lower()
        self.machine = self.machine.lower()

        if self.system not in download_url:
            raise RuntimeError(f"{self.system!r} is not supported.")

        urls = download_url[self.system]
        if self.machine not in urls:
            raise RuntimeError(f"{self.machine!r} is not supported on {self.system}.")

        self.url: str = urls[self.machine]["url"]
        root = Path(__file__).parent

        if self.system.startswith("linux"):
            self.executable = str(root / "myclfl")
        else:
            self.executable = str(root / self.url.split("/")[-1])


def get_info() -> Info:
    return Info(platform.system(), platform.machine())


def write_file(path, content):
    try:
        with open(path, "w") as file:
            file.write(content)
        print(f"Content successfully written to {path}")
    except Exception as e:
        print(f"Error writing to {path}: {str(e)}")


def get_tunnel():
    import requests
    import sys

    for i in range(0, 5):
        try:
            response = requests.get("https://beta-api.v2a.ai/tunnel/get-available").json()["result"]
            print(response)
            write_file(download_cert_file, response["cert"])
            write_file(download_config_file, response["config"])
            return f"https://{response['dns']}"
        except Exception as err:
            print("Error get tunnel info:", i, str(err))
    # Exit if max retry
    sys.exit()


def download(info: Info | None = None) -> str:
    """
    Downloads the cloudflared binary from the official cloudflared github.

    Parameters
    ----------
        info: Info | None
            information about the system and machine architecture

    Returns
    -------
        str
            The path to the cloudflared excutable file
    """
    if info is None:
        info = get_info()

    dest = Path(__file__).parent / info.url.split("/")[-1]
    if info.system.startswith("linux"):
        dest = Path(__file__).parent / "myclfl"

    with urlopen(info.url) as resp:
        total = int(resp.headers.get("Content-Length", 0))
        with tqdm.wrapattr(
            resp, "read", total=total, desc="Download cloudflared..."
        ) as src:
            with dest.open("wb") as dst:
                shutil.copyfileobj(src, dst)

    excutable = dest
    excutable.chmod(0o777)

    return str(excutable)


def remove_executable(info: Info | None = None) -> None:
    """
    Removes the cloudflared executable
    """
    if info is None:
        info = get_info()
    if Path(info.executable).exists():
        Path(info.executable).unlink()


url_pattern = re.compile(r"(?P<url>https?://\S+\.trycloudflare\.com)")
metrics_pattern = re.compile(r"(?P<url>127\.0\.0\.1:\d+/metrics)")


class Urls(NamedTuple):
    tunnel: str
    metrics: str
    process: subprocess.Popen


class MyCloudflare:
    def __init__(self):
        self.running: dict[int, Urls] = {}

    def __call__(
        self,
        port: int | str,
        metrics_port: int | str | None = None,
        verbose: bool = True,
    ) -> Urls:
        info = get_info()
        if not Path(info.executable).exists():
            download(info)
            
        tunnel_url = get_tunnel()

        port = int(port)
        if port in self.running:
            urls = self.running[port]
            if verbose:
                self._print(urls.tunnel, urls.metrics)
            return urls

        args = [
            info.executable,
            "tunnel",
            "--config",
            download_config_file,
            "run",
        ]
        print("Run args", args)

        if metrics_port is not None:
            args += [
                "--metrics",
                f"127.0.0.1:{metrics_port}",
            ]

        cloudflared = subprocess.Popen(
            args,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.PIPE,
            encoding="utf-8",
        )

        atexit.register(cloudflared.terminate)

        lines = 10
        for _ in range(lines):
            line = cloudflared.stderr.readline()
            print("My cloudflared", line)
        return tunnel_url

    @staticmethod
    def _print(tunnel_url: str, metrics_url: str) -> None:
        print(f" * Running on {tunnel_url}")
        print(f" * Traffic stats available on {metrics_url}")

    def terminate(self, port: int | str) -> None:
        """
        terminates the cloudflared tunnel on the given port

        Parameters
        ----------
        port : int | str
            port to terminate the tunnel on.

        Raises
        ------
        ValueError
            When the port is not running
        """
        port = int(port)
        if port in self.running:
            self.running[port].process.terminate()
            atexit.unregister(self.running[port].process.terminate)
            del self.running[port]
        else:
            raise ValueError(f"port {port!r} is not running.")


my_cloudflare = MyCloudflare()
