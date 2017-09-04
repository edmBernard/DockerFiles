
import re

from path import Path

def filename_to_imagename(filename):
    """
        tranform filename in docker image name
    """
    *_, image, tag = filename.splitall()
    return "%s_%s" % (image, tag[11:].replace(".", "_"))


def imagename_to_filename(imagename):
    """
        tranform docker image name in filename
    """
    folder, *extension = imagename.split('_')
    return "%s/Dockerfile.%s" % (folder, ".".join(extension))


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
            match = re.search(r"FROM (.*):", f.readline().rstrip())
            if match:
                dep_graph[filename_to_imagename(i)] = match.group(1)

    return [get_deep_graph(dep_graph, i) for i in dep_graph]
