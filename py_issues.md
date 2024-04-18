
### Jupyter notebook cannot find the installed `sklearn` package
Basically, notebook was using a different Python kernel than the environment under which I had installed sci0kit learn. The issue was fixed with the following two commands 

`pip install ipykernel` then `python -m ipykernel install --user --name=myenv`

### Removed Miniconda to install Python directly. 
Required the following:
1. Installed Python directly
2. Installed pyenv via brew
4. Install virtualenv
   
