/**
 * BLG 336E - Analysis of Algorithms II
 * Assignment 1
 * Abdullah Jafar Mansour Shamout
 * 150200919
 */

/* * * * * * * * * * * * * * * * * *
 * DO NOT MODIFY UNLESS REQUESTED  *
 * * * * * * * * * * * * * * * * * */

#include <iostream>
#include <vector>
#include <fstream>
#include <sstream>
#include <stack>
#include <queue>
#include <chrono> // For time measurement

/* INCLUDE ANY OTHER NECESSARY LIBRARIES HERE */
/* START YOUR CODE HERE */

#include <algorithm> // For sorting

/* END YOUR CODE HERE */

using namespace std;
using namespace std::chrono;

/* USE HERE IF YOU NEED TO DEFINE EXTRA FUNCTIONS */
/* START YOUR CODE HERE */

/* END YOUR CODE HERE */

/**
 * Perform Depth-First Search (DFS) traversal on a map.
 *
 * @param map The map represented as a 2D vector of integers.
 * @param row The starting row index for the DFS traversal.
 * @param col The starting column index for the DFS traversal.
 * @param resource The resource value to search for during the traversal.
 * @return The size of the colony found during the DFS traversal.
 */
int dfs(vector<vector<int>> &map, int row, int col, int resource)
{
    /* START YOUR CODE HERE */

    int size = 0;
    int rows = map.size();
    int cols = map[0].size();
    vector<pair<int, int>> directions = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}}; // defining the directions that I can go in the map

    stack<pair<int, int>> dfs_stack; // defining a stack for the implementation of the dfs algorithm
    dfs_stack.push({row, col});      // starting the process of dfs by pushing a point on the map to the stack

    while (!dfs_stack.empty()) // while the stack is not empty
    {
        pair<int, int> current = dfs_stack.top(); // get the value at the top of the stack
        dfs_stack.pop();                          // pop it from the stack
        int row = current.first;                  // get its row
        int col = current.second;                 // get its column

        if (row >= 0 && row < rows && col >= 0 && col < cols && map[row][col] == resource) // check if that point is valid and is not visited before
        {
            map[row][col] = -1; // Mark current cell as visited by changing its resource value to -1
            size++;             // Increment colony size

            // Explore all four directions
            for (auto &dir : directions)
            {
                int new_r = (row + dir.first + rows) % rows;  // Handle circularity
                int new_c = (col + dir.second + cols) % cols; // Handle circularity
                dfs_stack.push({new_r, new_c});               // Push the new point to the stack
            }
        }
    }

    return size;
    /* END YOUR CODE HERE */
}

/**
 * Perform Breadth-First Search (BFS) traversal on a map.
 *
 * @param map The map represented as a 2D vector of integers.
 * @param row The starting row index for the BFS traversal.
 * @param col The starting column index for the BFS traversal.
 * @param resource The resource value to search for during the traversal.
 * @return The size of the colony found during the BFS traversal.
 */
int bfs(vector<vector<int>> &map, int row, int col, int resource)
{

    /* START YOUR CODE HERE */
    int size = 0;
    int rows = map.size();
    int cols = map[0].size();
    vector<pair<int, int>> directions = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}}; // defining the directions that I can go in the map

    queue<pair<int, int>> bfs_queue; // defining a queue for the implementation of the bfs algorithm
    bfs_queue.push({row, col});      // starting the process of bfs by pushing a point on the map to the queue

    while (!bfs_queue.empty()) // while the queue is not empty
    {
        pair<int, int> current = bfs_queue.front(); // get the value at the front of the queue
        bfs_queue.pop();                            // pop it from the queue
        int row = current.first;                    // get its row
        int col = current.second;                   // get its column

        if (row >= 0 && row < rows && col >= 0 && col < cols && map[row][col] == resource) // check if that point is valid and is not visited before
        {
            map[row][col] = -1; // Mark current cell as visited by changing its resource value to -1
            size++;             // Increment colony size

            for (auto &dir : directions) // Explore all four directions
            {
                int new_r = (row + dir.first + rows) % rows;  // Handle circularity
                int new_c = (col + dir.second + cols) % cols; // Handle circularity
                bfs_queue.push({new_r, new_c});
            }
        }
    }

    return size;
    /* END YOUR CODE HERE */
}

/**
 * Finds the top-k largest colonies in a given map.
 *
 * @param map The map represented as a 2D vector of integers.
 * @param useDFS A boolean flag indicating whether to use Depth-First Search (DFS) or Breadth-First Search (BFS) algorithm.
 * @param k The number of top colonies to find.
 * @return A vector of pairs representing the size and resource type of the top-k largest colonies.
 */
vector<pair<int, int>> top_k_largest_colonies(vector<vector<int>> &map, bool useDFS, unsigned int k)
{

    auto start = high_resolution_clock::now(); // Start measuring time

    /* START YOUR CODE HERE */

    if (map.empty()) // if the map is empty
    {
        return {};
    }

    int rows = map.size();
    int cols = map[0].size();
    vector<pair<int, int>> result; // to store the result of the top-k largest colonies

    for (int i = 0; i < rows; i++) // loop over the rows of the map
    {
        for (int j = 0; j < cols; j++) // loop over the columns of the map
        {
            if (map[i][j] != -1) // if the cell is not visited before
            {
                int resource = map[i][j];                                                  // get the resource value of the cell
                int size = (useDFS ? dfs(map, i, j, resource) : bfs(map, i, j, resource)); // get the size of the colony using the selected algorithm
                result.push_back({size, resource});                                        // push the size and the resource value of the colony to the result vector
            }
        }
    }
    /* END YOUR CODE HERE */

    auto stop = high_resolution_clock::now();                 // Stop measuring time
    auto duration = duration_cast<nanoseconds>(stop - start); // Calculate the duration
    cout << "Time taken: " << duration.count() << " nanoseconds" << endl;

    /* START YOUR CODE HERE */

    // sort the result by size in descending order; if sizes are equal, then sort them by resource type in ascending order
    sort(result.begin(), result.end(), [](pair<int, int> x, pair<int, int> y)
         {
        if (x.first == y.first)
        {
            return x.second < y.second;
        }
        return x.first > y.first; });

    if (result.size() > k)
    {
        result.resize(k);
    }
    return result;

    /* END YOUR CODE HERE */
}

// Main function
int main(int argc, char *argv[])
{

    // Check the command line arguments
    if (argc != 4)
    {

        // It should be: <1 or 0> <k> <filename.txt>
        cerr << "Usage: " << argv[0] << " <1 or 0> <k> <filename.txt>" << endl;
        return 1;
    }

    // Get the arguments
    bool useDFS = (atoi(argv[1]) == 1);
    int k = atoi(argv[2]);

    // Read the map from the text file
    string filename = argv[3];
    ifstream file(filename);
    if (!file.is_open())
    {
        cerr << "Error: Unable to open file." << endl;
        return 1;
    }

    vector<vector<int>> sector_map;
    string line;
    while (getline(file, line))
    {
        istringstream iss(line);
        vector<int> row;
        int num;
        while (iss >> num)
        {
            row.push_back(num);
        }
        sector_map.push_back(row);
    }
    file.close();

    // Find the largest colony
    vector<pair<int, int>> result = top_k_largest_colonies(sector_map, useDFS, k);

    // Print the result
    cout << "Algorithm: " << (useDFS ? "DFS" : "BFS") << endl;
    cout << "Map: " << filename << endl;

    // If no colonies are found
    if (result.empty())
    {
        cout << "No colonies found." << endl;
        return 0;
    }

    // Print the top-k colonies
    for (size_t i = 0; i < result.size(); ++i)
    {
        cout << "Colony " << i + 1 << ": Size = " << result[i].first << ", Resource Type = " << result[i].second << endl;
    }

    return 0;
}