# ubuntu-spark

ubuntu 16.04 hadoop 3.1.1 spark 2.4.0

```bash
$ sudo docker run -dit --name [spark-container-name] --network [network-hadoop-container-is-connected] [image-name] /bin/bash
```
or
```bash
$ ./run_spark.sh [network-name] [spark-container-name]
```
if `./run_spark.sh` fails with Permission denied error,
```bash
# chmod +x run_spark.sh
```
<br/>

### run container
```
$ docker exec -it [spark-container-name] bash
```
<br/>

### run spark-shell in client mode
```bash
# spark-shell --master yarn --deploy-mode client
```
or
```bash
# cd /usr/local/spark/
# ./run-sparkshell.sh
```

### quit spark-shell
`:quit` or ctrl+D

---

Check if master and slaves are connected.
Lists all running nodes.
```bash
# yarn node -list
```


if spark-shell gets stuck, check running applications and kill unnecessary ones.
```bash
# yarn application -list
# yarn application -kill [application-id]
```

---


install sbt which is a build tool.<br/>
[sbt install](https://www.scala-sbt.org/1.0/docs/Installing-sbt-on-Linux.html)

```bash
# echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list  
# sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823  
# sudo apt-get update  
# sudo apt-get install sbt
```

---


if `sudo apt-get update` fails with `E: The method driver /usr/lib/apt/methods/https could not be found.`
```bash
# sudo apt-get install apt-transport-https
```
