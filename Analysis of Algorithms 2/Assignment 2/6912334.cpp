/**
 * BLG 336E - Analysis of Algorithms II
 * Assignment 2
 * Abdullah Jafar Mansour Shamout
 * 150200919
 */

#include <iostream>  // For input/output
#include <cmath>     // For distance calculations
#include <vector>    // For vector operations
#include <algorithm> // For sorting operations
#include <limits>    // For min(), max() functions
#include <fstream>   // To read/write files
#include <chrono>    // For time measurement

//(These libraries are sufficient for this assignment.)

using namespace std;

// Structure to represent a point in 2D space
struct Point
{
    double x, y;
};

// Helper function to calculate distance between two points
double distance(Point p1, Point p2)
{
    // YOUR CODE HERE
    return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y)); // a^2 + b^2 = c^2
}

// Helper function to compare points based on x-coordinate, can use this for sorting.
bool compareX(Point p1, Point p2)
{
    // YOUR CODE HERE
    return p1.x < p2.x;
}

// Helper function to compare points based on y-coordinate, can use this for sorting.
bool compareY(Point p1, Point p2)
{
    // YOUR CODE HERE
    return p1.y < p2.y;
}

// Function to find the closest pair of points using brute force.
pair<Point, Point> bruteForceClosestPair(vector<Point> &points, int start, int end)
{
    // YOUR CODE HERE
    double min_dist = numeric_limits<double>::max(); // Initialize the minimum distance as infinity
    pair<Point, Point> closest_pair;

    for (int i = start; i < end; i++) // For each point in the vector
    {
        for (int j = i + 1; j < end; j++) // For each point after the current point
        {
            double dist = distance(points[i], points[j]); // Calculate the distance between the two points
            if (dist < min_dist)
            { // If the distance is less than the minimum distance
                min_dist = dist;
                closest_pair = {points[i], points[j]}; // Update the minimum distance and the closest pair
            }
        }
    }

    return closest_pair; // Return the closest pair
}

// The main objective of the assignment. This is the function to find the closest pair of points recursively using divide and conquer.
pair<Point, Point> closestPair(vector<Point> &points, int start, int end)
{
    // YOUR CODE HERE
    if (end - start <= 3) // If the number of points is less than or equal to 3, use brute force, (base case). I did this because the brute force function would never be called if I didn't add this condition and it is very similar to how I would write the base case for this function. So this makes my function a hybrid algorithm utilizing the greedy approach.
    {
        return bruteForceClosestPair(points, start, end);
    }
    int mid = (start + end) / 2;                                    // Find the middle index
    pair<Point, Point> left_pair = closestPair(points, start, mid); // Find the closest pair in the left half in a recursive manner (divide and conquer)
    pair<Point, Point> right_pair = closestPair(points, mid, end);  // Find the closest pair in the right half in a recursive manner (divide and conquer)

    double left_dist = distance(left_pair.first, left_pair.second);    // Calculate the distance between the closest pair in the left half
    double right_dist = distance(right_pair.first, right_pair.second); // Calculate the distance between the closest pair in the right half

    pair<Point, Point> min_pair;
    double min_dist;
    if (left_dist < right_dist) // Compare the distances of the closest pairs in the left and right halves
    {
        min_pair = left_pair;
        min_dist = left_dist;
    }
    else
    {
        min_pair = right_pair;
        min_dist = right_dist;
    }

    vector<Point> strip;              // Create a strip vector
    for (int i = start; i < end; i++) // Create a strip vector that contains the points that are within the minimum distance from the middle point
    {
        if (abs(points[i].x - points[mid].x) < min_dist) // If the x coordinate of the point is within the minimum distance from the middle point
        {
            strip.push_back(points[i]); // Add the point to the strip vector
        }
    }

    sort(strip.begin(), strip.end(), compareY); // Sort the strip vector according to the y coordinates

    for (size_t i = 0; i < strip.size(); i++) // For each point in the strip vector
    {
        for (size_t j = i + 1; j < strip.size() && (strip[j].y - strip[i].y) < min_dist; j++) // For each point after the current point in the strip vector and the y coordinate difference is less than the minimum distance
        {
            double dist = distance(strip[i], strip[j]); // Calculate the distance between the two points
            if (dist < min_dist)                        // If the distance is less than the minimum distance
            {
                min_dist = dist;                 // Update the minimum distance
                min_pair = {strip[i], strip[j]}; // Update the closest pair
            }
        }
    }

    return min_pair; // Return the closest pair
}

// Function to remove a pair of points from the point vector. Returns the newly formed vector.
vector<Point> removePairFromVector(vector<Point> &point_vector, pair<Point, Point> point_pair)
{
    // YOUR CODE HERE
    vector<Point> new_vector;
    for (const auto &point : point_vector) // for each point in the vector
    {
        if (!(point.x == point_pair.first.x && point.y == point_pair.first.y) && !(point.x == point_pair.second.x && point.y == point_pair.second.y)) // if the point is not equal to the first or the second point of the pair. Thus, removing the pair from the vector.
        {
            new_vector.push_back(point); // add it to the new vector
        }
    }
    return new_vector;
}

// This function should wrap up the entire algorithm. It should:
//    1- Find the closest pair
//    2- Add the pair to the "pairs" vector
//    3- Remove the paired result from the map
// at each iteration.
// Then it should set "unconnected" variable as the final, unconnected city (if it exists).
void findClosestPairOrder(vector<Point> points)
{
    vector<pair<Point, Point>> pairs; // add your pairs to this vector
    Point unconnected = {-1, -1};     // set this as the unconnected point if it exists, leave as is otherwise.

    // YOUR CODE HERE
    sort(points.begin(), points.end(), compareX);                       // sort the points according to their x coordinates, to use in the closestPair function
    pair<Point, Point> closest = closestPair(points, 0, points.size()); // find the closest pair of points

    while (!closest.first.x == 0) // while there are still points to connect
    {
        if (compareY(closest.first, closest.second) || (closest.first.y == closest.second.y && compareX(closest.first, closest.second))) // make sure that the city with the smaller y coordinate is printed first, if the y coordinates are the same, print the city with the smaller x coordinate first.
        {
            pairs.push_back(closest);
        }
        else
        {
            pairs.push_back({closest.second, closest.first});
        }

        points = removePairFromVector(points, closest);  // remove the pair from the vector
        closest = closestPair(points, 0, points.size()); // find the closest pair of points again
    }

    if (points.size() == 1) // if there is an unconnected city
    {
        unconnected = points[0];
    }
    // before printing, please make sure that within each pair, the city with the smaller y coordinate is printed first...
    //...if the y coordinates are the same, print the city with the smaller x coordinate first.

    // This part prints the output, don't modify.
    for (size_t i = 0; i < pairs.size(); i++)
    {
        cout << "Pair " << i + 1 << ": " << pairs[i].first.x << ", " << pairs[i].first.y << " - " << pairs[i].second.x << ", " << pairs[i].second.y << endl;
    }
    if (unconnected.x != -1)
    {
        cout << "Unconnected " << unconnected.x << ", " << unconnected.y;
    }
}

// Read the coordinates from the file and convert them to a vector. Return the vector as a "vector<Point>"
vector<Point> readCoordinatesFromFile(const string &filename)
{
    vector<Point> points;

    // YOUR CODE HERE

    ifstream file(filename);
    if (file.is_open()) // open the file stream
    {
        string line;
        while (getline(file, line)) // get a line of the file while we are not at the EOF
        {
            Point p;                                     // a line has a single point
            sscanf(line.c_str(), "%lf %lf", &p.x, &p.y); // read the line according to the formating from test cases
            points.push_back(p);                         // add it to the vector
        }
        file.close();
    }
    else
    {
        cout << "File could not be opened." << endl;
    }
    return points;
}

// Main function. Ideally, you don't need to modify this.
int main(int argc, char *argv[])
{
    vector<Point> points = readCoordinatesFromFile(argv[1]);
    findClosestPairOrder(points);
    return 0;
}
