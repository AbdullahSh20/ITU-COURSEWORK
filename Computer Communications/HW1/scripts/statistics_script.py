import pandas as pd

csvfile_name = 'Day4_Night_data'                            #should be edited for the name to read the data from
df = pd.read_csv(f"{csvfile_name}.csv")


group = 0
group_column = []


for index, row in df.iterrows():
    if pd.isna(row["Destination"]):
        group += 1
    group_column.append(group)


df["Group"] = group_column


df = df.dropna(subset=["Destination"])

df.reset_index(drop=True, inplace=True)

last_rows = df.groupby("Group").tail(1)

last_rows.reset_index(drop=True, inplace=True)

last_rows.to_csv("Day4_Night_last_hop.csv", index=False)       #should be edited for the name of the output csv
data = pd.read_csv("Day4_Night_last_hop.csv")                  #should be edited for the name of the output csv

result = data.groupby("Destination")["Delay (ms)"].agg(['max', 'min', 'mean']).reset_index()

result.columns = ["Destination", "Max Delay", "Min Delay", "Average Delay"]

print(result)

