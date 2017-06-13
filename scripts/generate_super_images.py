from path import Path
import argparse
import re


def parse_command_line():
    parser = argparse.ArgumentParser()
    parser.add_argument('--gpu', dest='gpu', action='store_true', help='an integer for the accumulator')
    args = parser.parse_args()
    return args


def main():
    graph = {}
    folder = Path("../cpu").walkfiles("Dockerfile")
    for f in folder:
        with open(f, 'r') as file:
            # print(file.readlines())
            for line in file:
                match = re.search(r"FROM (.+):(.+)", line.rstrip())
                if match:
                    print(match.group(0))
                    print(match.group(1))
                    print(match.group(2))
                    graph[f.splitall()[-2]] = match.group(1)

    print(graph)

if __name__ == '__main__':
    args = parse_command_line()
    print(args)
    main()
