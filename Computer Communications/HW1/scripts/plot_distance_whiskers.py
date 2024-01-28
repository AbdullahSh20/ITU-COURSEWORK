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

grouped_data = merged_data.groupby("Destination").agg({
    "Delay (ms)": ["mean", "max", "min"],
}).reset_index()
grouped_data.columns = ["Destination", "Average Delay (ms)", "Max Delay (ms)", "Min Delay (ms)"]

plt.figure(figsize=(10, 6))

destinations = grouped_data["Destination"]
average_delay = grouped_data["Average Delay (ms)"]
distance_legend = [distance_data[distance_data["Destination"] == dest]["Distance"].values[0] for dest in destinations]
max_delay = grouped_data["Max Delay (ms)"]
min_delay = grouped_data["Min Delay (ms)"]

colors = plt.get_cmap("viridis")(np.linspace(0, 1, len(destinations)))

bars = plt.bar(destinations, average_delay, color=colors)

plt.errorbar(destinations, average_delay, yerr=[average_delay - min_delay, max_delay - average_delay], fmt='none', ecolor='gray', elinewidth=1, capsize=5)

plt.title("Average Delay by Destination with Whiskers (Max/Min Delay)")
plt.xlabel("Destination")
plt.ylabel("Average Delay (ms)")
plt.xticks(rotation=45)

legend_labels = [f"{dest} ({dist} km)" for dest, dist in zip(destinations, distance_legend)]
legend_patches = [plt.Line2D([0], [0], color=color, lw=4) for color in colors]
legend = plt.legend(legend_patches, legend_labels, title="Distance (km)", loc="upper left", bbox_to_anchor=(1, 1))

plt.tight_layout()
plt.show()
