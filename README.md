# 日本語言語処理つめあわせDockerコンテナ

## Docker HUB (TODO)

https://hub.docker.com/repository/docker/hyperpigeon/ja-tokernizer-py

（DockerHUB 経由で `git clone` せずに分かち書きできるようにしたい。まだやってないですごめんなさい）

```
docker pull hyperpigeon/ja-tokernizer-py
...
```


## Build docker (local)

```
git clone git@github.com:p-geon/ja-tokenizer-docker-py.git
cd wakachigaki-docker-py
make build
```


## MeCab + NEologd

NEologd ベースの MeCab を使って分かち書きする簡易スクリプトです。

**usage**

```
make mecab_neologd_tokenizer
```

**result**

`Makefile` にある変数 `TEST_SENTENCE` の文字列を分かち書きするスクリプトをコンテナ内で走らせます。

```
docker run -it --rm \
	-v `pwd`:/work \
	wakachigaki-docker-py \
	python ./scripts/mecab_neologd_tokenizer.py \
		--sentence "ピジョンとジョン・レノンが融合してピジョンレノンと成った。" \
		--dir_dict /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd
(['',
  'ピジョン',
  'と',
  'ジョン・レノン',
  'が',
  '融合',
  'する',
  'て',
  'ピジョンレノン',
  'と',
  '成る',
  'た',
  '。',
  ''],
 ['BOS/EOS',
  '名詞',
  '助詞',
  '名詞',
  '助詞',
  '名詞',
  '動詞',
  '助詞',
  '名詞',
  '助詞',
  '動詞',
  '助動詞',
  '記号',
  'BOS/EOS'])
```


##  huggingface_tokenizer

東北大の BERT-Tokenizer による分かち書きの簡易スクリプトをコンテナ内で走らせます。ネットワーク負荷軽減のため、キャッシュを `src/huggingface/` 内に確保します。

**usage**

```
make huggingface_tokenizer
```

**result**

```
docker run -it --rm \
	-v `pwd`:/work \
	-v `pwd`/src/huggingface/:/root/.cache/huggingface/transformers \
	wakachigaki-docker-py \
	python ./scripts/huggingface_tokenizer.py \
		--sentence "ピジョンとジョン・レノンが融合してピジョンレノンと成った。"
tokenized:  ['ピ', '##ジョン', 'と', 'ジョン', '・', 'レノ', '##ン', 'が', '融合', 'し', 'て', 'ピ', '##ジョン', '##レノ', '##ン', 'と', '成っ', 'た', '。']
```


## word2vec

gensim + [日本語Wikipediaエンティティベクトル](http://www.cl.ecei.tohoku.ac.jp/~m-suzuki/jawiki_vector/) で単語をベクトル化します。

**usage**

```
make word2vec
```


## Show help

**usage**

```
make help
```

**result**

```
docker run -it --rm \
	-v `pwd`:/work \
	wakachigaki-docker-py \
	python ./scripts/word2vec.py \
		--word "ピジョン" \
		--bin_entity_filename /entity_vector/entity_vector.model.bin
<class 'numpy.ndarray'> (200,) [ 0.18742366  0.07586656  0.03849505  0.38004303 -0.00524301 -0.20294596
  0.20340575  0.49917793 -0.2951132  -0.08509478]
```