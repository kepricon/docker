SHELL := /bin/bash

# run 'make clean' to get a fresh start on everything ; if you don't, this is
# still a meaninful target, but you won't be starting 'from zero'
build:
	$(MAKE) -C ./jdk build
	$(MAKE) -C ./deeplearning4j build

push:
	$(MAKE) -C ./jdk push
	$(MAKE) -C ./deeplearning4j push

# wipe all related containers and images
clean: 
	- docker ps -aq | xargs docker rm -f
	- docker rmi -f `docker images -q -f "label=vendor=skymind"`
	- docker rmi `docker images -q -f "dangling=true"`

