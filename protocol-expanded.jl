# This file shows the proposed expansion of Protocol macro

struct ProtocolError
    message
end

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


next(t) = throw(ProtocolError("No protocol declared in first argument."))
secondnext(t) = throw(ProtocolError("No protocol declared in first argument."))

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

if ! hasfield(T, :start) # Not sure how to implement the type restriction...
  throw(ProtocolError("Type T has no field start"))
end

# Taken directly from the body of the implementation
function next(::Iterable, t::T)
  t.c
end

function secondnext(::Iterable, t::T) # default implementation
  next(Iterable(), t)
  next(Iterable(), t)
end

# Check that the body of the implementation does what it should:
if ! hasmethod(next, Tuple{Iterable, T}) # Not sure how to implement the type restriction...
  throw(ProtocolError("Type T has no field start"))
end

is_Iterable(::T) = Iterable()


# function get_third(b :~ Iterable)
#   secondnext(b)
#   next(b)
# end

function get_third(::Iterable, b)
  secondnext(Iterable(), b)
  next(Iterable(), b)
end
get_third(b) = throw(ProtocolError("No protocol declared in first argument."))
get_third(::NotIterable, b) = throw(ProtocolError("First argument doesn't implement Iterable."))


# we get an object of type T
t = T(1, 5)

# and call it, explicitly treating t as Iterable:

# get_third(t :~ Iterable)
get_third(is_Iterable(t), t)

# This, on the other hand, should raise an error (ProtocolError("No protocol declared in first argument.")):
get_third(t)

# and calling it this way:
arr = [1]
get_third(is_Iterable(arr), arr)
# raises "Argument does not implement or declare Protocol Iterable"
