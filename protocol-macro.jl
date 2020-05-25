# This file shows the proposed syntax for the Protocol macro

@Prot begin

Protocol Iterable

  # Specify fields the Iterable must have.
  start::Int64

  # Docstrings in Protocol definitions could serve as documentation for functions
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
  start::Int
  c
end

# and implement the Protocol for it
impl Iterable for T

  # Here we also check the function signature is correct  according to the Protocol
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

# and call get_third on it:
get_third(t)

# and calling it this way:
get_third(1)
# raises "Type of argument arr does not implement protocol Iterable"

end #@Prot
