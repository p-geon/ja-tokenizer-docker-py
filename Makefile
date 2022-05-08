export CONTAINER_NAME = wakachigaki-docker-py
export DIR_NEOLOGD = /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd


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
		python ./test.py \
			--text "ピジョンとジョン・レノンが融合してピジョンレノンに成った。" \
			--dir_dict $(DIR_NEOLOGD)


.PHONY: mecab
mecab: ## tap mecab directly
	mecab -d $(DIR_NEOLOGD) \