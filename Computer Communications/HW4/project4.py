# Abdullah Jafar Mansour Shamout
# 150200919
import networkx as nx
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import tkinter as tk
from tabulate import tabulate
import time
import random
import sys
import heapq

class RoutingSimulator:
    def __init__(self):
        self.root = tk.Tk()
        self.root.title("Routing Simulator")
        self.root.attributes('-fullscreen', True)

        self.paned_window = tk.PanedWindow(self.root, orient=tk.HORIZONTAL)
        self.paned_window.pack(expand=1, fill="both")

        self.output_frame = tk.Frame(self.root, width=100)
        self.paned_window.add(self.output_frame)

        self.graph_frame = tk.Frame(self.root, width=100)
        self.paned_window.add(self.graph_frame)

        self.create_widgets()

        self.highlighted_path = None 
        self.graph = None
        self.canvas = None
        self.layout = None 

        sys.stdout = self 

        self.root.mainloop()

    def create_widgets(self):
        
        button_style = {'padx': 10, 'pady': 5, 'bg': '#4CAF50', 'fg': 'white', 'borderwidth': 2, 'relief': 'groove'}


        input_frame = tk.Frame(self.output_frame, pady=10)
        input_frame.pack()

        self.num_nodes_label = tk.Label(input_frame, text="Enter the number of nodes in the network:", font=('Arial', 12))
        self.num_nodes_label.grid(row=0, column=0, padx=5, pady=5, sticky='e')

        self.num_nodes_entry = tk.Entry(input_frame, font=('Arial', 12))
        self.num_nodes_entry.grid(row=0, column=1, padx=5, pady=5)


        buttons_frame = tk.Frame(self.output_frame, pady=10)
        buttons_frame.pack()

        self.generate_graph_button = tk.Button(buttons_frame, text="Generate Graph", command=self.generate_random_topology, **button_style)
        self.generate_graph_button.grid(row=0, column=0, padx=5, pady=5)

        self.run_simulation_button = tk.Button(buttons_frame, text="Run Simulation", command=self.run_simulation, **button_style)
        self.run_simulation_button.grid(row=0, column=1, padx=5, pady=5)

        self.highlight_button = tk.Button(buttons_frame, text="Highlight Shortest Path", command=self.highlight_shortest_path_from_input, **button_style)
        self.highlight_button.grid(row=0, column=2, padx=5, pady=5)

        nodes_frame = tk.Frame(self.output_frame, pady=10)
        nodes_frame.pack()

        self.source_node_label = tk.Label(nodes_frame, text="Source Node:", font=('Arial', 12))
        self.source_node_label.grid(row=0, column=0, padx=5, pady=5, sticky='e')

        self.source_node_entry = tk.Entry(nodes_frame, font=('Arial', 12))
        self.source_node_entry.grid(row=0, column=1, padx=5, pady=5)

        self.dest_node_label = tk.Label(nodes_frame, text="Destination Node:", font=('Arial', 12))
        self.dest_node_label.grid(row=0, column=2, padx=5, pady=5, sticky='e')

        self.dest_node_entry = tk.Entry(nodes_frame, font=('Arial', 12))
        self.dest_node_entry.grid(row=0, column=3, padx=5, pady=5)

        self.exit_button = tk.Button(self.output_frame, text="Exit", command=self.root.destroy, padx=50, pady=5, bg='#FF5733', fg='white', borderwidth=2, relief='groove', font=('Arial', 12))
        self.exit_button.pack(side=tk.BOTTOM, pady=10, fill=tk.X)

        self.text_widget = tk.Text(self.output_frame, wrap=tk.NONE, width=130, height=80)
        self.text_widget.pack(pady=10, fill=tk.BOTH, expand=True)

        x_scrollbar = tk.Scrollbar(self.output_frame, orient=tk.HORIZONTAL, command=self.text_widget.xview)
        x_scrollbar.pack(side=tk.BOTTOM, fill=tk.X)
        self.text_widget.configure(xscrollcommand=x_scrollbar.set)
        


    def generate_random_topology(self):
        if self.num_nodes_entry.get() == "":
            self.write("Please enter a number of nodes.")
            return

        self.reset_highlight()

        num_nodes = int(self.num_nodes_entry.get())
        connected = False

        while not connected:
            G = nx.erdos_renyi_graph(num_nodes, 0.4)
            connected = nx.is_connected(G)

        for i, j in G.edges():
            G[i][j]['weight'] = random.randint(1, 10)

        self.graph = G
        self.layout = nx.spring_layout(G)
        self.plot_graph()

    def reset_highlight(self):
        if self.graph and self.highlighted_path:
            for edge in self.highlighted_path.edges():
                self.graph[edge[0]][edge[1]].pop('highlighted', None)
            self.highlighted_path = None

    def plot_graph(self):
        if self.canvas:
            self.canvas.get_tk_widget().destroy()

        plt.clf()
        pos = self.layout if self.layout else nx.spring_layout(self.graph)
        nx.draw(self.graph, pos, with_labels=True, font_weight='bold', node_color='darkblue', edge_color='black', width=1, node_size=500, font_color='white')

        edge_labels = {(i, j): self.graph[i][j].get('weight', '') for i, j in self.graph.edges()}
        nx.draw_networkx_edge_labels(self.graph, pos, edge_labels=edge_labels, font_color='red')

        if self.highlighted_path:
            edge_colors = ['blue' if self.graph[i][j].get('highlighted', False) else 'blue' for i, j in self.graph.edges()]
            nx.draw_networkx_edges(self.highlighted_path, pos, edge_color=edge_colors, width=3)
            nx.draw_networkx_edge_labels(self.graph, pos, edge_labels=edge_labels, font_color='red')

        self.canvas = FigureCanvasTkAgg(plt.gcf(), master=self.graph_frame)
        self.canvas.draw()
        self.canvas.get_tk_widget().pack(side=tk.TOP, fill=tk.BOTH, expand=1)

    def highlight_shortest_path_from_input(self):
        source = self.source_node_entry.get()
        dest = self.dest_node_entry.get()

        if not source or not dest:
            self.write("Please enter both source and destination nodes.")
            return

        try:
            source = int(source)
            dest = int(dest)
        except ValueError:
            self.write("Invalid node indices. Please enter valid integers.")
            return

        self.reset_highlight()

        self.highlight_shortest_path(source, dest)

    def highlight_shortest_path(self, src, dest):
        if self.graph is None or self.layout is None:
            self.write("Generate a graph first.")
            return

        if self.highlighted_path:
            self.reset_highlight()

        shortest_path = nx.shortest_path(self.graph, source=src, target=dest, weight='weight')
        self.highlighted_path = nx.Graph()
        self.highlighted_path.add_nodes_from(shortest_path)
        self.highlighted_path.add_edges_from(zip(shortest_path, shortest_path[1:]))
        
        for edge in self.highlighted_path.edges():
            self.graph[edge[0]][edge[1]]['highlighted'] = True

        self.plot_graph()

    def run_simulation(self):
        if not self.graph:
            self.write("Generate a graph first.")
            return

        link_state_start_time = time.time()
        self.write("Running Link State Routing:")
        link_state_results = self.link_state_routing()
        link_state_elapsed_time = time.time() - link_state_start_time
        self.print_routing_table("Link State Routing", link_state_results)
        self.write(f"Time elapsed for Link State Routing: {link_state_elapsed_time:.10f} seconds")

        self.routing_tables = {}

        distance_vector_start_time = time.time()
        self.write("\nRunning Distance Vector Routing:")
        distance_vector_results = self.distance_vector_routing()
        distance_vector_elapsed_time = time.time() - distance_vector_start_time
        self.print_routing_table("Distance Vector Routing", distance_vector_results)
        self.write(f"Time elapsed for Distance Vector Routing: {distance_vector_elapsed_time:.10f} seconds")


    def link_state_routing(self):
        if self.layout is None:
            self.write("Generate a graph first.")
            return

        G = self.graph
        shortest_paths = {}

        for src in G.nodes:
            shortest_paths[src] = {}
            for dest in G.nodes:
                if src != dest:
                    shortest_paths[src][dest] = self.dijkstra_shortest_path(G, src, dest)

        return shortest_paths

    def dijkstra_shortest_path(self, graph, src, dest):
        heap = [(0, src, [])]
        visited = set()

        while heap:
            cost, current_router, path = heapq.heappop(heap)

            if current_router in visited:
                continue

            visited.add(current_router)
            path = path + [current_router]

            if current_router == dest:
                return path

            for neighbor, link_cost in graph[current_router].items():
                new_cost = cost + link_cost['weight']
                heapq.heappush(heap, (new_cost, neighbor, path))

        return None

    def distance_vector_routing(self):
        if self.layout is None:
            self.write("Generate a graph first.")
            return

        G = self.graph
        routing_tables = {}

        for src in G.nodes:
            routing_tables[src] = {}
            for dest in G.nodes:
                if src != dest:
                    routing_tables[src][dest] = self.bellman_ford_routing(G, src, dest)

        return routing_tables

    def bellman_ford_routing(self, graph, src, dest):
        distance_vector = {router: float('inf') for router in graph.nodes}
        distance_vector[src] = 0
        next_hop = {router: None for router in graph.nodes}

        for _ in range(len(graph.nodes) - 1):
            for router in graph.nodes:
                for neighbor, link_cost in graph[router].items():
                    if distance_vector[router] + link_cost['weight'] < distance_vector[neighbor]:
                        distance_vector[neighbor] = distance_vector[router] + link_cost['weight']
                        next_hop[neighbor] = router

        path = [dest]
        current_router = dest
        while next_hop[current_router] is not None:
            path.insert(0, next_hop[current_router])
            current_router = next_hop[current_router]

        return path

    def print_routing_table(self, algorithm_name, results):
        G = self.graph
        self.write(f"\nRouting Table ({algorithm_name}):")
        
        headers = [f"Node {node}" for node in G.nodes]
        table_data = []

        for src in G.nodes:
            row_data = [f"Node {src}"]
            for dest in G.nodes:
                if src != dest:
                    shortest_path = results[src][dest]
                    total_cost = sum(G[shortest_path[i]][shortest_path[i + 1]]['weight'] for i in range(len(shortest_path) - 1))
                    row_data.append(f"Cost: {total_cost}, Path: {shortest_path}")
                else:
                    row_data.append("-")
            table_data.append(row_data)

        self.write(tabulate(table_data, headers=headers, tablefmt="fancy_grid"))

        for src in G.nodes:
            for dest in G.nodes:
                if src != dest:
                    path = results[src][dest]
                    total_cost = sum(G[path[i]][path[i + 1]]['weight'] for i in range(len(path) - 1))
                    hop_count = len(path) - 1
                    self.write(f"Path from Node {src} to Node {dest}: Total Cost={total_cost}, Hop Count={hop_count}, total delay={total_cost * 2 + hop_count * 3} us")

    def write(self, text):
        self.text_widget.insert(tk.END, text + '\n')
        self.text_widget.see(tk.END)

if __name__ == "__main__":
    simulator = RoutingSimulator()
