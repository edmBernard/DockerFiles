#! /usr/bin/python3
r"""generate amalgamation.py.

Usage:
  generate_amalgamation.py
  generate_amalgamation.py --filename <filename> --base <base> [--] <list>...

Options:
  -h --help      _o/ .
  --version      \o_ .
  --filename <filename>  \o/
  --base <base>  \o/
"""
import argparse

from docopt import docopt
from path import Path

from tools import *


def parse_command_line():
    args = docopt(__doc__, version='0.2')
    return args


def main():
    """
        Write concatenated Dockerfile in function of all Dockerfile in the repository
        Only if docker file have dependency
    """
    deps = extract_dependence()

    for image_names in deps:
        # we don't need to generate amalgamation if no dependencies
        if len(image_names) <= 1:
            continue

        filename = '../super/%s.super' % imagename_to_filename(image_names[0])
        Path(filename).parent.makedirs_p()

        firstloop = True
        with open(filename, "w") as file_out:
            for image_name in image_names[::-1]:
                with open("../" + imagename_to_filename(image_name), "r") as file_in:
                    for i in file_in:
                        match = re.search(r"FROM|MAINTAINER", i)
                        if match and not firstloop:
                            continue
                        file_out.write(i)
                firstloop = False


def concatenate_image(filename, base, image_list):

    with open(filename, "w") as file_out:
        file_out.write("FROM %s\n" % base)
        file_out.write("MAINTAINER Erwan BERNARD\n\n")

        for image_name in image_list:
            file_out.write("\n# ==============================================================================\n")
            file_out.write("# %s\n" % imagename_to_filename(image_name))
            print("../%s" % (imagename_to_filename(image_name)))
            with open("../%s" % imagename_to_filename(image_name), "r") as file_in:
                for i in file_in:
                    match = re.search(r"FROM|MAINTAINER", i)
                    if match:
                        continue
                    file_out.write(i)


if __name__ == '__main__':
    clo = parse_command_line()

    if clo["--filename"] is None:
        main()
    else:
        concatenate_image(clo["--filename"], clo["--base"] + ":latest"*(":" not in clo["--base"]) in, clo["<list>"])

    print("Generation Done")
