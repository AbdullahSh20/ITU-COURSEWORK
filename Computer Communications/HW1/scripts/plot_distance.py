import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os

data_folders = ["Day1_data", "Day2_data", "Day3_data", "Day4_data"]
times_of_day = ["Afternoon_data", "Morning_data", "Night_data"]

distance_data = pd.read_csv("destination_distance.csv")

data_frames = []

for day_folder in data_folders:
    for time_folder in times_of_day:
        folder_path = os.path.join(day_folder, time_folder)
        for file_name in os.listdir(folder_path):
            if file_name.endswith("_last_hop.csv"):
                file_path = os.path.join(folder_path, file_name)
                hop_data = pd.read_csv(file_path)
                data_frames.append(hop_data)

merged_data = pd.concat(data_frames)
average_delay = merged_data.groupby("Destination")["Delay (ms)"].mean().reset_index()
plt.figure(figsize=(10, 6))

destinations = average_delay["Destination"]
distance_legend = [distance_data[distance_data["Destination"] == dest]["Distance"].values[0] for dest in destinations]

colors = plt.get_cmap("viridis")(np.linspace(0, 1, len(destinations)))

bars = plt.bar(destinations, average_delay["Delay (ms)"], color=colors)

plt.title("Average Delay by Destination")
plt.xlabel("Destination")
plt.ylabel("Average Delay (ms)")
plt.xticks(rotation=45)

legend_labels = [f"{dest} ({dist} km)" for dest, dist in zip(destinations, distance_legend)]
legend_patches = [plt.Line2D([0], [0], color=color, lw=4) for color in colors]
legend = plt.legend(legend_patches, legend_labels, title="Distance (km)", loc="upper left", bbox_to_anchor=(1, 1))

plt.tight_layout()
plt.show()
