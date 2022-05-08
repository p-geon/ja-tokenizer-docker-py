from typing import Tuple
import argparse
import MeCab


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-t', '--text', type=str, required=True)
    parser.add_argument('-d', '--dir_dict', type=str, required=True, help='neologd in the Docker container')
    args = parser.parse_args()
    return args


class Tagger(object):
    def __init__(self, dir_dict: str):
        self.dir_dict = dir_dict

        self.tokenizer = self.init_neologd()
        self.tokenizer.parse('')


    def __call__(self, text: str):
        nodes = self.get_node(text)
        ret =  self.parse_nodes(nodes)
        return ret


    def init_neologd(self) -> MeCab.Tagger:
        tokenizer = MeCab.Tagger(f'-r/dev/null -d{self.dir_dict}') # <- https://github.com/SamuraiT/mecab-python3#common-issues
        return tokenizer

    
    def get_node(self, text: str) -> MeCab.Node:
        return self.tokenizer.parseToNode(text)


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


def main():
    args = parse_args()
    t = Tagger(dir_dict=args.dir_dict)
    
    ret = t.__call__(args.text)
    
    import pprint
    pprint.pprint(ret)


if(__name__ == '__main__'):
    main()