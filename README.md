#Deeplearning4j images for cuda and hadoop.

Deeplearning4j development environment for hadoop and spark:
Below are the folders for:

1. deeplearning4j: This is a folder for building deeplearning4j from source. 
2. hadoop-docker: full blown hdfs and yarn bundled with cuda
3. spark: a functional spark 1.6.2 installation that can be used for spark slave and master bundled with cuda connecting to hadoop.
4. compose: a sample spark/hadoop cluster, for running gpus in compose use: https://github.com/eywalker/nvidia-docker-compose

Versions:
Spark 1.6.2
Cuda 8
Cudnn 5.0
Hadoop 2.7.2
Openblas current master
Hadoop and spark compiled with java 8
Spark/scala version: 2.11


#Downloading
##Dl4j (WARNING THIS IS an 8GB download)
```
docker pull skymindio-docker-dl4j-dev-environment.bintray.io/skymindio/dl4j-dev-environment
```
##Spark
```
docker pull skymindio-docker-dl4j-spark.bintray.io/skymindio/dl4j-spark
```


##Hadoop
```
docker pull skymindio-docker-dl4j-hadoop.bintray.io/skymindio/dl4j-hadoop
```
