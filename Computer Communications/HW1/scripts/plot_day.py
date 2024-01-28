import os
import pandas as pd
import matplotlib.pyplot as plt

data_folders = ["Day1_data", "Day2_data", "Day3_data", "Day4_data"]
bar_colors = ['b', 'g', 'r', 'c']

average_delays = []
std_deviations = []
day_labels = []

for folder, color in zip(data_folders, bar_colors):
    day_data = pd.DataFrame() 

    csv_files = []
    for time_folder in os.listdir(folder):
        for file in os.listdir(f'{folder}/{time_folder}'):
            if file.endswith("_last_hop.csv"):
                csv_files.append(f'{folder}/{time_folder}/{file}')

    for csv_file in csv_files:
        data = pd.read_csv(csv_file)
        day_data = pd.concat([day_data, data], ignore_index=True)

    average_delay = day_data['Delay (ms)'].mean()
    std_deviation = day_data['Delay (ms)'].std()
    
    average_delays.append(average_delay)
    std_deviations.append(std_deviation)
    day_labels.append(folder)

plt.figure(figsize=(10, 6))
plt.bar(day_labels, average_delays, color=bar_colors, yerr=std_deviations, capsize=5)
plt.title('Average Delay vs Day')
plt.xlabel('Day')
plt.ylabel('Mean Delay (ms)')
plt.show()
