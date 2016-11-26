from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

pygalois_ext = Extension(
                         "pygalois",
                         sources = ["pygalois/pygalois.pyx"],
                         extra_compile_args = ["-std=c++14"],
                         libraries = ["galois_exp",
                                      "galois_graphs",
                                      "galois_runtime",
                                      "galois_substrate",
                                      "gllvm"],
                         language = "c++"
                         )

setup(
      name = "pygalois",
      packages = ["pygalois"],
      ext_modules = [pygalois_ext],
      cmdclass = {'build_ext' : build_ext}
      )

