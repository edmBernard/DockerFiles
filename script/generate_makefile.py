#! /usr/bin/python3
"""
    script to generate Makefile in function of all Dockerfile in the repository
"""

from tools import *


def main():
    """
        Write Makefile in function of all Dockerfile in the repository
    """

    graph = extract_dependence()
    sorted_graph = sorted(graph, key=lambda t: (-len(t), t[0]))

    image_list = [i[0] for i in sorted_graph]
    deps_list = [i[1:] for i in sorted_graph]
    filename_list = [imagename_to_filename(i) for i in image_list]

    with open("../Makefile", "w") as fl:
        fl.write("NOCACHE=OFF\n")
        fl.write("\n")
        fl.write("ifeq ($(NOCACHE),ON)\n")
        fl.write("\targ_nocache=--no-cache\n")
        fl.write("else\n")
        fl.write("\targ_nocache=\n")
        fl.write("endif\n\n\n")

        fl.write(".PHONY: all all_cpu all_gpu clean clean_cpu clean_gpu ")
        fl.write(" ".join(image_list) + " ")
        fl.write(" ".join(["clean_%s" % i for i in image_list]))
        fl.write("\n\n\n")

        fl.write("all: all_cpu all_gpu\n\n")
        fl.write("all_cpu: ")
        fl.write(" ".join([i for i in image_list[::-1] if "cpu" in i]))
        fl.write("\n\n")
        fl.write("all_gpu: ")
        fl.write(" ".join([i for i in image_list[::-1] if "gpu" in i]))
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
    main()
    print("Generation Done")
