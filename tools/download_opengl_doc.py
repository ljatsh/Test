#!/usr/bin/python
#coding=utf-8

import urllib.request
import re
import os

# OpenGL Reference Card URL
OPENGL_REF_URL0  = "https://www.khronos.org/developers/reference-cards/"

# OpenGL Reference Card Download URL
OPENGL_REF_URL1   = "https://www.khronos.org/files/"

# OpenGL Registry URL
OPENGL_REG_URL   = "https://www.khronos.org/registry/OpenGL/specs/"
OPENGLGL_REG_URL = "https://www.khronos.org/registry/OpenGL/specs/gl/"
OPENGLES_REG_URL = "https://www.khronos.org/registry/OpenGL/specs/es/"
OPENGLSC_REG_URL = "https://www.khronos.org/registry/OpenGL/specs/sc/"

# which type of OpenGL Resource do u want to download?
OPENGL_URL = OPENGLES_REG_URL

# download configurations
DOWNLOAD_ENABLE = True
DOWNLOAD_TOOL   = "axel"
DOWNLOAD_TNUM   = 20
DOWNLOAD_TO     = os.path.expanduser('~') + "/Downloads/OpenGL_Resources/"


def listOpenGLRegistryUrl(url):
    content = urllib.request.urlopen(url).read()
    content = content.decode('utf-8')

    reg = r'\<a href="(.+)"\>\<img src=".+" alt="\[(...)\]" width="16" height="16" /\>'
    pattern = re.compile(reg)
    suburls = re.findall(pattern, content)

    for item in suburls:
        if item[1] == "DIR":
            listOpenGLRegistryUrl(url + item[0])
        if item[1] == "   ":
            if DOWNLOAD_ENABLE:
                download(url + item[0])
            print(url + item[0])


def listOpenGLRefCardUrl(url):
    content = urllib.request.urlopen(url).read()
    content = content.decode('utf-8')

    reg = r'\<option value="(.+)"\>(OpenCL|OpenGL|OpenGL ES|Vulkan) .*\</option\>'
    pattern = re.compile(reg)
    suburls = re.findall(pattern, content)

    for item in suburls:
        download(OPENGL_REF_URL1 + item[0])
        print(url + item[0])


def download(url):
    if os.path.exists(DOWNLOAD_TO) == False:
        os.mkdir(DOWNLOAD_TO)

    cmd = DOWNLOAD_TOOL + " -n " + str(DOWNLOAD_TNUM) + " -o " + DOWNLOAD_TO + " " + url
    os.system(cmd)


#listOpenGLRegistryUrl(OPENGL_URL)
listOpenGLRefCardUrl(OPENGL_REF_URL0)