import subprocess
import os
from git import Repo
import sys

# Adjust these
EXPORT_PRESET = "Web"       # Export preset name in Godot
EXPORT_TARGET = "build/html"  # Output folder for HTML build
PROJECT_DIR = os.path.abspath(os.path.dirname(__file__))  # repo root
GODOT_BIN = "godot"         # or full path to godot executable

def export_html():
    os.makedirs(EXPORT_TARGET, exist_ok=True)
    cmd = [
        GODOT_BIN,
        "--headless",
        "--path", PROJECT_DIR,
        "--verbose",
        "--export-release", EXPORT_PRESET,
        os.path.join(EXPORT_TARGET, "index.html")
    ]
    print("Running:", " ".join(cmd))
    result = subprocess.run(cmd, cwd=PROJECT_DIR,
                             capture_output=True, text=True)
    print("---- STDOUT ----")
    print(result.stdout or "[no stdout]")
    print("---- STDERR ----")
    print(result.stderr or "[no stderr]")
    if result.returncode != 0:
        print("Export failed (exit code", result.returncode, ")")
        sys.exit(result.returncode)
    print("HTML export successful")

def git_push(commit_msg="HTML build updated"):
    repo = Repo(PROJECT_DIR)
    repo.git.add(all=True)
    if repo.is_dirty(index=True, working_tree=False, untracked_files=True):
        print("Changes detected: committing & pushing")
        repo.index.commit(commit_msg)
        origin = repo.remote(name="origin")
        origin.push()
        print("Push complete")
    else:
        print("No changes to commit")

if __name__ == "__main__":
    export_html()
    # git_push()