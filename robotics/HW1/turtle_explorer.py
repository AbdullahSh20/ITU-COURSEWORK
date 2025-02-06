#!/usr/bin/env python3
## EB
## motion.py
## 
## YZV406E Assignment 1 Skeleton
##
## Instructions: Implement the necessary functions to make the robot navigate around the world. 
## The robot should navigate around the world without colliding with obstacles.
## Your aim is to explore the world as most as the robot can.
## The robot should be able to enter the rooms and exit the rooms by sensing the environment.
## You may add helper functions to make code seem more clean. As long as you keep the main() function as it is, you can add as many functions as you want,
## and modify existing ones.
## 
## Notes to consier: Few helper functions and code snippets are already given to you. Examine the code carefully beforehand.
## You can also examine the explored area with mapping_callback function. You can utilize the received map data, it might be helpful for your solution.
##
##  STUDENT_ID:<150200919>
### DO NOT EDIT THESE LIBRARIES ###

import rclpy
from rclpy.node import Node
import sys
import math
import numpy as np
import heapq
import random
import yaml
import scipy.interpolate as si
import time
import threading

from geometry_msgs.msg import Twist
from sensor_msgs.msg import LaserScan
from nav_msgs.msg import OccupancyGrid, Odometry
from tf2_ros.buffer import Buffer
from tf2_ros.transform_listener import TransformListener
from tf2_ros import TransformException

########################################
# UTILITY FUNCTIONS
########################################

def euler_from_quaternion(x, y, z, w):
    """
    Convert quaternion (x, y, z, w) into euler yaw angle (in radians).
    """
    t0 = +2.0 * (w * x + y * z)
    t1 = +1.0 - 2.0 * (x * x + y * y)
    roll_x = math.atan2(t0, t1)
 
    t2 = +2.0 * (w * y - z * x)
    t2 = max(-1.0, min(1.0, t2))
    pitch_y = math.asin(t2)
 
    t3 = +2.0 * (w * z + x * y)
    t4 = +1.0 - 2.0 * (y * y + z * z)
    yaw_z = math.atan2(t3, t4)
 
    # Return only yaw
    return yaw_z

def heuristic(a, b):
    """
    Euclidean distance as heuristic for A*
    """
    return math.sqrt((b[0] - a[0])*2 + (b[1] - a[1])*2)

def astar(array, start, goal):
    """
    A* for grid-based pathfinding
    array: 2D array, 1 = obstacle, 0 = free
    start: (row, col)
    goal: (row, col)
    """
    neighbors = [(0,1),(0,-1),(1,0),(-1,0),(1,1),(1,-1),(-1,1),(-1,-1)]
    close_set = set()
    came_from = {}
    gscore = {start:0}
    fscore = {start:heuristic(start, goal)}
    oheap = []
    
    heapq.heappush(oheap, (fscore[start], start))
    
    while oheap:
        current = heapq.heappop(oheap)[1]
        
        if current == goal:
            # Reconstruct path
            data = []
            while current in came_from:
                data.append(current)
                current = came_from[current]
            data.append(start)
            data.reverse()
            return data
        
        close_set.add(current)
        
        for i, j in neighbors:
            neighbor = (current[0]+i, current[1]+j)
            tentative_gscore = gscore[current] + heuristic(current, neighbor)
            # boundary checks
            if not (0 <= neighbor[0] < array.shape[0] and 0 <= neighbor[1] < array.shape[1]):
                continue
            if array[neighbor[0]][neighbor[1]] == 1:
                # obstacle
                continue
            
            if neighbor in close_set and tentative_gscore >= gscore.get(neighbor, 0):
                continue
            
            if (tentative_gscore < gscore.get(neighbor, float('inf'))) or (neighbor not in [i[1] for i in oheap]):
                came_from[neighbor] = current
                gscore[neighbor] = tentative_gscore
                fscore[neighbor] = tentative_gscore + heuristic(neighbor, goal)
                heapq.heappush(oheap, (fscore[neighbor], neighbor))
    
    # If no path found, return partial path to the node closest to goal
    if goal not in came_from:
        closest_node = None
        closest_dist = float('inf')
        for node in close_set:
            dist = heuristic(node, goal)
            if dist < closest_dist:
                closest_node = node
                closest_dist = dist
        if closest_node is not None:
            data = []
            while closest_node in came_from:
                data.append(closest_node)
                closest_node = came_from[closest_node]
            data.append(start)
            data.reverse()
            return data
    return None

def bspline_planning(path, sn=200):
    """
    Given a discrete path, use B-spline to smooth it.
    sn: number of interpolated points
    """
    if path is None or len(path) < 3:
        return path
    
    try:
        array = np.array(path)
        x = array[:, 0]
        y = array[:, 1]
        
        # We do a param in [0..N-1]
        t = range(len(x))
        # cubic or quadratic (k=2)
        N = 2
        x_tup = si.splrep(t, x, k=N)
        y_tup = si.splrep(t, y, k=N)
        
        ipl_t = np.linspace(0.0, len(x) - 1, sn)
        rx = si.splev(ipl_t, x_tup)
        ry = si.splev(ipl_t, y_tup)
        path_smooth = [(rx[i], ry[i]) for i in range(len(rx))]
        return path_smooth
    except:
        return path

def pure_pursuit(current_x, current_y, current_yaw, path, index, lookahead_distance, max_steering_angle, speed):
    """
    Pure pursuit logic for path following.
    """
    if not path:
        return 0.0, 0.0, index
    
    # if path is complete or near the end
    if index >= len(path)-1:
        return 0.0, 0.0, len(path)-1
    
    v = speed
    closest_point = None
    
    for i in range(index, len(path)):
        px, py = path[i]
        dist = math.hypot(px - current_x, py - current_y)
        if dist > lookahead_distance:
            closest_point = (px, py)
            index = i
            break
    
    # if no lookahead point found, use the last path point
    if closest_point is None:
        closest_point = path[-1]
        index = len(path)-1
    
    # compute heading
    target_heading = math.atan2(closest_point[1] - current_y, closest_point[0] - current_x)
    desired_steering_angle = target_heading - current_yaw
    
    # wrap angle to [-pi, pi]
    if desired_steering_angle > math.pi:
        desired_steering_angle -= 2*math.pi
    elif desired_steering_angle < -math.pi:
        desired_steering_angle += 2*math.pi
    
    # limit steering angle
    if abs(desired_steering_angle) > max_steering_angle:
        sign = 1 if desired_steering_angle > 0 else -1
        desired_steering_angle = sign * max_steering_angle
        v = speed * 0.5  # slow down on tight turns
    
    return v, desired_steering_angle, index

def path_length(path):
    """
    Compute total length of the path
    """
    if not path or len(path) < 2:
        return 0.0
    dist = 0.0
    for i in range(len(path)-1):
        dist += math.hypot(path[i+1][0]-path[i][0], path[i+1][1]-path[i][1])
    return dist

def costmap(data, width, height, expansion_size, resolution):
    """
    Expand obstacles to safe margin. 
    data is a 1D array, shape => (height,width).
    100 => obstacle
    Expand obstacles by 'expansion_size' cells in 2D grid
    """
    arr = np.array(data, dtype=np.int8).reshape(height, width)
    # Mark known obstacles
    wall = np.where(arr == 100)
    for dx in range(-expansion_size, expansion_size+1):
        for dy in range(-expansion_size, expansion_size+1):
            x = wall[0] + dx
            y = wall[1] + dy
            # clip within bounds
            x = np.clip(x, 0, height-1)
            y = np.clip(y, 0, width-1)
            arr[x, y] = 100
    
    # Convert into cost grid: 
    # 0 => free, 1 => obstacle
    arr = np.where(arr == 100, 1, 0)
    return arr

def frontier_detection(matrix):
    """
    Mark frontier cells in the matrix (cells next to unknown).
    unknown < 0
    free == 0
    """
    h, w = matrix.shape
    for i in range(h):
        for j in range(w):
            if matrix[i][j] == 0:  # free
                # check neighbors for unknown
                # direct or diagonal neighbors
                neighbors = [
                    (i-1, j), (i+1, j), (i, j-1), (i, j+1),
                    (i-1, j-1), (i-1, j+1), (i+1, j-1), (i+1, j+1)
                ]
                for nx, ny in neighbors:
                    if 0 <= nx < h and 0 <= ny < w:
                        if matrix[nx][ny] < 0:  # unknown
                            matrix[i][j] = 2  # frontier
                            break
    return matrix

def dfs(matrix, i, j, group, groups):
    if i < 0 or i >= matrix.shape[0] or j < 0 or j >= matrix.shape[1]:
        return group
    if matrix[i][j] != 2:
        return group
    
    if group not in groups:
        groups[group] = []
    groups[group].append((i, j))
    
    matrix[i][j] = 0  # mark visited
    
    # 8 directions DFS
    for di, dj in [(1,0),(-1,0),(0,1),(0,-1),(1,1),(1,-1),(-1,1),(-1,-1)]:
        ni, nj = i+di, j+dj
        group = dfs(matrix, ni, nj, group, groups)
    
    return group

def assign_groups(matrix):
    """
    Identify clusters of frontier cells. 
    Each cluster becomes a distinct group.
    """
    groups = {}
    group_id = 1
    h, w = matrix.shape
    for i in range(h):
        for j in range(w):
            if matrix[i][j] == 2:
                group_id = dfs(matrix, i, j, group_id, groups)
                group_id += 1
    return groups

def fGroups(groups):
    """
    Sort frontier groups by size (descending).
    Return the top few groups with at least 3 cells.
    """
    sorted_groups = sorted(groups.items(), key=lambda x: len(x[1]), reverse=True)
    top_groups = [g for g in sorted_groups if len(g[1]) >= 3]
    return top_groups

def calculate_centroid(group_cells):
    """
    Compute the integer centroid of a cluster of points
    group_cells: list of (row, col) indices
    Return (row_centroid, col_centroid)
    """
    xs = [c[0] for c in group_cells]
    ys = [c[1] for c in group_cells]
    mean_x = sum(xs)/len(xs)
    mean_y = sum(ys)/len(ys)
    return (int(mean_x), int(mean_y))

def find_best_frontier(matrix, groups, current, resolution, originX, originY, target_error, expansion_size):
    """
    Choose the best frontier cluster among 'groups' that is far enough from current pose.
    Return a path (list of (x,y) in world coords).
    Scoring: group_size / path_distance
    """
    if len(groups) == 0:
        return None
    
    best_score = -1.0
    best_path = None
    
    row_c, col_c = current
    
    for group_id, group_cells in groups:
        centroid_rc = calculate_centroid(group_cells)
        # A* path
        path_grid = astar(matrix, (row_c, col_c), centroid_rc)
        if not path_grid or len(path_grid) < 2:
            continue
        
        # Convert from grid coords (row,col) to world coords (x, y)
        path_world = [(pt[1]*resolution + originX, pt[0]*resolution + originY) for pt in path_grid]
        dist = path_length(path_world)
        score = len(group_cells) / (dist+1e-6)  # avoid division by zero
        
        # We also check if the frontier is not too close (less than some threshold)
        if dist < target_error*2:
            # skip frontiers that are too close
            continue
        
        if score > best_score:
            best_score = score
            best_path = path_world
    
    # fallback: if all frontiers are too close, pick a random group
    if best_path is None:
        idx = random.randint(0, len(groups)-1)
        _, group_cells = groups[idx]
        random_cell = random.choice(group_cells)
        path_grid = astar(matrix, (row_c, col_c), random_cell)
        if not path_grid or len(path_grid) < 2:
            return None
        best_path = [(pt[1]*resolution + originX, pt[0]*resolution + originY) for pt in path_grid]
    
    # Smooth the path
    if best_path:
        best_path = bspline_planning(best_path, len(best_path)*5)
    return best_path

########################################
# EXPLORATION NODE
########################################

class TurtleExplorer(Node):
    """
    Combines global frontier-based exploration with local obstacle avoidance + pure pursuit.
    """
    def __init__(self):
        super().__init__('turtle_explorer')
        
        # Load parameters from YAML
        with open("src/a1/a1/params.yaml", 'r') as f:
            params = yaml.load(f, Loader=yaml.FullLoader)
        self.lookahead_distance = params["lookahead_distance"]
        self.speed = params["speed"]
        self.expansion_size = params["expansion_size"]
        self.target_error = params["target_error"]
        self.robot_r = params["robot_r"]
        self.max_steering_angle = math.pi / 4  # limit the turn angle
        
        # Robot dimension and safety
        self.robot_radius = 0.3
        self.safety_distance = 0.35

        # Enhanced safety parameters
        self.robot_radius = 0.3
        self.critical_distance = 0.5  # Distance for emergency stop/turn
        self.safe_distance = 0.8     # Distance to start avoiding
        self.max_linear_speed = 0.3  # Maximum forward speed
        self.min_linear_speed = 0.05 # Minimum forward speed
        self.max_angular_speed = 1.0 # Maximum turning speed
        
        # Subscribers
        self.sub_scan = self.create_subscription(LaserScan, '/scan', self.scan_callback, 10)
        self.sub_map = self.create_subscription(OccupancyGrid, '/map', self.map_callback, 10)
        self.sub_odom = self.create_subscription(Odometry, '/odom', self.odom_callback, 10)
        
        # Publisher
        self.pub_twist = self.create_publisher(Twist, '/cmd_vel', 10)
        
        # TF Buffer
        self.tf_buffer = Buffer()
        self.tf_listener = TransformListener(self.tf_buffer, self)
        
        # State Variables
        self.robotX_tf = math.nan
        self.robotY_tf = math.nan
        self.robot_yaw = math.nan
        self.odom_counter = 0
        
        self.current_path = None
        self.current_path_index = 0
        self.exploration_active = True
        
        # Start exploration in a separate thread
        self.map_data = None
        self.exp_thread = threading.Thread(target=self.exploration_loop)
        self.exp_thread.daemon = True
        self.exp_thread.start()
        
        self.get_logger().info("[INFO] TurtleExplorer node launched.")

    def get_sector_distances(self, ranges, angle_min, angle_increment):
        """
        Divide laser scan into sectors and get minimum distances
        """
        if not ranges:
            return float('inf'), float('inf'), float('inf')
        
        num_ranges = len(ranges)
        # Define sectors (in degrees)
        front_angle = 60  # ±30 degrees
        side_angle = 90   # ±45 degrees
        
        # Convert angles to indices
        front_indices = int(front_angle * math.pi / (180 * angle_increment))
        side_indices = int(side_angle * math.pi / (180 * angle_increment))
        
        # Get minimum distances in each sector
        front_ranges = ranges[:front_indices] + ranges[-front_indices:]
        left_ranges = ranges[num_ranges//4-side_indices:num_ranges//4+side_indices]
        right_ranges = ranges[-num_ranges//4-side_indices:-num_ranges//4+side_indices]
        
        # Filter out invalid readings
        front_ranges = [r for r in front_ranges if r > 0.1]
        left_ranges = [r for r in left_ranges if r > 0.1]
        right_ranges = [r for r in right_ranges if r > 0.1]
        
        front_min = min(front_ranges) if front_ranges else float('inf')
        left_min = min(left_ranges) if left_ranges else float('inf')
        right_min = min(right_ranges) if right_ranges else float('inf')
        
        return front_min, left_min, right_min

    def compute_avoidance_velocities(self, front_dist, left_dist, right_dist):
        """
        Compute smooth velocity commands for obstacle avoidance
        """
        linear_vel = self.max_linear_speed
        angular_vel = 0.0
        
        # Scale down speed based on front distance
        if front_dist < self.critical_distance:
            linear_vel = 0.0
        elif front_dist < self.safe_distance:
            # Smoothly reduce speed as we get closer to obstacles
            linear_vel = self.max_linear_speed * (front_dist - self.critical_distance) / (self.safe_distance - self.critical_distance)
            linear_vel = max(self.min_linear_speed, linear_vel)
        
        # Compute turning direction and magnitude
        if front_dist < self.safe_distance:
            # Turn towards the side with more space
            turn_direction = 1.0 if left_dist > right_dist else -1.0
            # Scale turning speed based on how close we are to obstacles
            turn_magnitude = (self.safe_distance - front_dist) / self.safe_distance
            angular_vel = turn_direction * self.max_angular_speed * turn_magnitude
        else:
            # If no immediate front obstacle, still avoid side obstacles
            if left_dist < self.safe_distance:
                angular_vel = -self.max_angular_speed * (self.safe_distance - left_dist) / self.safe_distance
            elif right_dist < self.safe_distance:
                angular_vel = self.max_angular_speed * (self.safe_distance - right_dist) / self.safe_distance
        
        return linear_vel, angular_vel
    
    def scan_callback(self, msg: LaserScan):
        """
        Enhanced obstacle avoidance & path following
        """
        if math.isnan(self.robotX_tf):
            return
        
        # Get minimum distances in different sectors
        front_dist, left_dist, right_dist = self.get_sector_distances(
            msg.ranges, msg.angle_min, msg.angle_increment)
        
        if self.exploration_active is False and self.current_path is not None:
            # Path following mode
            linear_vel, angular_vel, self.current_path_index = pure_pursuit(
                self.robotX_tf, 
                self.robotY_tf, 
                self.robot_yaw, 
                self.current_path, 
                self.current_path_index, 
                self.lookahead_distance, 
                self.max_steering_angle, 
                self.speed
            )
            
            # Check if we need to override with obstacle avoidance
            if front_dist < self.safe_distance or left_dist < self.safe_distance or right_dist < self.safe_distance:
                avoid_linear, avoid_angular = self.compute_avoidance_velocities(front_dist, left_dist, right_dist)
                # Blend between path following and obstacle avoidance
                blend_factor = min(1.0, (self.safe_distance - front_dist) / (self.safe_distance - self.critical_distance))
                linear_vel = (1 - blend_factor) * linear_vel + blend_factor * avoid_linear
                angular_vel = (1 - blend_factor) * angular_vel + blend_factor * avoid_angular
            
            # Check if we reached the goal
            if self.current_path_index >= len(self.current_path)-1:
                dist_to_goal = math.hypot(
                    self.current_path[-1][0] - self.robotX_tf, 
                    self.current_path[-1][1] - self.robotY_tf
                )
                if dist_to_goal < self.target_error:
                    self.get_logger().info("[INFO] Reached current frontier goal.")
                    self.exploration_active = True
                    linear_vel = 0.0
                    angular_vel = 0.0
        
        else:
            # Pure exploration mode - use obstacle avoidance
            linear_vel, angular_vel = self.compute_avoidance_velocities(front_dist, left_dist, right_dist)
        
        # Publish velocity commands
        twist = Twist()
        twist.linear.x = linear_vel
        twist.angular.z = angular_vel
        self.pub_twist.publish(twist)
    
    def map_callback(self, msg: OccupancyGrid):
        """
        Cache map data for frontier exploration
        """
        self.map_data = msg
    
    def odom_callback(self, msg: Odometry):
        """
        Use TF or Odometry to update robot pose
        """
        to_frame_rel = "odom"
        from_frame_rel = "base_footprint"
        try:
            t = self.tf_buffer.lookup_transform(
                to_frame_rel,
                from_frame_rel,
                rclpy.time.Time())
        except TransformException as ex:
            # fallback to direct odom pose
            self.robotX_tf = msg.pose.pose.position.x
            self.robotY_tf = msg.pose.pose.position.y
            self.robot_yaw = euler_from_quaternion(
                msg.pose.pose.orientation.x,
                msg.pose.pose.orientation.y,
                msg.pose.pose.orientation.z,
                msg.pose.pose.orientation.w
            )
            return
        
        # Convert orientation
        self.robotX_tf = t.transform.translation.x
        self.robotY_tf = t.transform.translation.y
        self.robot_yaw = euler_from_quaternion(
            t.transform.rotation.x,
            t.transform.rotation.y,
            t.transform.rotation.z,
            t.transform.rotation.w
        )
        
        self.odom_counter += 1
    
    def exploration_loop(self):
        """
        Continuously run frontier exploration in a background thread.
        Once a path is found, switch to local navigation until the goal is reached.
        Then trigger exploration again.
        """
        while rclpy.ok():
            if self.exploration_active and self.map_data is not None and not math.isnan(self.robotX_tf):
                # Build costmap
                width = self.map_data.info.width
                height = self.map_data.info.height
                resolution = self.map_data.info.resolution
                originX = self.map_data.info.origin.position.x
                originY = self.map_data.info.origin.position.y
                
                # Expand obstacles
                arr = costmap(
                    self.map_data.data, 
                    width, 
                    height, 
                    self.expansion_size, 
                    resolution
                )
                
                # Mark unknown cells as -1
                #   original map data: -1 => unknown
                #   we keep them as -1 so that frontier detection can be done
                raw_map = np.array(self.map_data.data, dtype=np.int16).reshape(height, width)
                for i in range(height):
                    for j in range(width):
                        if raw_map[i][j] < 0:  # unknown
                            # keep it as negative so frontier detection can see it
                            if arr[i][j] == 0:
                                arr[i][j] = -1  # override if free
                
                # Frontier detection
                arr = frontier_detection(arr)
                groups = assign_groups(arr)
                groups = fGroups(groups)
                
                # Current robot grid coords
                row_c = int((self.robotY_tf - originY)/resolution)
                col_c = int((self.robotX_tf - originX)/resolution)
                
                path_world = find_best_frontier(arr, groups, (row_c, col_c), resolution, originX, originY, self.target_error, self.expansion_size)
                
                if path_world is None:
                    self.get_logger().info("[INFO] Exploration complete or no frontier found.")
                    # Stop robot
                    twist = Twist()
                    self.pub_twist.publish(twist)
                    sys.exit(0)
                
                self.current_path = path_world
                self.current_path_index = 0
                self.exploration_active = False
                self.get_logger().info("[INFO] Found new frontier path. Switching to navigation.")
            
            time.sleep(0.2)  # adjust loop rate as needed

def main(args=None):
    rclpy.init(args=args)
    node = TurtleExplorer()
    rclpy.spin(node)
    
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()