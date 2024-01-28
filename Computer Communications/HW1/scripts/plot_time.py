import os
import pandas as pd
import matplotlib.pyplot as plt

data_folders = ["Day1_data", "Day2_data", "Day3_data", "Day4_data"]
bar_colors = ['b', 'g', 'r']

average_delays = []
std_deviations = []
time_folders = ["Morning_data", "Afternoon_data", "Night_data"]

Morning_data_csv = []
Afternoon_data_csv = []
Night_data_csv = []


Morning_data = pd.DataFrame()
Afternoon_data = pd.DataFrame()
Night_data = pd.DataFrame()

for day_folder in data_folders:
    for time_folder,color in zip(time_folders, bar_colors):
        for file in os.listdir(f"{day_folder}/{time_folder}"):
            if file.endswith("Morning_last_hop.csv"):
                Morning_data_csv.append(f'{day_folder}/{time_folder}/{file}')
            elif file.endswith('Afternoon_last_hop.csv'):
                Afternoon_data_csv.append(f'{day_folder}/{time_folder}/{file}')
            elif file.endswith('Night_last_hop.csv'):
                Night_data_csv.append(f'{day_folder}/{time_folder}/{file}')

for csv_file in Morning_data_csv:
    data = pd.read_csv(csv_file)
    Morning_data = pd.concat([Morning_data, data], ignore_index=True)


for csv_file in Afternoon_data_csv:
    data = pd.read_csv(csv_file)
    Afternoon_data = pd.concat([Afternoon_data, data], ignore_index=True)


for csv_file in Night_data_csv:
    data = pd.read_csv(csv_file)
    Night_data = pd.concat([Night_data, data], ignore_index=True)

average_delays = []
time_labels = ["Morning", "Afternoon", "Night"]

for time_data in [Morning_data, Afternoon_data, Night_data]:
    average_delay = time_data['Delay (ms)'].mean()
    average_delays.append(average_delay)

plt.bar(time_labels, average_delays, color=bar_colors)
plt.xlabel('Time of Day')
plt.ylabel('Average Delay')
plt.title('Average Delay vs. Time of Day')
plt.show()
