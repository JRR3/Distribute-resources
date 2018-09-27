# Optimize the assignment of resources
This program solves a (discrete) time-dependent optimization problem 
related to the assignment of resources/agents to compartments that can be classified as either
ordinary locations or storage points (warehouses).

## The rules are as follows: 
1. Assigning a resource to a compartment incurs a cost
2. All resources are assigned to a unique compartment
3. Each resource can be assigned to specific storage points that 
can potentially change in time
4. No resource can stay more than consecutive x units of time in storage
5. If a resource is at a given storage point at time k, then, if assigned to
a storage point for time (k+1), only select storage locations are available.

## The included files are:
1. ap.dat
* Data for the problem
2. ap.mod
* Definition of the optimization problem 
3. ap.run
* AMPL instructions to solve the optimization problem

## Execution
To run, simply save all the files in the AMPL folder, type in the AMPL console

```
include ap.run;
```

and hit enter.

