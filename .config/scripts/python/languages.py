#!/usr/bin/env python3

from shutil import which
from subprocess import run, CalledProcessError
from platform import system
from sys import exit
from tempfile import gettempdir
import requests


def go_get_latest_releases() -> str:
    """
    get latest golang release based on golang/go ref/tags (only works for go1.* for now)
    """
    headers = {"Accept": "application/vnd.github.v3+json"}
    params = {"per_page": 20, "page": 1}

    print("checking golang tags: go1.*")
    rsp = requests.get(
        url="https://api.github.com/repos/golang/go/git/matching-refs/tags/go1.",
        headers=headers,
        params=params,
    )
    if rsp.status_code != 200:
        print(f"github api returned a non 200: {rsp.status_code}")
        exit(1)

    tags = rsp.json()
    max_tag_index = len(tags) - 1
    release: str
    first_tag = 0

    print("gather latest stable tag")
    while True:
        git_tag = tags[max_tag_index - first_tag]
        if git_tag.ref and "rc" not in git_tag.ref and "beta" not in git_tag.ref:
            splitted_release = "".split("/")
            release = splitted_release[len(splitted_release) - 1]
            break

        first_tag += 1

    return release


def go_install_release(release: str):
    """
    Gather golang release from go.dev website and install it onto the system (MacOS and Linux)
    """
    plateform_name = system()
    os_suffix: str
    if plateform_name == "linux":
        os_suffix = ".linux-amd64.tar.gz"
    else:
        os_suffix = ".darwin-amd64.pkg"

    print(f"downloading release: {release}{os_suffix}")
    rsp = requests.get(url=f"https://go.dev/dl/{release}{os_suffix}")

    if rsp.status_code != 200:
        print(
            f'failed to gather golang release "{release}{os_suffix}": {rsp.status_code}'
        )
        exit(1)

    file_path = f"{gettempdir()}/{release}{os_suffix}"
    with open(file_path, "xb") as f:
        f.write(rsp.content)

    if plateform_name == "linux":
        try:
            run(
                args=f"sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz",
                check=True,
                shell=True,
            )
        except:
            print(f"failed to install golang binary: {error}")
            exit(1)
    else:
        try:
            run(
                args=f"sudo installer -pkg {file_path} -target /",
                check=True,
                shell=True,
            )
        except CalledProcessError as error:
            print(f"failed to install golang package: {error}")
            exit(1)


if __name__ == "__main__":
    while True:
        version: str
        if not which("go"):
            version = go_get_latest_releases()
            go_install_release(version)
        else:
            try:
                output = (
                    run(args="go version", check=True, shell=True, capture_output=True)
                    .stdout.decode()
                    .split(" ")
                )
                if len(output) < 3:
                    print('invalid STDOUT from "go version"')
                    exit(1)

                version = output[2]

            except CalledProcessError as error:
                print(f"failed to fetch golang installed version: {error}")
                exit(1)
