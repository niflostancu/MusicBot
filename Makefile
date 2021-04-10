# Makefile for building the image and test running it

IMAGE_NAME=niflostancu/discord-musicbot
IMAGE_TAGS = latest

build:
	docker build $(BUILD_ARGS) -t $(IMAGE_NAME) -f Dockerfile .
	$(foreach TAG,$(IMAGE_TAGS),docker tag $(IMAGE_NAME) $(IMAGE_NAME):$(TAG) ;)

build_force: BUILD_ARGS+= --pull --no-cache
build_force: build

push:
	docker push $(IMAGE_NAME):latest
	$(foreach TAG,$(IMAGE_TAGS),docker push $(IMAGE_NAME):$(TAG);)

run:
	docker run --rm -it -v "$(shell pwd)/config:/home/discord/config" "$(IMAGE_NAME)"

run_readonly:
	docker run --rm -it -v "$(shell pwd)/config:/home/discord/config.ro" "$(IMAGE_NAME)"

