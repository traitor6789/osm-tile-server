.PHONY: build push test

DOCKER_IMAGE=mstr6789/india:1.0.0
build:
	docker build -t ${DOCKER_IMAGE} .

push: build
	docker push ${DOCKER_IMAGE}:latest

test: build
	docker volume create openstreetmap-data
	docker volume create openstreetmap-rendered-tiles
	docker run --rm -v openstreetmap-data:/var/lib/postgresql/12/main ${DOCKER_IMAGE} import
	docker run --rm -v openstreetmap-data:/var/lib/postgresql/12/main -p 8080:80 -d ${DOCKER_IMAGE} run

stop:
	docker rm -f `docker ps | grep '${DOCKER_IMAGE}' | awk '{ print $$1 }'` || true
	docker volume rm -f openstreetmap-data
	docker volume rm -f openstreetmap-rendered-tiles
