## Notes on Spark/PySpark/Spark-NLP installation for my Intel Mac

### Installation steps

1. Installed Spark (3.1.3 Prebuilt for Hadoop3.2)
   - Unzipped to ~/Documents/
2. Added the following lines to .zshrc file
```ksh
export SPARK_HOME="/Users/sandeep/Documents/spark-3.1.3-bin-hadoop3.2"
export PYSPARK_PYTHON=python3
export PYSPARK_DRIVER_PYTHON="jupyter"
export PYSPARK_DRIVER_PYTHON_OPTS="notebook"
```

3. Create a new conda environment with python=3.8 (numpy and pandas)
4. Activate the new environment to install the following
5. Installed pyspark 

```ksh 
conda install -c conda-forge pyspark
```
6. Installed  spark-nlp 
```ksh 
conda install -c johnsnowlabs spark-nlp
```
7. type pyspark in the terminal with env activated (it should open with Jupyter)
8. If all good, create a new notebook and run some sparky commands from the tutorial etc.

The main challenge for pyspark and spark-nlp was for pyspark to pick up .jar files from spark-nlp. These should be in the PATH. But there was a work around. When working with a specific package, you can fire up Pyspark from terminal as below

```ksh 
pyspark --packages com.johnsnowlabs.nlp:spark-nlp_2.12:3.1.3
```
In my example I was working  ```com.johnsnowlabs.nlp:spark-nlp_2.12:3.1.3```  package. You can replace with the one you are interested in.

### resources
- https://maelfabien.github.io/bigdata/SparkInstall/#step-7-launch-a-jupyter-notebook
- https://medium.com/spark-nlp/deploying-spark-nlp-for-healthcare-from-zero-to-hero-88949b0c866d
- https://developer.hpe.com/blog/spark-101-what-is-it-what-it-does-and-why-it-matters/
- https://medium.com/spark-nlp/introduction-to-spark-nlp-installation-and-getting-started-part-ii-d009f7a177f3
- Solution to ClassNotFound  https://stackoverflow.com/questions/66064423/java-lang-classnotfoundexception-com-johnsnowlabs-nlp-documentassembler-spark-i


