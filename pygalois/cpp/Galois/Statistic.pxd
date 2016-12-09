cdef extern from "Galois/Statistic.h" namespace "Galois" nogil:
    cppclass StatTimer:
        StatTimer()
        void start()
        void stop()
        unsigned int get()
