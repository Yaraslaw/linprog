

An instances belonging to a benchamrk before it can be executed, it needs be translated from its standard representation to a valid SWI-Prolog predicate. To do this transalation you should:

**Remark: we use the instance *markshare_4_0.mps* as example.

1- Go to the *transformer* folder
2- Copy the instance *markshare_4_0.mps* into that folder.
3-Start prolog

``$ swipl``

4- Consult the helper that implements the translation

``?- consult('transformer.pl').``


5- Perform the translation

``?- parse('markshare_4_0.mps','markshare_4_0.pl').``

A new file named *markshare_4_0.pl'* should be available in the folder. This file can be used as indicated above as it is a valid SWI-Prolog instance.  

