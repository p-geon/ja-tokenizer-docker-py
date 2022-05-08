export CONTAINER_NAME = wakachigaki-docker-py
export DIR_NEOLOGD = /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd
export BIN_ENTITY_VECTOR = /entity_vector/entity_vector.model.bin


.PHONY:
wakachigaki: ## wakachigaki
	docker run -it --rm \
		-v `pwd`:/work \
		$(CONTAINER_NAME) \
		python ./scripts/wakachigaki.py \
			--text "ピジョンとジョン・レノンが融合してピジョンレノンに成った。" \
			--dir_dict $(DIR_NEOLOGD)


.PHONY:
word2vec: ## word2vec
	docker run -it --rm \
		-v `pwd`:/work \
		$(CONTAINER_NAME) \
		python ./scripts/word2vec.py \
			--word "ピジョン" \
			--bin_entity_filename $(BIN_ENTITY_VECTOR)

# ============================================================
.PHONY: build
build: ## build dockerfile
	docker build -f Dockerfile -t $(CONTAINER_NAME) .


.PHONY: void
void: ## run with bash
	docker run -it --rm \
		-v `pwd`:/work \
		$(CONTAINER_NAME) \
		/bin/bash


.PHONY: run
run: ## run dockerfile
	@make build
	@make wakachigaki
	@make word2vec