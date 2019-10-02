cdef extern from "galois/Timer.h" namespace "galois" nogil:
    cppclass StatTimer:
        StatTimer()
        void start()
        void stop()
        unsigned int get()
