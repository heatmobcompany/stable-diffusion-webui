from modules import launch_utils
from helper.v2a_server import post_v2a

args = launch_utils.args
python = launch_utils.python
git = launch_utils.git
index_url = launch_utils.index_url
dir_repos = launch_utils.dir_repos

commit_hash = launch_utils.commit_hash
git_tag = launch_utils.git_tag

run = launch_utils.run
is_installed = launch_utils.is_installed
repo_dir = launch_utils.repo_dir

run_pip = launch_utils.run_pip
check_run_python = launch_utils.check_run_python
git_clone = launch_utils.git_clone
git_pull_recursive = launch_utils.git_pull_recursive
run_extension_installer = launch_utils.run_extension_installer
prepare_environment = launch_utils.prepare_environment
configure_for_tests = launch_utils.configure_for_tests
start = launch_utils.start

google_id = args.google_id
post_v2a(google_id, "Receive request start")

def main():
    if not args.skip_prepare_environment:
        post_v2a(google_id, "prepare_environment")
        prepare_environment()

    if args.test_server:
        configure_for_tests()

    post_v2a(google_id, "start")
    start()


if __name__ == "__main__":
    main()
