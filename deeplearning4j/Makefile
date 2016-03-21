IMAGE := skymind/deeplearning4j:latest

build:
	docker build --rm=false -t $(IMAGE) .

push:
	docker push $(IMAGE)

clean:
	- docker rmi `docker images -f "label=vendor=skymind" -f "label=name=deeplearning4j"`

