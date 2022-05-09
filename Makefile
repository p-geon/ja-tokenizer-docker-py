export TEST_WORD = "ピジョン"
export TEST_SENTENCE = "ピジョンとジョン・レノンが融合してピジョンレノンと成った。"

# ============================================================
export CONTAINER_NAME_TOKENIZER_MECAB = ja-tokenizer-mecab-neologd
export CONTAINER_PATH_MECAB = docker/Dockerfile.tokenizer_mecab
export DIR_NEOLOGD = /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd
.PHONY: mecab_neologd_tokenizer
mecab_neologd_tokenizer: ## tokenizing with MeCab + NEologd
	docker build -f $(CONTAINER_PATH_MECAB) -t $(CONTAINER_NAME_TOKENIZER_MECAB) .
	docker run -it --rm \
		-v `pwd`:/work \
		$(CONTAINER_NAME_TOKENIZER_MECAB) \
		python ./scripts/mecab_neologd_tokenizer.py \
			--sentence $(TEST_SENTENCE) \
			--dir_dict $(DIR_NEOLOGD)


export CONTAINER_NAME_TOKENIZER_BERT = ja-tokenizer-tohoku-bert
export CONTAINER_PATH_TOKENIZER_BERT = docker/Dockerfile.huggingface_tokenizer
.PHONY: huggingface_tokenizer
huggingface_tokenizer: ## tokenizing with huggingface tokenizer
	docker build -f $(CONTAINER_PATH_TOKENIZER_BERT) -t $(CONTAINER_NAME_TOKENIZER_BERT) .
	docker run -it --rm \
		-v `pwd`:/work \
		$(CONTAINER_NAME_TOKENIZER_BERT) \
		python ./scripts/huggingface_tokenizer.py \
			--sentence $(TEST_SENTENCE)


export CONTAINER_NAME_WORD2VEC = ja-word2vec
export CONTAINER_PATH_WORD2VEC = docker/Dockerfile.word2vec
export BIN_ENTITY_VECTOR = /entity_vector/entity_vector.model.bin
.PHONY: word2vec
word2vec: ## convert word to vector (numpy)
	docker build -f $(CONTAINER_PATH_WORD2VEC) -t $(CONTAINER_NAME_WORD2VEC) .
	docker run -it --rm \
		-v `pwd`:/work \
		$(CONTAINER_NAME_WORD2VEC) \
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