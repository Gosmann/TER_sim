# TER_sim

This simulation has been made as an educational project for an integration discipline at École Centrale de Lille. It simulates a small electrical grid, initially with 2 synchronous machines and an initial charge in equilibrium. A new charge is suddenly connected. In later simulations, a photovoltaic farm and en eolic turbine have been added.

The objetive of the work was to demonstrate how droop control works to maintain a stable grid frequency in primary frequency control. It is essentialy a proportion control system, so it stabilizes the grid with a small frequency deviation. Other control mechanisms may be used in real life to bring it back to nominal levels or respond to different scales of perturbation. 

By physical construction, synchronous machines store energy as angular momentum in their massive turbines. A desiquibrilium between production and consumption of electrical energy can be modeled as an electric torque, which converts the mechanical energy into additional electric energy. Without any intervention, this would cause a fast frequency and voltage drop, with a potential for damanging equipement or even a black-out. So, in the following seconds, droop-control should command the actuators to increase the active energy produced. 

On the other hand, intermittent sources, such as wind and solar, use power electronics to connect to the grid and don't have any significant energy storage. So, if the percentage of intermittent power generation increases, it is expected that the frequency deviations might pose a problem. 
