from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
from sysconfig import get_path
from os.path import dirname

pygalois_ext = Extension(
                         "pygalois.pygalois",
                         sources = ["pygalois/pygalois.pyx"],
                         extra_compile_args = ["-std=c++14"],
                         libraries = ["galois_exp",
                                      "galois_graphs",
                                      "galois_runtime",
                                      "galois_substrate",
                                      "gllvm"],
                         # Assumption is that the Python headers
                         # are one level down from the main include
                         # directory. That may not be true in general,
                         # but it is certainly true for the cases
                         # immediately relevant to this project.
                         include_dirs = [dirname(get_path("include"))],
                         language = "c++"
                         )

setup(
      name = "pygalois",
      packages = ["pygalois"],
      package_data = {"pygalois" : ["*.pxd", "cpp/*.pxd", "cpp/Galois/*.pxd",
                                    "cpp/Galois/Graph/*.pxd"]},
      ext_modules = [pygalois_ext],
      cmdclass = {'build_ext' : build_ext}
      )

