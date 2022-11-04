import shutil
import subprocess

subprocess.run('flutter --version', shell=True, check=True)
subprocess.run('flutter clean', shell=True, check=True)
subprocess.run('flutter pub get', shell=True, check=True)
subprocess.run('flutter build web --release', shell=True, check=True)

shutil.copytree(
    src=r"E:\PROJECT\Flutter\sanjayrb\build\web",
    dst=r"E:\PROJECT\WebApp\sanjay-rb.github.io",
    dirs_exist_ok=True,
)

subprocess.run("git status", shell=True, cwd=r"E:\PROJECT\WebApp\sanjay-rb.github.io", check=True)
subprocess.run("git add --all", shell=True, cwd=r"E:\PROJECT\WebApp\sanjay-rb.github.io", check=True)
subprocess.run('git commit -m "new release from Sanjay R B"', shell=True, cwd=r"E:\PROJECT\WebApp\sanjay-rb.github.io", check=True)
subprocess.run("git push", shell=True, cwd=r"E:\PROJECT\WebApp\sanjay-rb.github.io", check=True)
