#Deeplearning4j images for cuda and hadoop.

Deeplearning4j development environment for hadoop and spark:
Below are the folders for:

1. deeplearning4j: This is a folder for building deeplearning4j from source. 
2. hadoop-docker: full blown hdfs and yarn bundled with cuda. Make sure to mount a /data directory as a volume to hdfs. (see the hdfs-site.xml) 
- note also that if you use a volume you need to format the name node before you start the container. If you define a volume define a new entry point
with a mounted inithadoop.sh which will run the format for the container followed by the "real" entrypoint.
3. spark: a functional spark 1.6.2 installation that can be used for spark slave and master bundled with cuda connecting to hadoop.
4. compose: a sample spark/hadoop cluster, for running gpus in compose use: https://github.com/eywalker/nvidia-docker-compose
5. streamsets: this is for an ETL gui integrated with hadoop and spark.
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
docker pull skymindio-docker-dl4j-dev-environment.bintray.io/skymindio/dl4j-dev-environment:0.6.1-SNAPSHOT
```
##Spark
```
docker pull skymindio-docker-dl4j-spark.bintray.io/skymindio/dl4j-spark
```


##Hadoop
```
docker pull skymindio-docker-dl4j-hadoop.bintray.io/skymindio/dl4j-hadoop
```

##Streamsets
```
docker pull skymindio-docker-datacollecor.bintray.io/skymindio/datacollector
```