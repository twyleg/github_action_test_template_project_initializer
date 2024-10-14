# Copyright (C) 2024 twyleg
# fmt: off
import subprocess

import pytest

import logging
import pygit2
import shutil
from pathlib import Path

from _pytest.monkeypatch import MonkeyPatch

#
# General naming convention for unit tests:
#               test_INITIALSTATE_ACTION_EXPECTATION
#


FILE_DIR = Path(__file__).parent


def prepare_test_project_git_repo(test_project_path: Path) -> None:
    git_file_from_submodule = test_project_path / ".git"
    git_file_from_submodule.unlink()

    test_project_name = test_project_path.name
    test_project_dummy_remote_url = f"git@github.com:twyleg/{test_project_name}.git"
    test_project_repo = pygit2.init_repository(test_project_path, False)
    test_project_repo.remotes.create("origin", test_project_dummy_remote_url)


def create_test_project_from_template_and_chdir(template_project_src_dir_path: Path,
                                                template_project_dst_dir_path: Path,
                                                monkeypatch: MonkeyPatch) -> Path:
    template_project_dst_dir_path = template_project_dst_dir_path / template_project_src_dir_path.name
    shutil.copytree(template_project_src_dir_path, template_project_dst_dir_path)
    monkeypatch.chdir(template_project_dst_dir_path)
    prepare_test_project_git_repo(template_project_dst_dir_path)
    return template_project_dst_dir_path


def init_template(project_dir_path: Path) -> None:
    cmd = [
        "template_project_utils",
        "template_project_python=new_project_name",
        "template-project-python=new-project-name"
    ]
    subprocess.run(cmd, cwd=project_dir_path)


def run_tester(project_dir_path: Path) -> int:
    env = {
        "INPUT_SEARCH_KEYWORDS": "template_project_python,template-project-python",
        "INPUT_EXCLUDE_DIRS": ".git/,venv/,.tox/,.mypy_cache/,.idea/,build/,dist/,__pycache__/,*.egg-info/,logs/"
    }
    completed_process = subprocess.run(FILE_DIR / "../run_test.sh", cwd=project_dir_path, env=env)
    return completed_process.returncode


@pytest.fixture
def valid_template_project_python(tmp_path, monkeypatch):
    return create_test_project_from_template_and_chdir(
        FILE_DIR / "../external/template_project_python",
        tmp_path,
        monkeypatch
    )


@pytest.fixture
def invalid_template_project_python_with_unexpected_file_entry(tmp_path, monkeypatch):
    project_dir = create_test_project_from_template_and_chdir(
        FILE_DIR / "../external/template_project_python",
        tmp_path,
        monkeypatch
    )

    with open(project_dir / "test_file_a.txt", "a") as file:
        file.write('template_project_python\n')

    with open(project_dir / "test_file_b.txt", "a") as file:
        file.write('template-project-python\n')

    return project_dir


@pytest.fixture
def invalid_template_project_python_with_unexpected_dir(tmp_path, monkeypatch):
    project_dir = create_test_project_from_template_and_chdir(
        FILE_DIR / "../external/template_project_python",
        tmp_path,
        monkeypatch
    )

    unexpected_dir_path_a = project_dir / "foo/template_project_python"
    unexpected_dir_path_b = project_dir / "foo/template-project-python"

    unexpected_dir_path_a.mkdir(parents=True)
    unexpected_dir_path_b.mkdir(parents=True)

    return project_dir


class TestTester:
    def test_ValidTemplateProject_InitTemplateProjectAndRunTester_Success(
            self,
            valid_template_project_python):
        init_template(valid_template_project_python)
        assert run_tester(valid_template_project_python) == 0

    def test_InvalidTemplateProjectWithUnexpectedFileEntry_InitTemplateProjectAndRunTester_ErrorReturned(
            self,
            invalid_template_project_python_with_unexpected_file_entry):
        init_template(invalid_template_project_python_with_unexpected_file_entry)
        assert run_tester(invalid_template_project_python_with_unexpected_file_entry) == 1

    def test_InvalidTemplateProjectWithUnexpectedDir_InitTemplateProjectAndRunTester_ErrorReturned(
            self,
            invalid_template_project_python_with_unexpected_dir):
        init_template(invalid_template_project_python_with_unexpected_dir)
        assert run_tester(invalid_template_project_python_with_unexpected_dir) == 1
