from .cpp.Galois.Graph.Graph cimport dummy_true, dummy_false, FirstGraph

ctypedef FirstGraph[int,void,dummy_true] Graph

def test_print():
    print("hello")
