# TER_sim

This simulation has been made as an educational project for an integration discipline at École Centrale de Lille. It simulates a small electrical grid, initially with 2 synchronous machines and a charge in equilibrium. A new charge is suddenly connected. In later simulations, a photovoltaic farm and en eolic turbine have been added.

The objetive of this work was to demonstrate how droop control works to maintain a stable grid frequency in primary frequency control. It is essentialy a proportion control system, so it stabilizes the grid with a small frequency deviation. Other control mechanisms may be used in real life to bring it back to nominal levels or respond to different scales of perturbation. 

By physical construction, synchronous machines store energy as angular momentum in their massive turbines. A desiquibrilium between production and consumption of electrical energy can be modeled as an electromagnetic torque, which converts the mechanical energy into additional electric energy and slows down the machine. Without any intervention, this would cause a fast frequency and voltage drop, with a potential for damanging equipement or even causing a black-out. So, in the following seconds, droop-control should command the actuators to increase the active energy produced. 

On the other hand, intermittent sources, such as wind and solar, use power electronics to connect to the grid and don't have any significant energy storage. So, if the percentage of intermittent power generation increases, it is expected that the frequency deviations might pose a problem. 

The simulation is meant to be run with varying percentages of renewables. This process has been automated, together with the necessary graphs for visualisation in the file `automation.m`. The complete version is located in the `/automation` directory.

## Points for future work

This project has, for now, been abandoned by its creators, as the discipline is over. Anyway, these are some points that could be improved.

1. Model actuator mechanics more realistically. We have used a simple first-order transfer function to represent, for instance, the entire processs of opening a valve in a hydroelectric plant.
2. Making sure the synchronous machines have realistic parameters.
3. Improving the wind turbine model with Simscape and implementing a closed-loop maximum power point tracking (MPPT) instead of the open-loop approach.
4. Modeling the DC-AC converters with the power electronics. This has been made with ideal mathematical functions, so they may not contain the nuances of a real converter.
5. Using a more realistic battery model.
6. Adding transmision lines.
7. Automating also the change in battery nominal power. This has been manually changed in the matlab console. It can also be changed for each value of intermittent power, in order to have a 3d graph that relates Maximum frequency deviation, intermittent power, and battery power.
8. Measure the total energy consumed in the battery to estimate the necessary capacity.
9. Use a more sophisticated control loopin the battery, to reduce its required capacity in a given system.

## Dependencies

1. Matlab version 2023b
2. Simscape electrical
3. Simulink
