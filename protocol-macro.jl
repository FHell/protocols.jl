# This file shows the proposed syntax for the Protocol macro

@Prot begin

Protocol Iterable

  # Specify fields the Iterable must have.
  start::Int64

  # Docstrings in Protocol definitions could also serve as documentation for functions
  # rather than methods.
  function next(t :~ Iterable) # no default implementation

  # protocol functions could have default implementations
  function 2ndnext(t :~ Iterable) # default implementation
    next(t)
    next(t)
  end

end

# We now define a type...
struct T
  start::Int64
  c
end

# and implement the Protocol for it
impl Iterable for T

  function next(t::T)
    t.c
  end

end


# We can then define functions that take Iterables and only Iterables of
# arbitrary type as input.
function get_third(b :~ Iterable)
  2ndnext(b)
  next(b)
end

# we get an object of type T
t = T(1, 5)

# and call it, explicitly treating t as Iterable:
get_third(t :~ Iterable)

# This, on the other hand, should raise an error (Protocol Error: Need to
# explicitly declare protocol for t!):
get_third(t)

# and calling it this way:
arr = [1]
get_third(arr :~ Iterable)
# raises "Type of argument arr does not implement protocol Iterable"


# If we violate the protocol we get an immediate error:

struct T2
  c
end

impl Iterable for T2

  function next(t::T2)
    t.c
  end

end # Protocol Error: T2 has no field "start"

# If we don't have all functions defined we also get an error:

struct T3
  start::Int64
  c
end

impl Iterable for T3
end # Protocol Error: function next not defined for T3

# This means we can't implement the behaviour after we declare that T3
# implements the protocol

# I would also favour that the non-default functions need to be explicitly
# declaredin the impl block.

end #@Prot
