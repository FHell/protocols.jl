@Prot begin

Protocol Iterable

  # Docstrings in Protocol definitions could serve as documentation for functions
  # rather than methods.
  function next(t :~ Iterable) # no default implementation

  function 2ndnext(t :~ Iterable) # default implementation
    next(t)
    next(t)
  end

end

# We now define a type...
struct T
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
t = T(5)

# and call it, explicitly treating t as Iterable:
get_third(t :~ Iterable)

# This, on the other hand, should raise an error (Protocol Error: Need to
# explicitly declare protocol of t!):
get_third(t)

# an alternative is to try to guess the Protocol intended, but require explicit
# calls for any disamibguation. The effect of this might be that library code
# needs to clarify its calls.

# and calling it this way:
arr = [1]
get_third(arr :~ Iterable)
# raises "Type of argument arr does not implement Iterable"

end #@TR


# In order to implement this, the above should desugar to:

struct Iterable end
struct NotIterable end

is_iterable(::Any) = NotIterable

function next(::Iterable, t)
  raise(NotImplementedError()) # Should be unreachable
end

function 2ndnext(::Iterable, t) # default implementation
  next(t)
  next(t)
end

next(t) = next(is_iterable(t), t)
2ndnext(t) = 2ndnext(is_iterable(t), t)

next(::NotIterable, ...) = println("Does not implement or declare Protocol Iterable")
2ndnext(::NotIterable, ...) = println("Does not implement or declare Protocol Iterable")



struct T
  c
end

function next(::Iterable, t::T)
  t.c
end

is_iterable(T) = Iterable


function get_third(::Iterable, b)
  2ndnext(b)
  next(b)
end

function get_third(b)
  raise(Error("Need to specify protocol for get_third"))
end

# The alternative design could look like this:

if ! hasmethod(get_third, (T,)) # If no conflict exists, define iterable as default
  get_third(b) = get_third(is_iterable(T), b)
else # If there is a conflict, overwrite the default and require disambiguation
  get_third(b) = println("get_third implemented for different protocols, require disambuiguation.")
end # The downside of this is that other default implementations also get overwritten
