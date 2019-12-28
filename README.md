# The problem of structure

This repo contains thoughts and ideas on structuring Julia code. Julia contains a unique mix of features that have allowed it to create incredibly strong libraries in a short amount of time. Specifically: Dynamicism, type based dispatch, and generic code as default. Specializing the functions called based on type as late as possible allows the users of libraries to inject behaviour deep inside the library code.

These new and unique features present us with a number of new challenges though. Error messages, unclear APIs, no self documenting function call signatures, hard to reason about invariants/behaviours of code.

My perspective in all this is that of a scientist who has some development experience, is mostly a consumer, and occasional developer of libraries, and supervises many people who are not experienced programmers.

## A proposal

The various proposals on more powerful traits or interfaces interact in subtle ways with the type based dispatch. For example one proposal tries to automatically detect (hasmethod) wherther a type has satisfies an interface.

Instead the idea here is to augment the language with a not so dynamic, explicit not automatic feature that is as far as possible orthogonal to type based dispatch.

