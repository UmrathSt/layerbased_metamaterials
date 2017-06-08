import os

def fileList(source, beginswith):
    matches = []
    for root, dirnames, filenames in os.walk(source):
        for filename in filenames:
            if filename.endswith(('.txt')) and filename.startswith((beginswith)):
                matches.append(os.path.join(root, filename))
    return sorted(matches)

