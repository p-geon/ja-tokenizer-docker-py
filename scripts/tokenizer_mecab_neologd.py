import argparse
from typing import Tuple
import MeCab


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--sentence', type=str, required=True)
    parser.add_argument('-d', '--dir_dict', type=str, required=True, help='neologd in the Docker container')
    return parser.parse_args()


class Tokenizer(object):
    def __init__(self, dir_dict: str):
        self.dir_dict = dir_dict

        self.tokenizer = self.init_neologd()
        self.tokenizer.parse('')


    def __call__(self, text: str) -> Tuple[str, str]:
        nodes = self.get_nodes(text)
        ret =  self.parse_nodes(nodes)
        return ret


    def init_neologd(self) -> MeCab.Tagger:
        tokenizer = MeCab.Tagger(f'-r/dev/null -d{self.dir_dict}') # <- https://github.com/SamuraiT/mecab-python3#common-issues
        return tokenizer

    
    def get_nodes(self, sentence: str) -> MeCab.Node:
        return self.tokenizer.parseToNode(sentence)


    def parse_nodes(self, nodes: MeCab.Node) -> Tuple[str, str]:
        words, parts = [], []
        
        while nodes:
            if(nodes.feature.split(",")[6] == '*'):
                word = nodes.surface
            else:
                word = nodes.feature.split(",")[6]

            words.append(word)
            parts.append(nodes.feature.split(",")[0])

            nodes = nodes.next
        return words, parts


if(__name__ == '__main__'):
    args = get_args()
    t = Tokenizer(dir_dict=args.dir_dict)

    ws, ps = t.__call__(args.sentence)

    
    for w, p in zip(ws, ps):
        print(f'{w}\t{p}')