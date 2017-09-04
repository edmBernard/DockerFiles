from path import Path
from tools import *

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

if __name__ == '__main__':
    main()
    print("Generation Done")