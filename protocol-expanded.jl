# This file shows the proposed expansion of Protocol macro

# Protocol Iterable
#   start::Int64
#
#   function next(t :~ Iterable) # no default implementation
#
#   function secondnext(t :~ Iterable) # default implementation
#     next(t)
#     next(t)
#   end
# end

struct Iterable end
struct NotIterable end

is_Iterable(::Any) = NotIterable()


function next(::Iterable, t)
  error("Not implemented")
end

function secondnext(::Iterable, t) # default implementation
  next(Iterable, t)
  next(Iterable, t)
end


next(t) = next(is_iterable(t), t)
secondnext(t) = secondnext(is_iterable(t), t)

next(::NotIterable, t) = println("Argument does not implement or declare Protocol Iterable")
secondnext(::NotIterable, t) = println("Argument does not implement or declare Protocol Iterable")


# We now define a type...
struct T
  start::Int64
  c
end


# impl Iterable for T
#
#   function next(t::T)
#     t.c
#   end
#
# end

if ! hasfield(T, :start)
  throw(ProtocolError("Type T has no field start"))
end

if ! hasfieldtype(T, :start, Int64)  # Not sure how to implement this...
  throw(ProtocolError("Field T.start needs to be of type Int64"))
end

# Taken directly from the body of the implementation
function next(::Iterable, t::T)
  t.c
end

function secondnext(::Iterable, t::T) # default implementation taken from the Protocol
  next(t)
  next(t)
end

# Check that the body of the implementation does what it should:
if ! hasmethod(next, Tuple{Iterable, T})
  throw(ProtocolError("Protocol function next not implemented for Type T"))
end

is_Iterable(::T) = Iterable()


# function get_third(b :~ Iterable)
#   secondnext(b)
#   next(b)
# end

function get_third(::Iterable, b)
  secondnext(b)
  next(b)
end
get_third(b) = get_third(is_Iterable(b), b)
get_third(::NotIterable, b) = throw(ProtocolError("First argument doesn't implement Iterable."))


# we get an object of type T
t = T(1, 5)

# and call get_third on it:
get_third(t)

# and calling it this way:
get_third(1)
# raises "Type of argument arr does not implement protocol Iterable"
