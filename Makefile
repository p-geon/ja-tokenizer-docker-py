export TEST_WORD = "ピジョン"
export TEST_SENTENCE = "ピジョンとジョン・レノンが融合してピジョンレノンと成った。"

export CONTAINER_TNZ_MECAB = ja-tokenizer-mecab-neologd
export CONTAINER_TNZ_BERT = ja-tokenizer-tohoku-bert
export CONTAINER_NAME_WORD2VEC = ja-word2vec

export BIN_ENTITY_VECTOR = /entity_vector.model.bin
export DIR_NEOLOGD = /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd


# ============================================================
.PHONY: tokenizer_mecab_neologd
tokenizer_mecab_neologd: ## tokenizing with MeCab + NEologd
	docker build -f docker/Dockerfile.tokenizer_mecab_neologd \
		--build-arg path_neologd=$(DIR_NEOLOGD) \
		-t $(CONTAINER_TNZ_MECAB) .
	docker run --rm \
		-v `pwd`:/work \
		$(CONTAINER_TNZ_MECAB) \
		python ./scripts/tokenizer_mecab_neologd.py \
			--sentence $(TEST_SENTENCE) \
			--dir_dict $(DIR_NEOLOGD)


.PHONY: tokenizer_huggingface
tokenizer_huggingface: ## tokenizing with huggingface tokenizer
	docker build -f docker/Dockerfile.tokenizer_huggingface \
		-t $(CONTAINER_TNZ_BERT) .
	docker run --rm \
		-v `pwd`:/work \
		$(CONTAINER_TNZ_BERT) \
		python ./scripts/tokenizer_huggingface.py \
			--sentence $(TEST_SENTENCE)


.PHONY: word2vec
word2vec: ## convert word to vector (numpy)
	docker build -f docker/Dockerfile.word2vec \
		-t $(CONTAINER_NAME_WORD2VEC) .
	docker run --rm \
		-v `pwd`:/work \
		$(CONTAINER_NAME_WORD2VEC) \
		python ./scripts/word2vec.py \
			--word $(TEST_WORD) \
			--bin_entity_filename $(BIN_ENTITY_VECTOR)


# ============================================================
.PHONY: notebook
notebook: ## instantiate notebook
	docker build -f docker/Dockerfile.word2vec \
		-t $(CONTAINER_NAME_WORD2VEC) .
	docker run --rm \
		-v `pwd`:/work \
		-p 8888:8888 \
		-e ENTITY_FILENAME=$(BIN_ENTITY_VECTOR) \
		$(CONTAINER_NAME_WORD2VEC) \
		jupyter notebook --port 8888 --ip=0.0.0.0 --allow-root


# ============================================================
.PHONY: run
run: ## test all
	@make tokenizer_mecab_neologd
	@make tokenizer_huggingface
	@make word2vec


# ============================================================
.PHONY:	help
help:	## show help (this)
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'