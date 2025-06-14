# Introduction to Workers

Workers are classes that do the work of producing files. The idea behind Workers is that they should be designed in a way where they are not dependent on ``petit-felix`` to run. Tasks instantiate Workers and call their functions to organize their output.

Workers can be designed in any way you like and have no specific requirements, but they do require a Task to call them in order to make them do anything. For code cleanliness, Workers should be organized in the ``PetitFelix::Worker`` module, although this is not required to function.
