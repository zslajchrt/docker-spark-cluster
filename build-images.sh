#!/bin/bash

set -e

docker build -t spark-base-graalvm:latest ./docker/base
docker build -t spark-master-graalvm:latest ./docker/spark-master
docker build -t spark-worker-graalvm:latest ./docker/spark-worker
docker build -t spark-submit-graalvm:latest ./docker/spark-submit