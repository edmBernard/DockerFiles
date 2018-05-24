#! /usr/bin/python3
r"""Script to generate makefile, super dockerfile or dockerfile concatenation.

Usage:
generate.py amalgamation
generate.py makefile
generate.py concatenate --filename <filename> --base <base> [--] <list>...

Options:
-h --help      _o/ .
--version      \o_ .
--filename <filename>  \o/
--base <base>  \o/
"""
import re
import sys

from docopt import docopt
from path import Path

from tools import extract_dependence, imagename_to_filename


def amalgamation():
    """
        Write concatenated Dockerfile in function of all Dockerfile in the repository
        Only if docker file have dependency
    """
    print("Amalgamation Generation")
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
                if not firstloop:
                    file_out.write("\n# ==============================================================================\n")
                    file_out.write("# %s\n" % imagename_to_filename(image_name))

                if Path("../" + imagename_to_filename(image_name)).exists():
                    _filename = "../" + imagename_to_filename(image_name)
                else:
                    _filename = "../super/" + imagename_to_filename(image_name)

                with open(_filename, "r") as file_in:
                    for i in file_in:
                        match = re.search(r"FROM|LABEL maintainer", i)
                        if match and not firstloop:
                            continue
                        file_out.write(i)

                firstloop = False


def concatenate_image(filename, base, image_list):
    print("Image list to concatenate: ", *image_list)
    Path(filename).parent.makedirs_p()
    with open(filename, "w") as file_out:
        file_out.write("FROM %s\n" % base)
        file_out.write('LABEL maintainer="Erwan BERNARD https://github.com/edmBernard/DockerFiles"\n\n')
        file_out.write("# " + " ".join(sys.argv) + "\n")

        for image_name in image_list:
            file_out.write("\n# ==============================================================================\n")
            file_out.write("# %s\n" % imagename_to_filename(image_name))
            print("Expand: ", "../%s" % (imagename_to_filename(image_name)))
            with open("../%s" % imagename_to_filename(image_name), "r") as file_in:
                for i in file_in:
                    match = re.search(r"FROM|LABEL maintainer", i)
                    if match:
                        continue
                    file_out.write(i)


def makefile():
    """
        Write Makefile in function of all Dockerfile in the repository
    """
    print("Makefile Generation")
    graph = extract_dependence()
    sorted_graph = sorted(graph, key=lambda t: (-len(t), t[0]))
    image_list = [i[0] for i in sorted_graph]
    deps_list = [i[1:] for i in sorted_graph]
    filename_list = [imagename_to_filename(i) if Path("../" + imagename_to_filename(i)).exists() else "super/" + imagename_to_filename(i) for i in image_list]

    with open("../Makefile", "w") as fl:
        fl.write("NOCACHE=OFF\n")
        fl.write("\n")
        fl.write("ifeq ($(NOCACHE),ON)\n")
        fl.write("\targ_nocache=--no-cache\n")
        fl.write("else\n")
        fl.write("\targ_nocache=\n")
        fl.write("endif\n\n\n")

        fl.write(".PHONY: script_amalgamation script_makefile all all_cpu all_gpu clean clean_cpu clean_gpu ")
        fl.write(" ".join(image_list) + " ")
        fl.write(" ".join(["clean_%s" % i for i in image_list]))
        fl.write("\n\n\n")

        fl.write("script_makefile:\n")
        fl.write("\tcd script && python3 generate.py makefile\n\n")
        fl.write("script_amalgamation:\n")
        fl.write("\tcd script && python3 generate.py amalgamation\n\n")
        fl.write("all: all_cpu all_gpu\n\n")
        fl.write("all_cpu: ")
        fl.write(" ".join([i for i in image_list[::-1] if "cpu" in i]))
        fl.write("\n\n")
        fl.write("all_gpu: ")
        fl.write(" ".join([i for i in image_list[::-1] if "gpu" in i]))
        fl.write("\n\n")
        fl.write("all_alpine: ")
        fl.write(" ".join([i for i in image_list[::-1] if "alpine" in i]))
        fl.write("\n\n\n")

        fl.write("clean: ")
        fl.write(" ".join(["clean_%s" % i for i in image_list]))
        fl.write("\n\n")
        fl.write("clean_cpu: ")
        fl.write(" ".join(["clean_%s" % i for i in image_list if "cpu" in i]))
        fl.write("\n\n")
        fl.write("clean_gpu: ")
        fl.write(" ".join(["clean_%s" % i for i in image_list if "gpu" in i]))
        fl.write("\n\n\n")

        for i, f, d in zip(image_list, filename_list, deps_list):
            fl.write("%s: " % i)
            fl.write(" ".join(d[:1]))
            if "gpu" in i:
                fl.write("\n\tnvidia-docker build $(arg_nocache) -t %s -f %s %s\n\n" % (i, f, f.split("/")[0]))
            else:
                fl.write("\n\tdocker build $(arg_nocache) -t %s -f %s %s\n\n" % (i, f, f.split("/")[0]))

            fl.write("clean_%s: " % i)
            fl.write(" ".join(["clean_%s" % ti for ti, td in zip(image_list, deps_list) if i in td]))
            fl.write("""\n\tif [ "$$(docker images -q --filter=reference='%s')" != "" ]; then docker rmi %s; else echo "0"; fi\n\n""" % (i, i))


if __name__ == '__main__':
    clo = docopt(__doc__, version='0.2')

    print(clo)
    if clo["amalgamation"]:
        amalgamation()
    elif clo["makefile"]:
        makefile()
    elif clo["concatenate"]:
        concatenate_image(clo["--filename"], clo["--base"] + ":latest"*(":" not in clo["--base"]), clo["<list>"])

    print("Generation Done")

