
# Fake types to work around Cython's lack of support
# for non-type template parameters.
cdef extern from *:
    cppclass dummy_true "true"
    cppclass dummy_false "false"

cdef extern from "Galois/Graphs/Graph.h" namespace "Galois::Graph":
    cppclass FirstGraph[node_data, edge_data, is_directed]:
        pass
