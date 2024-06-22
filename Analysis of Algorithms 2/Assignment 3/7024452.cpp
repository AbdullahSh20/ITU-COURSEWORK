/**
 * BLG 336E - Analysis of Algorithms II
 * Assignment 3
 * Abdullah Jafar Mansour Shamout
 * 150200919
 */

#include <iostream>
#include <vector>
#include <fstream>
#include <sstream>
#include <algorithm>

/* YOU CAN INCLUDE ANY OTHER NECESSARY LIBRARIES */

#include <map>     // To use map data structure
#include <cmath>   // To use round function
#include <iomanip> // To use setprecision function

/* YOU CAN DEFINE EXTRA FUNCTIONS AND MODIFY THE CODE TEMPLATE */

/* YOU HAVE TO CONSIDER THE OUTPUT FORMAT TO TEST YOUR CODE WITH CALICO */

using namespace std;

struct TimeInterval
{
    // YOUR CODE HERE
    string floor_number;
    string room_number;
    string start_time;
    string end_time;
};

struct Priority
{
    // YOUR CODE HERE
    string floor_number;
    string room_number;
    int priority_value;
};

struct Item
{
    // YOUR CODE HERE
    string item_name;
    int price;
    double value;
};

struct TimeSlot
{
    // YOUR CODE HERE
    string room_number;
    string start_time;
    string end_time;
    int priority_value;
};

/* START: WEIGHTED INTERVAL SCHEDULING (for each floor) */

struct Schedule
{
    // YOUR CODE HERE
    string floor_number;
    vector<TimeInterval> intervals;
    vector<TimeSlot> items;
    int total_priority = 0;
};

// error handling function

void errorHandling(string msj)
{
    cerr << msj << endl;
    cout << "An error has occured. Exiting..." << endl;
    exit(1);
}

/******************************************************************************************************/
/******************************************************************************************************/
/******************************************************************************************************/
/************************read functions to get the values from the files*******************************/
/******************************************************************************************************/
/******************************************************************************************************/
/******************************************************************************************************/
vector<TimeInterval> read_intervals(const string &file_name) // Function to read time intervals from the file
{
    ifstream file(file_name);
    vector<TimeInterval> intervals;
    string line;
    string floor_name;
    string room_number;
    string start_time;
    string end_time;

    bool open = file.is_open(); // Check if the file is open
    if (!open)
    {
        errorHandling("Unable to open file: " + file_name); // Print an error message if the file cannot be opened
    }
    else
    {
        getline(file, line);
        while (getline(file, line)) // Read the file line by line
        {
            stringstream string_stream(line);
            string_stream >> floor_name >> room_number >> start_time >> end_time;
            intervals.push_back({floor_name, room_number, start_time, end_time}); // Add the interval to the intervals list
        }
        file.close();
    }

    return intervals;
}

vector<Priority> read_priorities(const string &file_name) // Function to read priorities from the file
{
    ifstream file(file_name);
    vector<Priority> priorities;
    string line;
    int priority_value;
    string floor_name;
    string room_number;

    bool open = file.is_open(); // Check if the file is open
    if (!open)
    {
        errorHandling("Unable to open file: " + file_name); // Print an error message if the file cannot be opened
    }
    else
    {
        getline(file, line);
        while (getline(file, line)) // Read the file line by line
        {
            stringstream string_stream(line);
            string_stream >> floor_name >> room_number >> priority_value;
            priorities.push_back({floor_name, room_number, priority_value}); // Add the priority to the priorities list
        }
        file.close();
    }

    return priorities;
}

vector<Item> read_items(const string &file_name) // Function to read items from the file
{
    ifstream file(file_name);
    vector<Item> items;
    string line;
    string item_name;
    int price;
    double value;

    bool open = file.is_open(); // Check if the file is open
    if (!open)
    {
        errorHandling("Unable to open file: " + file_name); // Print an error message if the file cannot be opened
    }
    else
    {
        getline(file, line);
        while (getline(file, line)) // Read the file line by line
        {
            stringstream string_stream(line);
            string_stream >> item_name >> price >> value;
            items.push_back({item_name, price, value}); // Add the item to the items list
        }
        file.close();
    }

    return items;
}

tuple<vector<TimeInterval>, vector<Priority>, vector<Item>> load(const string &path) // Function to load the values from the files
{
    vector<TimeInterval> time_intervals = read_intervals(path + "/room_time_intervals.txt"); // Read the time intervals
    vector<Priority> priorities = read_priorities(path + "/priority.txt");                   // Read the priorities
    vector<Item> items = read_items(path + "/items.txt");                                    // Read the items

    return make_tuple(time_intervals, priorities, items);
}

/******************************************************************************************************/
/******************************************************************************************************/
/******************************************************************************************************/
/*********************************Scheduling required functions****************************************/
/******************************************************************************************************/
/******************************************************************************************************/
/******************************************************************************************************/

vector<Schedule> process_schedules(const vector<TimeInterval> &intervals, const vector<Priority> &priorities)
{
    map<string, map<string, int>> priority_map;    // Maps floor name to room number to priority value
    for (size_t i = 0; i < priorities.size(); ++i) // Iterate over priorities
    {
        const Priority &priority = priorities[i];
        priority_map[priority.floor_number][priority.room_number] = priority.priority_value; // Add the priority value to the map
    }

    map<string, Schedule> schedule_map;           // Maps floor name to schedule
    for (size_t i = 0; i < intervals.size(); ++i) // Iterate over intervals
    {
        const TimeInterval &interval = intervals[i];
        TimeSlot item{interval.room_number, interval.start_time, interval.end_time, 0};

        auto itFloor = priority_map.find(interval.floor_number); // Find the floor in the priority map
        if (itFloor != priority_map.end())                       // If the floor is found
        {
            auto itRoom = itFloor->second.find(interval.room_number); // Find the room in the floor
            if (itRoom != itFloor->second.end())
            {
                item.priority_value = itRoom->second; // Set the priority value
            }
        }
        schedule_map[interval.floor_number].floor_number = interval.floor_number; // Set the floor number
        schedule_map[interval.floor_number].items.push_back(item);                // Add the item to the schedule
    }

    vector<Schedule> schedules;                                          // Vector to store schedules
    for (auto it = schedule_map.begin(); it != schedule_map.end(); ++it) // Iterate over the schedule map
    {
        schedules.push_back(it->second); // Add the schedule to the schedules vector
    }
    return schedules;
}

// function to find the best schedule for each floor
vector<Schedule> weighted_interval_scheduling(vector<Schedule> &schedules)
{
    for (auto &floor_schedule : schedules)
    {
        sort(floor_schedule.items.begin(), floor_schedule.items.end(), [](const TimeSlot &x, const TimeSlot &y)
             { return x.end_time < y.end_time; }); // Sort the items by end time

        int num_items = floor_schedule.items.size(); // Get the number of items
        vector<int> parent_index(num_items, -1);     // Vector to store the parent index
        vector<int> max_priority(num_items, 0);      // Vector to store the maximum priority

        max_priority[0] = floor_schedule.items[0].priority_value;

        for (int i = 1; i < num_items; i++) // Iterate over the items
        {
            int include = floor_schedule.items[i].priority_value;
            int non_conflicting = -1;
            for (int j = i - 1; j >= 0; j--) // Iterate over the items
            {
                if (floor_schedule.items[j].end_time <= floor_schedule.items[i].start_time) // Check if the items conflict
                {
                    non_conflicting = j;
                    break;
                }
            }
            if (non_conflicting != -1) // If the items do not conflict
            {
                include += max_priority[non_conflicting]; // Add the maximum priority
                parent_index[i] = non_conflicting;        // Set the parent index
            }
            if (max_priority[i - 1] > include) // Check if the previous item has a higher priority
            {
                max_priority[i] = max_priority[i - 1]; // Set the maximum priority
            }
            else
            {
                max_priority[i] = include; // Set the maximum priority
            }
        }

        floor_schedule.total_priority = max_priority[num_items - 1];

        vector<TimeSlot> best_schedule_items; // Vector to store the best schedule items
        for (int i = num_items - 1; i >= 0;)  // Iterate over the items
        {
            if (i == 0 || max_priority[i] != max_priority[i - 1]) // Check if the priority is the best
            {
                best_schedule_items.push_back(floor_schedule.items[i]);
                i = parent_index[i];
            }
            else
            {
                i--;
            }
        }
        reverse(best_schedule_items.begin(), best_schedule_items.end()); // Reverse the best schedule items
        floor_schedule.items = best_schedule_items;
    }

    return schedules;
}

// *** END ***

/* START: KNAPSACK (for items) */

// Function to select the most valuable items that can be purchased with a certain budget
vector<Item> knapsack(const vector<Item> &items, int budget)
{
    int num_items = items.size();
    vector<vector<double>> dp(num_items + 1, vector<double>(budget + 1, 0.0)); // Vector to store the dynamic programming values

    for (int i = 1; i <= num_items; ++i) // Iterate over the items
    {
        for (int remaining_budget = 1; remaining_budget <= budget; ++remaining_budget) // Iterate over the budget
        {
            if (!(items[i - 1].price <= remaining_budget)) // Check if the item can't be purchased
            {
                dp[i][remaining_budget] = dp[i - 1][remaining_budget]; // Set the value to the previous value
            }
            else
            {
                dp[i][remaining_budget] = max(dp[i - 1][remaining_budget], dp[i - 1][remaining_budget - items[i - 1].price] + items[i - 1].value); // Set the value to the maximum value
            }
        }
    }

    int remaining_budget = budget;
    vector<Item> selected_items;
    for (int i = num_items; i > 0 && remaining_budget > 0; --i) // Iterate over the items
    {
        if (dp[i - 1][remaining_budget] != dp[i][remaining_budget]) // Check if the item is selected
        {
            selected_items.push_back(items[i - 1]);
            remaining_budget -= items[i - 1].price;
        }
    }

    return selected_items;
}

// *** END ***

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        errorHandling("Please provide the case number as an argument.");
    }

    string case_no = argv[1];
    string case_name = "case_" + case_no;
    string path = "./inputs/" + case_name;
    int total_budget = 200000;

    /***************************load the variables from the files****************************/
    vector<TimeInterval> time_intervals;
    vector<Priority> priorities;
    vector<Item> items;
    tie(time_intervals, priorities, items) = load(path);

    /***************************do the required preparing****************************/
    vector<Schedule> schedules = process_schedules(time_intervals, priorities);
    vector<Schedule> optimal_schedules = weighted_interval_scheduling(schedules);

    /***************************knapsack with the budget****************************/
    vector<Item> picked_items = knapsack(items, total_budget);

    // produce the required output
    cout << "Best Schedule for Each Floor" << endl;
    for (size_t i = 0; i < optimal_schedules.size(); ++i) // Iterate over optimal_schedules
    {
        const auto &schedule = optimal_schedules[i];
        cout << schedule.floor_number << " --> Priority Gain: " << schedule.total_priority << endl;
        for (size_t j = 0; j < schedule.items.size(); ++j)
        {
            const auto &item = schedule.items[j];
            cout << schedule.floor_number << "\t" << item.room_number << "\t" << item.start_time << "\t" << item.end_time << endl;
        }
    }

    cout << "Best Use of Budget" << endl;
    double total_value = 0.0;
    for (const auto &item : picked_items) // Iterate over picked_items
    {
        total_value += item.value; // Add the value to the total value
    }
    cout << "Total Value --> " << fixed << setprecision(1) << round(total_value * 10) / 10 << endl; // Print the total value
    for (size_t i = 0; i < picked_items.size(); ++i)
    {
        cout << picked_items[i].item_name << endl; // Print the item name
    }

    return 0;
}
