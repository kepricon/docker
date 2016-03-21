IMAGE := skymind/jdk:8

build:
	docker build --rm=false -t $(IMAGE) .

push:
	docker push $(IMAGE)

clean:
	- docker rmi `docker images -f "label=vendor=skymind" -f "label=name=jdk"`

