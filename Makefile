export CONTAINER_NAME = wakachigaki-docker-py


.PHONY: build
build: ## build dockerfile
	docker build -f Dockerfile -t $(CONTAINER_NAME) .


.PHONY: void
void: ## run with bash
	@make build
	docker run -it --rm \
		-v `pwd`:/work \
		$(CONTAINER_NAME) \
		/bin/bash


.PHONY: run
run: ## run dockerfile
	@make build
	docker run -it --rm \
		-v `pwd`:/work \
		$(CONTAINER_NAME) \
		python ./test.py