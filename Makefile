export CONTAINER_NAME = wakachigaki-docker-py
export DIR_NEOLOGD = /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd
export BIN_ENTITY_VECTOR = /entity_vector/entity_vector.model.bin

export TEST_WORD = "ピジョン"
export TEST_SENTENCE = "ピジョンとジョン・レノンが融合してピジョンレノンと成った。"


# ============================================================
.PHONY: wakachigaki
mecab_neologd_tokenizer: ## tokenizing with MeCab + NEologd
	docker run -it --rm \
		-v `pwd`:/work \
		$(CONTAINER_NAME) \
		python ./scripts/mecab_neologd_tokenizer.py \
			--sentence $(TEST_SENTENCE) \
			--dir_dict $(DIR_NEOLOGD)



.PHONY: huggingface_tokenizer
huggingface_tokenizer: ## tokenizing with huggingface tokenizer
	docker run -it --rm \
		-v `pwd`:/work \
		-v `pwd`/src/huggingface/:/root/.cache/huggingface/transformers \
		$(CONTAINER_NAME) \
		python ./scripts/huggingface_tokenizer.py \
			--sentence $(TEST_SENTENCE)


.PHONY: word2vec
word2vec: ## convert word to vector (numpy)
	docker run -it --rm \
		-v `pwd`:/work \
		$(CONTAINER_NAME) \
		python ./scripts/word2vec.py \
			--word $(TEST_WORD) \
			--bin_entity_filename $(BIN_ENTITY_VECTOR)


# ============================================================
.PHONY: build
build: ## build dockerfile
	docker build -f Dockerfile -t $(CONTAINER_NAME) .


.PHONY: void
void: ## enter Docker container
	docker run -it --rm \
		-v `pwd`:/work \
		$(CONTAINER_NAME) \
		/bin/bash


.PHONY: run
run: ## test all
	@make build
	@make mecab_neologd_tokenizer
	@make huggingface_tokenizer
	@make word2vec


# ============================================================
.PHONY:	help
help:	## show help (this)
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'