# Routing Algorithms Simulation
# Abdullah Jafar Mansour Shamout
# 150200919

## Overview
This project simulates the behavior of Link State and Distance Vector Routing algorithms on a randomly generated network topology. The program allows users to input the number of nodes in the network and visualizes the routing paths on a graphical user interface (GUI).

## Features
- Random network topology generation
- Visualization of the network graph with weighted edges
- Link State Routing algorithm simulation
- Distance Vector Routing algorithm simulation
- Highlighting of the shortest paths on the network graph
- Display of forwarding tables and routing information
- Calculation of packet transmission delay, total cost, runtime, and hop counts

## Dependencies
- Python 3.x
- NetworkX library
- Matplotlib
- Tkinter
- Tabulate

## How to Run
1. Install the required dependencies by running:
   ```bash
   pip install networkx matplotlib tk tabulate
2. Run the project4.py file:
    ```bash
    python project4.py
3. Input the number of nodes and use the provided buttons to generate the graph, run simulations, and highlight paths.

## GUI Description
- The GUI consists of an input section for the number of nodes and buttons for actions such as generating the graph, running simulations, and highlighting paths.
- The generated network graph is displayed in the right panel.
- Forwarding tables, routing information, and simulation results are shown in the text area to the left.
- The screen windows are dynamic as shown in the video below, this is to be able to see the table better for larger networks. Also the text window is x-axis scrollable to be able to see the whole table if the graph is big.

## dynamic window
<video src="dynamic_window.mp4" controls title="dynamic window"></video>

## Algorithms
### Link State Routing
Link State Routing is a shortest path routing algorithm that uses Dijkstra's algorithm to find the shortest paths between all pairs of nodes in the network. The algorithm works by first constructing a complete map of the network, known as the Link State Database (LSDB), which contains information about the cost of each link in the network. Based on this database, Dijkstra's algorithm is then employed to compute the shortest paths from a source node to all other nodes.

#### Dijkstra's Algorithm Pseudocode
Dijkstra's algorithm is a well-known algorithm for finding the shortest path between nodes in a graph. The pseudocode is as follows:

```plaintext
function Dijkstra(graph, source):
    create empty set S
    create a list distance with an entry for each node, initialized to infinity
    create a list previous with an entry for each node, initialized to undefined
    
    distance[source] = 0
    
    while S does not contain all nodes:
        u = node in graph not in S with the smallest distance value
        add u to S
        
        for each neighbor v of u:
            if v is not in S:
                new_distance = distance[u] + weight(u, v)
                if new_distance < distance[v]:
                    distance[v] = new_distance
                    previous[v] = u

    return distance, previous
```

### Distance Vector Routing

Distance Vector Routing is a routing algorithm that applies the Bellman-Ford algorithm to compute the shortest paths from a source node to all other nodes in a network. This algorithm involves each node maintaining a routing table that contains the distance vector, representing the cost of reaching each destination, for all other nodes in the network. The routing table is periodically updated based on the exchange of distance vectors with neighboring nodes.

#### Bellman-Ford Algorithm Overview

The Bellman-Ford algorithm is a dynamic programming algorithm designed to find the shortest paths from a single source node to all other nodes in a weighted graph. The main steps of the algorithm include:

1. **Initialization:**
   - Create a list `distance` with an entry for each node, initialized to infinity.
   - Create a list `next_hop` with an entry for each node, initialized to undefined.
   - Set the distance to the source node as 0.

2. **Iterative Relaxation:**
   - For each iteration up to (number of nodes - 1):
     - Iterate over each edge (u, v) with weight w in the graph.
     - If `distance[u] + w` is less than `distance[v]`, update `distance[v]` and set `next_hop[v] = u`.

3. **Result:**
   - The final `distance` list represents the shortest distances from the source node to all other nodes.
   - The `next_hop` list contains the next-hop node for each destination.

#### Bellman-Ford Algorithm Pseudocode

```plaintext
function BellmanFord(graph, source):
    create a list distance with an entry for each node, initialized to infinity
    create a list next_hop with an entry for each node, initialized to undefined
    
    distance[source] = 0
    
    for each iteration up to (number of nodes - 1):
        for each edge (u, v) with weight w in graph:
            if distance[u] + w < distance[v]:
                distance[v] = distance[u] + w
                next_hop[v] = u

    return distance, next_hop
```
In Distance Vector Routing, forwarding tables and routing information are then displayed based on the computed distance vectors, providing insights into the network's topology and path costs.


## Simulation Results
- The program outputs forwarding tables, packet transmission delay, total cost, runtime, and hop counts for each simulation.
- These results are displayed in the text area at the left of the GUI.
- for calculating the packet transmission delay, the program uses the following formula:
- `delay = total_cost * 2 + hop_count * 3` microseconds, I did this arbitrarily since no constraints were given on how to calculate it, but I took in consideration that delays could occur at hops and traveling between nodes which is realistic.

## Videos and Demonstrations'
Simulation:
<video src="simulation.mp4" controls title="simulation"></video>

## Conclusion
This project successfully implements and visualizes Link State and Distance Vector Routing algorithms on randomly generated network topologies. The GUI provides an intuitive interface to observe the routing behavior and simulation results.
