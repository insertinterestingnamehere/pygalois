
# Fake types to work around Cython's lack of support
# for non-type template parameters.
cdef extern from *:
    cppclass dummy_true "true"
    cppclass dummy_false "false"

# Omit the exception specifications here to
# allow returning lvalues.
# Since the exception specifications are omitted here,
# these classes/functions ABSOLUTELY MUST be used only
# within functions with C++ exception handling specifications.
# This is intentional and is required to ensure that C++ exceptions
# thrown in the code written using these forward declarations
# are forwarded properly into the Galois library rather than
# being converted into Python exceptions.
cdef extern from "galois/graphs/Graph.h" namespace "galois::graph" nogil:
    cppclass FirstGraph[node_data, edge_data, is_directed]:

        FirstGraph()
        cppclass GraphNode:
            pass

        cppclass edge_iterator:
            bint operator==(edge_iterator)
            bint operator!=(edge_iterator)
            edge_iterator operator++()
            edge_iterator operator--()

        cppclass iterator:
            bint operator==(iterator)
            bint operator!=(iterator)
            iterator operator++()
            iterator operator--()

        edge_iterator edge_begin(GraphNode)
        edge_iterator edge_end(GraphNode)

        iterator begin()
        iterator end()

        GraphNode getEdgeDst(edge_iterator)
        node_data& getData(GraphNode)

        GraphNode createNode(node_data)
        void addNode(GraphNode)
        void addEdge(GraphNode, GraphNode)

