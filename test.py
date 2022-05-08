from typing import Tuple
import argparse
import MeCab


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-t', '--text', type=str, required=True)
    args = parser.parse_args()
    return args


class Tagger(object):
    def __init__(self):
        self.tokenizer = self.init_neologd()
        self.tokenizer.parse('')


    def __call__(self, text: str):
        nodes = self.get_node(text)
        ret =  self.parse_nodes(nodes)
        return ret


    @staticmethod
    def init_neologd() -> MeCab.Tagger:
        dic_path = "/usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd" # neologd in the Docker container
        tokenizer = MeCab.Tagger(f'-r/dev/null -d{dic_path}') # <- https://github.com/SamuraiT/mecab-python3#common-issues
        return tokenizer

    
    def get_node(self, text: str) -> MeCab.Node:
        return self.tokenizer.parseToNode(text)


    def parse_nodes(self, nodes: MeCab.Node) -> Tuple[str, str]:
        words, parts = [], []
        

        while nodes:
            # 単語を取得
            if(nodes.feature.split(",")[6] == '*'):
                word = nodes.surface
            else:
                word = nodes.feature.split(",")[6]

            words.append(word)
            parts.append(nodes.feature.split(",")[0])

            nodes = nodes.next
        return words, parts

def main():
    args = parse_args()

    sentence = args.text

    ret = Tagger().__call__(sentence)
    
    import pprint
    pprint.pprint(ret)


if(__name__ == '__main__'):
    main()