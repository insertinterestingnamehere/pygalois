# Declaration from "Galois/Threads.h"

# Hack to make auto return type for galois::iterate work.
# It may be necessary to write a wrapper header around for_each,
# but this should be good enough for the forseeable future either way.
cdef extern from * nogil:
    cppclass InternalRange "auto":
        pass

cdef extern from "galois/Galois.h" namespace "galois" nogil:
    unsigned int setActiveThreads(unsigned int)

    cppclass UserContext[T]:
        pass

    void for_each(...)

    InternalRange iterate[T](T &begin, T &end)

    cppclass SharedMemSys:
        SharedMemSys()

    cppclass loopname:
        loopname(char *name)

    cppclass no_pushes:
        no_pushes()

    cppclass no_conflicts:
        no_conflicts()
