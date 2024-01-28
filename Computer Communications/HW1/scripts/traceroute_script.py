import subprocess
import re
import csv


all_measurements = []
destinations = ["itu.edu.tr", "metu.edu.tr", "en.iyte.edu.tr", "erbakan.edu.tr", "uzh.ch", "google.com", "cam.ac.uk", "univie.ac.at", "kyoto-u.ac.jp", "mit.edu"]

csvfile_name = 'Day4_Night_data'        #should be edited based on the csvfile name wanted as ouput

num_trials = 100

def run_traceroute(destination):
    destination_measurements = []
    try:
        output = subprocess.check_output(["traceroute", destination], universal_newlines=True)
        lines = output.split('\n')

        for line in lines:
            match = re.search(r'\d+\s+(.*?)\s+(\d+\.\d+)\s+ms', line)
            if match:
                hop, delay = match.groups()
                print(f"Hop {hop}: {delay} ms")
                destination_measurements.append([destination, hop, delay])

        destination_measurements.append(["", "", ""])

        return destination_measurements

    except subprocess.CalledProcessError:
        print(f"Error running traceroute to {destination}.")
        return []


for destination in destinations:
    print(f"Destination: {destination}")
    destination_data = []
    for trial in range(num_trials):
        print(f"Trial {trial + 1} - Traceroute to {destination}:")
        destination_data.extend(run_traceroute(destination))
        print()

    if destination_data:
        all_measurements.extend(destination_data)


if all_measurements:
    with open(f'{csvfile_name}.csv', 'w', newline='') as csvfile:
        csvwriter = csv.writer(csvfile)
        csvwriter.writerow(['Destination', 'Hop', 'Delay (ms)'])
        csvwriter.writerows(all_measurements)

    print(f"Data saved to {csvfile_name}")
else:
    print("No measurements were recorded. Please check your traceroute command.")
