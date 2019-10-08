from setuptools import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

pygalois_ext = Extension(
                         "pygalois.pygalois",
                         sources = ["pygalois/pygalois.pyx"],
                         extra_compile_args = ["-std=c++14"],
                         libraries = ["galois_shmem"],
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

