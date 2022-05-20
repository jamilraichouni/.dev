get_ipython().run_line_magic("load_ext", "autoreload")
get_ipython().run_line_magic("autoreload", "2")
try:
    get_ipython().run_line_magic("load_ext", "dotenv")
    get_ipython().run_line_magic("dotenv", "")
except Exception:
    print("Run 'pip install python-dotenv' for magic-command 'dotenv'")
# get_ipython().run_line_magic("pdb", "on")
