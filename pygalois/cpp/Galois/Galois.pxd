# Declaration from "Galois/Threads.h"
cdef extern from "Galois/Galois.h" namespace "Galois" nogil:
    unsigned int setActiveThreads(unsigned int)

    cppclass UserContext[T]:
        pass

    void for_each(...) except +
