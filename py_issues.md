
### Jupyter notebook cannot find the installed `sklearn` package
Basically, notebook was using a different Python kernel than the environment under which I had installed sci-kit learn. You can check this within the notebook with `import sys; sys.executable`. This will show the path to the Python executable that the notebook is relying upon. If you need to know the same for your environment. In a terminal, activate your `env`, fire up python, run `sys.executable` at the prompt after importing `sys`. 

This issue was fixed with the following two commands:

`pip install ipykernel` then `python -m ipykernel install --user --name=myenv`

Thanks to the following two sources: 
https://saturncloud.io/blog/running-jupyter-notebook-in-a-virtual-environment-installed-scikitlearn-module-not-available/#:~:text=If%20you%20encounter%20the%20error,and%20enable%20the%20ipykernel%20package.&text=pip%20install%20ipykernel-,Next%2C%20you'll%20need%20to%20install%20the,kernel%20for%20your%20virtual%20environment.

http://takluyver.github.io/posts/i-cant-import-it.html

### Removed Miniconda to install Python directly. 
Required the following:
1. Installed Python directly
2. Installed pyenv via brew
4. Install virtualenv
   
