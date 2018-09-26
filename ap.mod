#Language : AMPL
#Type     : Model 
#Origin   : September 26 2018
#Location : Houston Methodist Research Institute
#Developer: Javier Ruiz Ramirez
#Description: Assignment of resources/materials to compartments/warehouses
#Application: Possible use in distributing cells to lymph nodes


param final_time           >= 0 integer;
param maximum_storage_time >= 0 integer;
param number_of_items      >= 0 integer;

set units          =  1..number_of_items;
set locations      =  1..number_of_items;
set extended_times = -1..final_time;
set real_times     =  1..final_time;
set old_times      = -1..0;

set warehouses within locations;

set unit_to_warehouse = {units, warehouses, real_times};
set allowed_unit_to_warehouse within unit_to_warehouse;
set forbidden_unit_to_warehouse = unit_to_warehouse diff allowed_unit_to_warehouse;

set warehouse_to_warehouse = {warehouses, warehouses, real_times};
set allowed_warehouse_to_warehouse within warehouse_to_warehouse;
set forbidden_warehouse_to_warehouse = warehouse_to_warehouse diff allowed_warehouse_to_warehouse;

param costs{units, locations, real_times}; 

var x{i in units, j in locations, k in extended_times} binary;

minimize total_cost: 
sum{i in units, j in locations, k in real_times} costs[i,j,k] * x[i,j,k];


#All units get assigned
subject to full_assignment_constraint{i in units, k in real_times}: 
sum{j in locations} x[i,j,k] = 1;


#Each location receives exactly one unit.
subject to onto_assignment_constraint{j in locations, k in real_times}: 
sum{i in units} x[i,j,k] = 1;


#Initial conditions for the system
#One could potentially have nonhomogeneous initial conditions
#in case some units were previously located in warehouses
subject to initial_conditions_constraint
{i in units, j in locations, k in old_times}:
x[i,j,k] = 0;


#Allowable assignments between units and warehouses
subject to forbidden_unit_to_warehouse_constraint{(i,j,k) in forbidden_unit_to_warehouse}:
x[i,j,k] = 0;


#Units can not stay for too long in storage
#Note that x[*,*,-1] and x[*,*,0] do exist
#The number of constraints can be easily reduced.
#However, we keep it as it is for simplicity.
subject to time_in_storage_constraint
{i in units, p in warehouses, q in warehouses, r in warehouses, k in real_times}:
x[i, p, k-2] + x[i, q, k-1] + x[i, r, k] <= maximum_storage_time;


#Each warehouse can only ship to specific warehouses
#Note that x[*,*,0] does exists and is the initial condition of the system.
subject to warehouse_to_warehouse_constraint{i in units, (r,s,k) in forbidden_warehouse_to_warehouse}:
x[i, r, k-1] + x[i,s, k] <= 1;
 
