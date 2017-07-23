#! /usr/bin/python3
"""
    script to generate Makefile in function of all Dockerfile in the repository
"""

import re
from path import Path
from jinja2 import Environment, FileSystemLoader


def filename_to_imgename(filename):
    """
        tranform filename in docker image name
    """
    *_, image, tag = filename.splitall()
    return "%s\\:%s" % (image, tag[11:])


def get_deep_graph(graph, key):
    """
        get key dependence by walking recursively through graph
    """
    return [key, *get_deep_graph(graph, graph[key])] if key in graph else []


def extract_dependence():
    """
        get all dockerfile dependence
    """
    dockerfiles = Path("../").walkfiles("Dockerfile*")

    dep_graph = {}
    for i in dockerfiles:
        with open(i, "r") as f:
            match = re.search(r"FROM (.*)", f.readline().rstrip())
            if match:
                dep_graph[filename_to_imgename(i)] = match.group(1).replace(":", "\\:")

    return [get_deep_graph(dep_graph, i) for i in dep_graph]


def main():
    """
        write Makefile in function of all Dockerfile in the repository
    """

    graph = extract_dependence()
    sorted_graph = sorted(graph, key=lambda t: (-len(t), t[0]))

    image_list = [i[0] for i in sorted_graph]
    deps_list = [i[1:] for i in sorted_graph]
    filename_list = [i[0].replace("\\:", "/Dockerfile.") for i in sorted_graph]

    with open("../Makefile", "w") as fl:
        fl.write("NOCACHE=OFF\n")
        fl.write("\n")
        fl.write("ifeq ($(NOCACHE),ON)\n")
        fl.write("\targ_nocache=--no-cache\n")
        fl.write("else\n")
        fl.write("\targ_nocache=\n")
        fl.write("endif\n\n\n")

        fl.write(".PHONY: all all\:cpu all\:gpu clean clean\:cpu clean\:gpu ") 
        fl.write(" ".join(image_list))
        fl.write("\n\n\n")

        fl.write("all: all\:cpu all\:gpu\n\n") 
        fl.write("all\\:cpu: ")
        fl.write(" ".join([i for i in image_list[::-1] if "cpu" in i]))
        fl.write("\n\n")
        fl.write("all\\:gpu: ")
        fl.write(" ".join([i for i in image_list[::-1] if "gpu" in i]))
        fl.write("\n\n\n")

        fl.write("clean:\n\tdocker rmi ")
        fl.write(" ".join(image_list))
        fl.write("\n\n")
        fl.write("clean\\:cpu:\n\tdocker rmi ")
        fl.write(" ".join([i for i in image_list if "cpu" in i]))
        fl.write("\n\n")
        fl.write("clean\\:gpu:\n\tdocker rmi ")
        fl.write(" ".join([i for i in image_list if "gpu" in i]))
        fl.write("\n\n\n")

        for i, f, d in zip(image_list, filename_list, deps_list):
            fl.write("%s: " % i)
            fl.write(" ".join(d))
            if "gpu" in i:
                fl.write("\n\tnvidia-docker build $(arg_nocache) -t %s -f %s %s\n\n" % (i, f, f.split("/")[0]))
            else:
                fl.write("\n\tdocker build $(arg_nocache) -t %s -f %s %s\n\n" % (i, f, f.split("/")[0]))


if __name__ == '__main__':
    main()
    print("Generation Done")
