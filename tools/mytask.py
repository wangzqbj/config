#!/usr/bin/python3

import os
import sys
import tempfile
import yaml
from gitlab import Gitlab
from typing import TypedDict
from subprocess import call

import ssl
ssl._create_default_https_context = ssl._create_unverified_context


def getConfigFile() -> str:
    home_dir = os.environ.get("HOME")
    xdg_config_home = os.environ.get("XDG_CONFIG_HOME", f"{home_dir}/.config")
    return f"{xdg_config_home}/mytask/mytask.yml"


class Issue():
    def __init__(self, cfg: TypedDict, gl: Gitlab):
        self.cfg = cfg
        self.gl = gl
        pass

    def __parse_edited_message(self, tf):
        title = ""
        for line in tf:
            if not line.strip():
                break
            title += line
        self.title = title.strip()
        description = ""
        for line in tf:
            if line.startswith("##########"):
                break
            description += line
        self.description = description.rstrip()

    def create(self):
        EDITOR = os.environ.get('EDITOR', 'vim')
        initial_message = f"""


##########
" vim:set ft=gitcommit:"""
        with tempfile.NamedTemporaryFile(mode='w+', suffix=".tmp") as tf:
            tf.write(initial_message)
            tf.flush()
            call([EDITOR, tf.name])
            tf.seek(0)
            self.__parse_edited_message(tf)

    def submit(self, project_name: str):
        if not self.title:
            print("title is empty, ignore...")
            return
        project = self.gl.projects.get(project_name)
        issue = project.issues.create(
            {'title': self.title, 'description': self.description})
        issue.save()


def main():
    with open(getConfigFile()) as ymlfile:
        cfg = yaml.load(ymlfile, Loader=yaml.FullLoader)
    url = cfg["Host"]["url"]
    private_token = cfg["Host"]["private_token"]
    project_name = cfg["Project"]["name"]
    gl = Gitlab(url=url,
                private_token=private_token, ssl_verify=False)
    gl.auth()

    issue = Issue(cfg, gl)
    issue.create()
    issue.submit(project_name)


if __name__ == "__main__":
    main()
