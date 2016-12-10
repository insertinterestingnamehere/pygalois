# cython: cdivision=True

from cython.operator cimport preincrement
from .cpp.Galois.Galois cimport UserContext, for_each, setActiveThreads
from .cpp.Galois.Graph.Graph cimport dummy_true, dummy_false, FirstGraph
from .cpp.Galois.Statistic cimport StatTimer
from libcpp.vector cimport vector

ctypedef FirstGraph[int, void, dummy_true] Graph

# Cython bug: using a nested class from a previous typedef doesn't
# work for the time being. Instead, the full template specialization
# must be used to get the member type.
ctypedef FirstGraph[int, void, dummy_true].GraphNode GNode

# This function is expected to forward C++ exceptions thrown to
# its caller. This is unusual for Cython, but it's the simplest
# way to guarantee no loos Python exceptions end up floating around.
cdef void IncrementNeighbors(Graph *g, GNode n, UserContext[GNode] &ctx) nogil:
    cdef:
        FirstGraph[int, void, dummy_true].edge_iterator ii = g[0].edge_begin(n)
        FirstGraph[int, void, dummy_true].edge_iterator ei = g[0].edge_end(n)
        int *data
    while ii != ei:
        data = &g[0].getData(g[0].getEdgeDst(ii))
        preincrement(data[0])
        preincrement(ii)

# C++ exceptions thrown inside this function are forwarded to its caller.
cdef bint ValueEqual(Graph *g, int v, GNode n) nogil:
    return g[0].getData(n) == v

# Unusual exception specification here.
# The various API calls within this function are all
# allowed to throw C++ exceptions, but this function
# is not. Any C++ exceptions thrown here must be converted
# to Python exceptions at the call site.
cdef void constructTorus(Graph &g, int height, int width) nogil except +:
    cdef:
        int numNodes = height * width
        vector[GNode] nodes = vector[GNode](numNodes)
        # statically type loop variables to avoid Python loop
        int i, x, y
        # To keep scoping of variables consistent across
        # Python and C++, C/C++ level variables must be
        # declared outside of loops and if statements.
        GNode c, n, s, e, w
    for i in range(numNodes):
        n = g.createNode(0)
        g.addNode(n)
        nodes[i] = n
    for x in range(width):
        for y in range(height):
            c = nodes[x * height + y]
            n = nodes[x * height + ((y + 1) % height)]
            s = nodes[x * height + ((y - 1 + height) % height)]
            e = nodes[((x + 1) % width) * height + y]
            w = nodes[((x - 1 + width) % width) * height + y]
            g.addEdge(c, n)
            g.addEdge(c, s)
            g.addEdge(c, e)
            g.addEdge(c, w)

cdef extern from * nogil:
    # hack to bind leading arguments by value to something that can be passed
    # to for_each. The returned lambda needs to be usable after the scope
    # where it is created closes, so captured values are captured by value.
    # The by-value capture in turn requires that graphs be passed as
    # pointers. This function is used without exception specification under
    # the assumption that it will always be used as a subexpression of
    # a whole expression that requires exception handling or that it will
    # be used in a context where C++ exceptions are appropriate.
    # There are more robust ways to do this, but this didn't require
    # users to find and include additional C++ headers specific to
    # this interface.
    # Syntactically, this is using the cname of an "external" function
    # to create a one-line macro that can be used like a function.
    # The expected use is bind_leading(function, args).
    cdef void *bind_leading "[](auto f, auto&&... bound_args){return [=](auto&&... pars){return f(bound_args..., pars...);};}"(...)
    # Similar thing to invoke a function and return an integer.
    # Useful for verifying that this approach works.
    cdef int invoke "[](auto f, auto&&... args){return f(args...);}"(...)

cdef int myfunc(int a, int b, int c):
    return a + b + c

def test_bind_leading():
    print(invoke(bind_leading(&myfunc, 1, 2), 3) == 6)

cdef extern from "algorithm" namespace "std" nogil:
    # This function from <algorithm> isn't currently
    # provided by Cython's known interfaces for the C++ standard library,
    # so this is needed to get it working here.
    # The variadic signature could probably be removed and this could
    # be made to match the original templates more closely, but since
    # this form matches the syntax we need to use, it is good enough.
    int count_if(...) except +

def run_torus(int numThreads, int n):
    cdef int new_numThreads = setActiveThreads(numThreads)
    if new_numThreads != numThreads:
        print("Warning, using fewer threads than requested")
    print("Using {0} thread(s) and {1} x {1} torus.".format(new_numThreads, n))
    cdef Graph graph
    constructTorus(graph, n, n)
    cdef StatTimer T
    with nogil:
        T.start()
        for_each(graph.begin(), graph.end(),
                 bind_leading(&IncrementNeighbors, &graph))
        T.stop()
    print("Elapsed time: {} milliseconds.".format(T.get()))
    cdef int count = count_if(graph.begin(), graph.end(),
                              bind_leading(&ValueEqual, &graph, 4))
    if count != n * n:
        print("Expected {} nodes with value = 4 but found "
              "{} nodes instead.".format(n * n, count))
    else:
        print("Correct!")

cpdef int run_torus_quiet(int numThreads, int n) except -1:
    cdef int new_numThreads = setActiveThreads(numThreads)
    if new_numThreads != numThreads:
        print("Warning, using fewer threads than requested")
    cdef Graph graph
    constructTorus(graph, n, n)
    cdef StatTimer T
    T.start()
    for_each(graph.begin(), graph.end(),
             bind_leading(&IncrementNeighbors, &graph))
    T.stop()
    cdef int count = count_if(graph.begin(), graph.end(),
                              bind_leading(&ValueEqual, &graph, 4))
    if count != n * n:
        raise ValueError("Expected {} nodes with value = 4 but found "
                         "{} nodes instead.".format(n * n, count))
    return T.get()
