# 日本語言語処理つめあわせDockerコンテナ

<!-- - Docker HUB (TODO)-->
- Build Docker
- **MeCab + NEologd**
- **HuggingFace Tokenizer with Ja-Bert**
- **Word2vec**
- Show help

## 解説

時間があるときに作ります…ごめんなさい。

<!--
## Docker Hub (TODO)

https://hub.docker.com/repository/docker/hyperpigeon/ja-tokernizer-py

（DockerHub 経由で `git clone` せずに分かち書きできるようにしたい。まだやってないですごめんなさい）

```
docker pull hyperpigeon/ja-tokernizer-py
...
```
-->


## 環境

- Docker: `Docker version 20.10.9, build c2ea9bc` (おそらく19.以上なら大丈夫だと思います)


## Build docker (local)

`git clone` した後に `make run` すれば、すべてのコンテナが生成・実行されます。

```
git clone git@github.com:p-geon/ja-tokenizer-docker-py.git
cd ja-tokenizer-docker-py
make run
```

## Notebooks

以下の三種類とも jupyter notebook を用意し、手を加えやすくしました。
Makefile コマンドで `docker build` + `docker run` できます。
起動後は URL をブラウザに貼り付けてブラウザで操作してください。

- tokenizer_mecab_neologd: `make notebook_tokenizer_mecab_neologd`
- tokenizer_huggingface: `make notebook_tokenizer_huggingface`
- notebook_word2vec: `make notebook_word2vec`


注意点として、環境とノートブックが一対一対応なので、

`notebook_tokenizer_mecab_neologd` では `notebooks/tokenizer_mecab_neologd.ipynb` の環境しか動きません。
ほかも同様です。名前で判断してください。

（なんかいい解決方法あったら教えて下さい。）


## MeCab + NEologd

[NEologd](https://github.com/neologd/mecab-ipadic-neologd) ベースの MeCab を使って分かち書きする簡易スクリプトです。
`Makefile` にある変数 `TEST_SENTENCE` の文字列を分かち書きするスクリプトをコンテナ内で走らせます。

**usage**

```
make tokenizer_mecab_neologd
```

**result**

```
docker run -it --rm \
	-v `pwd`:/work \
	ja-tokenizer-mecab-neologd \
	python ./scripts/tokenizer_mecab_neologd.py \
		--sentence "ピジョンとジョン・レノンが融合してピジョンレノンと成った。" \
		--dir_dict /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd
	BOS/EOS
ピジョン	名詞
と	助詞
ジョン・レノン	名詞
が	助詞
融合	名詞
する	動詞
て	助詞
ピジョンレノン	名詞
と	助詞
成る	動詞
た	助動詞
。	記号
	BOS/EOS
```


## HuggingFace Tokenizer with Ja-Bert

[東北大のBERT-Tokenizer](https://huggingface.co/cl-tohoku/bert-base-japanese) による分かち書きの簡易スクリプトをコンテナ内で走らせます。
`Makefile` にある変数 `TEST_SENTENCE` の文字列を分かち書きするスクリプトをコンテナ内で走らせます。

ネットワーク負荷軽減のため、キャッシュを `src/huggingface/` 内に確保します。

**usage**

```
make tokenizer_huggingface
```

**result**

```
docker run -it --rm \
	-v `pwd`:/work \
	ja-tokenizer-touhoku-bert \
	python ./scripts/tokenizer_huggingface.py \
		--sentence "ピジョンとジョン・レノンが融合してピジョンレノンと成った。"
Downloading: 100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 104/104 [00:00<00:00, 108kB/s]
Downloading: 100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 479/479 [00:00<00:00, 483kB/s]
Downloading: 100%|███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 252k/252k [00:00<00:00, 316kB/s]
tokenized:  ['ピ', '##ジョン', 'と', 'ジョン', '・', 'レノ', '##ン', 'が', '融合', 'し', 'て', 'ピ', '##ジョン', '##レノ', '##ン', 'と', '成っ', 'た', '。']
```


## Word2vec

[gensim](https://radimrehurek.com/gensim/) + [日本語Wikipediaエンティティベクトル](http://www.cl.ecei.tohoku.ac.jp/~m-suzuki/jawiki_vector/) で単語をベクトル化します。
`Makefile` にある変数 `TEST_WORD` の文字列を分かち書きするスクリプトをコンテナ内で走らせます。

**usage**

```
make word2vec
```

**result**

```
docker run -it --rm \
	-v `pwd`:/work \
	ja-word2vec \
	python ./scripts/word2vec.py \
		--word "ピジョン" \
		--bin_entity_filename /entity_vector.model.bin
<class 'numpy.ndarray'> (200,) [ 0.18742366  0.07586656  0.03849505  0.38004303 -0.00524301 -0.20294596
  0.20340575  0.49917793 -0.2951132  -0.08509478]
```

(表示しているベクトルは都合上、先頭から10個分)


## Show help

`Makefile` のコマンドと、その概要を表示します。

**usage**

```
make help
```

**result**

```
tokenizer_mecab_neologd tokenizing with MeCab + NEologd
tokenizer_huggingface tokenizing with huggingface tokenizer
word2vec             convert word to vector (numpy)
run                  test all
help                 show help (this)
```
