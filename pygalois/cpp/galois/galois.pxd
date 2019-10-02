# Declaration from "Galois/Threads.h"
cdef extern from "galois/Galois.h" namespace "galois" nogil:
    unsigned int setActiveThreads(unsigned int)

    cppclass UserContext[T]:
        pass

    void for_each(...) except +
