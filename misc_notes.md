

## git checkout
git clone --no-checkout https://github.com/American-Institutes-for-Research/dsaa-edmicrosim-income.git
git sparse-checkout init --cone
git sparse-checkout set disability
git checkout main


## Accessing Python packages in SPP
On the SPP-CI I have a workaround to install & access packages. 
This is not a solution to overcome the inability to set up new environments (with python.exe) but only to 
have access to new packages without having to ask IT to install. This is a weak solution not sure how this will work when there are dependencies across packages, etc. and is not also ideal because this is outside of the environment and will have to recorded separately I think (haven’t tested all that)
The workaround is to install packages (using pip) in `c:\users\lfname\AppData\Local\conda\conda\pkgs`  or any other folder (where you can write). 
Then append the above path to sys.path  first in your notebook and then import the names package and others. You can insert like this after importing sys
`sys.path.insert(0,'C:\\Users\\sshetty\\AppData\\Local\\conda\\conda\\pkgs')`
( conda install didn’t work, it was installing a bunch of stuff but pip  worked.)
 Code example
`pip install --target=c:\\users\\sshetty\\AppData\Local\\conda\\conda\\pkgs  python-igraph (edited)`


## how to run the KG + chatbot
1. in a terminal run neo4j docker with the secret code as used in the code docker run -p7687:7687  -e  NEO4J_AUTH=neo4j/secretgraph neo4j:5.20.0
2. in a separate terminal, cd to [learning/docker_neo4j] to construct the KG python create_kg_neo4j.py  This folder has the files from the chatbot project like
-bot/ 
-KG_construnction/
-create_kg_neo4j.py 
-3. in a third terminal, go the dsaa-KMIDS folder and run python app.py  to start the chatbot (edited) 

## *Mongo-DB**
`brew tap mongodb/brew`
`brew install mongodb-community@7.0`
`brew services start mongodb/brew/mongodb-community`
`brew services stop mongodb-community@7.0`
the last two commands will start & stop a background process. 
