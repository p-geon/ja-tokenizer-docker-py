
import argparse
import numpy as np
from gensim.models import KeyedVectors


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-w', '--word', type=str, required=True)
    parser.add_argument('-b', '--bin_entity_filename', type=str, required=True, help='binary of the entity vector Ja')
    return parser.parse_args()


class Word2Vec(object):
    def __init__(self, bin_entity_filename: str) -> np.ndarray:
        model_path = bin_entity_filename
        self.model = KeyedVectors.load_word2vec_format(model_path, binary=True)

    def __call__(self, word: str):
        try:  # existent word
            v = self.model.get_vector(word)
            return v
        except KeyError as k: # non-existent word
            return k


if(__name__ == '__main__'):
    args = parse_args()
    w2v = Word2Vec(args.bin_entity_filename)

    vec = w2v.__call__(args.word)
    print(type(vec), vec.shape, vec[0:10])
    