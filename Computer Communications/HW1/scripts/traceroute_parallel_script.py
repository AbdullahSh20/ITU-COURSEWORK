import asyncio
import re
import csv

all_measurements = []
destinations = ["itu.edu.tr", "metu.edu.tr", "en.iyte.edu.tr", "erbakan.edu.tr", "uzh.ch", "google.com", "cam.ac.uk", "univie.ac.at", "kyoto-u.ac.jp", "mit.edu"]

csvfile_name = 'Day4_Night_data'  # should be edited based on the csvfile name wanted as output

async def run_traceroute(destination, num_trials):
    destination_measurements = []
    try:
        tasks = []

        for trial in range(num_trials):
            task = asyncio.create_subprocess_exec(
                "traceroute", destination,
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
                text=False
            )
            tasks.append(task)

        processes = await asyncio.gather(*tasks)

        for process in processes:
            stdout, _ = await process.communicate()
            stdout = stdout.decode('utf-8')
            lines = stdout.split('\n')

            for line in lines:
                match = re.search(r'\d+\s+(.*?)\s+(\d+\.\d+)\s+ms', line)
                if match:
                    hop, delay = match.groups()
                    print(f"Hop {hop}: {delay} ms")
                    destination_measurements.append([destination, hop, delay])
                elif not line.strip():
                    destination_measurements.append(["", "", ""])

        return destination_measurements

    except Exception as e:
        print(f"Error running traceroute to {destination}: {e}")
        return []

async def main():
    tasks = []
    for destination in destinations:
        print(f"Destination: {destination}")
        destination_data = []
        for num_trials in range(10, 101, 10):
            task = asyncio.create_task(run_traceroute(destination, num_trials))
            tasks.append(task)


    destination_data = await asyncio.gather(*tasks)

    if destination_data:
        all_measurements.extend([item for sublist in destination_data for item in sublist])

    if all_measurements:
        with open(f'{csvfile_name}.csv', 'w', newline='') as csvfile:
            csvwriter = csv.writer(csvfile)
            csvwriter.writerow(['Destination', 'Hop', 'Delay (ms)'])
            for measurement in all_measurements:
                csvwriter.writerow(measurement)

        print(f"Data saved to {csvfile_name}.csv")
    else:
        print("No measurements were recorded. Please check your traceroute command.")

if __name__ == "__main__":
    asyncio.run(main())
