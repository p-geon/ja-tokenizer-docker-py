FROM python:3.9.6 as base-image
LABEL maintainer='p-geon'

RUN apt-get update -q
# RUN apt-get install -y --no-install-recommends \
#    wget

# setup NEologd
RUN apt-get install -y --quiet --no-install-recommends \
  mecab libmecab-dev mecab-ipadic mecab-ipadic-utf8
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
  cd mecab-ipadic-neologd && \
  ./bin/install-mecab-ipadic-neologd -n -a --forceyes --asuser

# pip install
COPY requirements.txt ./
RUN pip install -q --upgrade pip
RUN pip install -r requirements.txt -q


WORKDIR /work
USER root
CMD ["/bin/bash"]