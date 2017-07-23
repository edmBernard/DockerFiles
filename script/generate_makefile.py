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

    j2_env = Environment(loader=FileSystemLoader("."), trim_blocks=True)
    j2_env.globals.update(zip=zip)
    template = j2_env.get_template('Makefile.tpl')

    with open("../Makefile", "w") as f:
        f.write(template.render(filenames=filename_list, images=image_list, deps=deps_list))

if __name__ == '__main__':
    main()
    print("Generation Done")
