import argparse
from transformers import AutoTokenizer


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--sentence', type=str, required=True)
    return parser.parse_args()


if(__name__ == '__main__'):
    args = get_args()
    tokenizer = AutoTokenizer.from_pretrained("cl-tohoku/bert-base-japanese")
    output = tokenizer.tokenize(args.sentence)
    print('tokenized: ', output)