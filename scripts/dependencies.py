#!/usr/bin/python3
import os
import sys

source_dir = "source/modules/"
testbench_dir = "testbench/"
include_dir = "include/"
dependencies = []

def remove_extension(f: str)->str:
    while f[len(f) - 1] != ".":
        f = f[:-1]
    f = f[:-1]
    return f
    
def remove_extension_list(file_list: list)->list:
    return [remove_extension(f) for f in file_list] 

source = remove_extension_list(os.listdir("source/modules"))
testbench = remove_extension_list(os.listdir("testbench"))
include = remove_extension_list(os.listdir("include"))
#print(include)

def calculate_dependencies_helper(file_name):
    with open(file_name, "r") as fin:
            for l in fin:
                line = l.split()
                for i, v in enumerate(line):
                    if v.find('//') != -1:
                        break
                    if v == '`include':
                        header = remove_extension((line[i+1]).lstrip("\"").rstrip("\""))
                        extend = header + ".vho"
                        if extend not in dependencies:
                            calculate_dependencies(header)
                    if (v in source or v in testbench) and (i == 0):
                        extend = v + ".svo"
                        if extend not in dependencies:
                            calculate_dependencies(v)
                    if v in include and i == 0:
                        extend = v + ".vho"
                        if extend not in dependencies:
                            calculate_dependencies(v)

def calculate_dependencies(target: str, ):
    if target in source:
        extend = target + ".svo"
        if extend not in dependencies:
            dependencies.append(extend)
        calculate_dependencies_helper(source_dir + target + ".sv")
    if target in testbench:
        extend = target + ".svo"
        if extend not in dependencies:
            dependencies.append(extend)
        calculate_dependencies_helper(testbench_dir + target + ".sv")
    if target in include:
        extend = target + ".vho"
        if extend not in dependencies and not (len(sys.argv) == 3 and sys.argv[2] == "syn"):
            dependencies.append(extend)
        calculate_dependencies_helper(include_dir + target + ".vh")
    return
if __name__ == "__main__":
        
    target = sys.argv[1][:-2]
    target=target.replace("dependencies/", "")
    calculate_dependencies(target)
    if not (len(sys.argv) == 3 and sys.argv[2] == "syn"):
        print(target,end=": ")
    for i in dependencies:
        if len(sys.argv) == 3 and sys.argv[2] == "syn":
            i = i.strip('o')
        print(i, end=" ")
    print()
