from .cpp.Galois.Graph.Graph cimport dummy_true, dummy_false, FirstGraph

ctypedef FirstGraph[int, void, dummy_true] Graph

# Cython bug: using a nested class from a previous typedef doesn't
# work for the time being. Instead, the full template specialization
# must be used to get the member type.
ctypedef FirstGraph[int, void, dummy_true].GraphNode GNode

def test_print():
    print("hello")
