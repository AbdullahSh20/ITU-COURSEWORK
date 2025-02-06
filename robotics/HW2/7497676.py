#!/usr/bin/env python3
# -*- coding: utf-8 -*-
## EB
## waypoint_follower.py
## 
## YZV406E Assignment 2 Skeleton
## 
## Notes to consier: Few helper functions and code snippets are already given to you. Examine the code carefully beforehand.
##
## If you want to make use of the map, use occupancy_grid variable.
##
## 
## STUDENT_ID:<150200919>
import rclpy
from rclpy.node import Node
import sys
from sensor_msgs.msg import LaserScan
from nav_msgs.msg import OccupancyGrid
from nav_msgs.msg import Odometry
from nav_msgs.srv import GetMap
from geometry_msgs.msg import Twist, PoseArray, PoseStamped, Pose
from tf2_ros.transform_listener import TransformListener
from tf2_ros.buffer import Buffer
from tf2_ros import TransformException
import math
import time
"""
HELPER FUNCTIONS
"""
def euler_from_quaternion(x, y, z, w):
        """
        Convert a quaternion into euler angles (roll, pitch, yaw)
        roll is rotation around x in radians (counterclockwise)
        pitch is rotation around y in radians (counterclockwise)
        yaw is rotation around z in radians (counterclockwise)
        """
        # DO NOT CHANGE HERE
        # DO NOT CHANGE HERE
        # DO NOT CHANGE HERE
        # DO NOT CHANGE HERE
        t0 = +2.0 * (w * x + y * z)
        t1 = +1.0 - 2.0 * (x * x + y * y)
        roll_x = math.atan2(t0, t1)
     
        t2 = +2.0 * (w * y - z * x)
        t2 = +1.0 if t2 > +1.0 else t2
        t2 = -1.0 if t2 < -1.0 else t2
        pitch_y = math.asin(t2)
     
        t3 = +2.0 * (w * z + x * y)
        t4 = +1.0 - 2.0 * (y * y + z * z)
        yaw_z = math.atan2(t3, t4)
     
        return roll_x, pitch_y, yaw_z # in radians
        


class Navigator(Node):
    """
    Navigator node to make robot go from location A to B. 
    [IMPORTANT]
    IMPLEMENT YOUR CODES WITHIN THIS CLASS (You can define helper functions outside the class if you want)
    [IMPORTANT]
    """
    def __init__(self):
        super().__init__('waypoint_follower')
        self.subscription_scan = self.create_subscription(
            LaserScan,
            '/scan',
            self.scan_callback,
            10)
        self.subscription_odom = self.create_subscription(
            Odometry,
            '/odom',
            self.odom_callback,
            10)
        self.sub_route1 = self.create_subscription(
            PoseArray,
            '/route1',
            self.set_route1,
            10,
        )# subscribe first route
        self.sub_route2 = self.create_subscription(
            PoseArray,
            '/route2',
            self.set_route2,
            10
        ) # subscribe second route
        self.sub_route3 = self.create_subscription(
            PoseArray,
            '/route3',
            self.set_route3,
            10
        ) # subscribe third route
        self.sub_route4 = self.create_subscription(
            PoseArray,
            '/route4',
            self.set_route4,
            10
        ) # subscribe fourth route
        self.subscription_waypoint = self.create_subscription(
            PoseStamped,
            '/waypoint',
            self.waypoint_callback,
            10) # subscribe next waypoint
        self.publish_twist = self.create_publisher(
            Twist,
            '/cmd_vel',
            10
        )
        self.cli = self.create_client(GetMap, '/map_server/map')
        #/map_server/map
        while not self.cli.wait_for_service(timeout_sec=1.0):
            self.get_logger().info('service not available, waiting again...')
        self.req = GetMap.Request()
        
        ### MAP ###
        self.occupancy_grid = [] # OCCUPANCY GRID MESSAGE VARIABLE. You can also use this knowledge
                                # to handle obstacle.
        self.map_origin = Pose() # origin as a Pose type.
        self.map_width = 0 # width
        self.map_height = 0 # height
        self.map_resolution = 0 # size of each grid cell
        ###     ###
        self.tf_buffer = Buffer() # for transformation
        self.tf_listener = TransformListener(self.tf_buffer, self) # for transformation
        self.goal_dist_thld = 0.2 # max acceptable distance between robot and the goal
        self.angle_err_thld = 0.5-0.5*math.cos(math.pi/4) # max acceptable angle error between robot and the goal
        self.is_route1_set= 0 # 0 or 1, if 1 route1 is acquired by the topic
        self.is_route2_set = 0 # 0 or 1, if 1 route2 is acquired by the topic
        self.is_route3_set = 0 # 0 or 1, if 1 route2 is acquired by the topic
        self.is_route4_set = 0 # 0 or 1, if 1 route2 is acquired by the topic
        self.route1 = PoseArray() # route1
        self.route2 = PoseArray() # route2
        self.route3 = PoseArray() # route3
        self.route4 = PoseArray() # route4
        self.waypoint = PoseStamped() # next wayoint

        self.obstacle_detected = False
        self.obstacle_recovery_state = 0
        self.last_scan = None
        self.prev_distance = 0
        self.rotating = False
        self.chatty_map = False

        self.waiting_points = {}  # Dictionary to store points that require waiting
        self.wait = False
        self.current_waiting_point = None  # Track the current waiting point

        self.prefer_right = None

    def send_request(self):
        self.future = self.cli.call_async(self.req)

    def set_route1(self, msg):
        if (self.is_route1_set == 0):
            self.route1 = msg
            self.is_route1_set = 1
            # Mark the last point as a pickup point
            if len(msg.poses) > 0:
                last_point = (msg.poses[-1].position.x, msg.poses[-1].position.y)
                self.waiting_points[last_point] = True

    def set_route2(self, msg):
        if (self.is_route2_set == 0):
            self.route2 = msg
            self.is_route2_set = 1
            # Mark the last point as a cooking point
            if len(msg.poses) > 0:
                last_point = (msg.poses[-1].position.x, msg.poses[-1].position.y)
                self.waiting_points[last_point] = True
        
    def set_route3(self, msg):
        if (self.is_route3_set == 0):
            self.route3 = msg
            self.is_route3_set = 1
        else:
            pass
        
    def set_route4(self, msg):
        if (self.is_route4_set == 0):
            self.route4 = msg
            self.is_route4_set = 1
        else:
            pass

    def waypoint_callback(self,msg):
        # next waypoint is ready
        self.waypoint = msg

    def is_at_waiting_point(self, current_pos, goal_pos):
        if not self.waiting_points:
            return False
            
        # Check if the goal position is a waiting point
        goal_key = (goal_pos[0], goal_pos[1])
        if goal_key not in self.waiting_points:
            return False
            
        # Check if we're close enough to the waiting point
        distance = math.sqrt((current_pos[0] - goal_pos[0])**2 + 
                           (current_pos[1] - goal_pos[1])**2)
        return distance < self.goal_dist_thld

    def sleep_check(self):
        if(self.wait):
            self.get_logger().info('Doing a task...')
            #I added this part if you care about good practices, but since we werent told that we can add our own imports I am not using it
            #import rospy
            # because using normal time.sleep is not a good practice
            # rate = rospy.Rate(1) # 1 Hz
            # rate.sleep(5) # Sleeps for 1/rate sec
            time.sleep(5)
            self.get_logger().info('Task is done, continuing with the others...')
            self.wait = False

    def pure_pursuit(self, current_x, current_y, current_heading, goal_x, goal_y):
        # Calculate distance to goal
        distance = math.sqrt((goal_x - current_x)**2 + (goal_y - current_y)**2)
        
        # Calculate angle to goal
        angle_to_goal = math.atan2(goal_y - current_y, goal_x - current_x)
        
        # Calculate heading error (difference between current heading and angle to goal)
        heading_error = angle_to_goal - current_heading
        if heading_error > math.pi:
            heading_error -= 2 * math.pi
        elif heading_error < -math.pi:
            heading_error += 2 * math.pi

        alpha = heading_error
        
        # Base speeds
        max_speed = 0.25
        max_angular_speed = 1.0
        
        # Heading alignment phase (when close to goal)
        if distance < 0.3:  # When we're close to the goal
            # Get quaternion orientation of the goal from waypoint
            if hasattr(self.waypoint, 'pose'):
                _, _, goal_yaw = euler_from_quaternion(
                    self.waypoint.pose.orientation.x,
                    self.waypoint.pose.orientation.y,
                    self.waypoint.pose.orientation.z,
                    self.waypoint.pose.orientation.w
                )
                
                # Calculate final heading error
                final_heading_error = goal_yaw - current_heading
                if final_heading_error > math.pi:
                    final_heading_error -= 2 * math.pi
                elif final_heading_error < -math.pi:
                    final_heading_error += 2 * math.pi
                    
                # Blend between path following and final heading alignment
                alpha = 0.7 * final_heading_error + 0.3 * heading_error
                
                # Reduce speed when aligning
                max_speed *= 0.5
        
        # Apply proximity penalties if available
        if hasattr(self, 'front_proximity'):
            proximity_penalty = max(
                self.front_proximity,
                self.front_left_proximity * 0.6,
                self.front_right_proximity * 0.6,
                self.side_left_proximity * 0.4,
                self.side_right_proximity * 0.4
            )
            max_speed *= (1 - proximity_penalty * 0.8)
        
        # Progressive speed reduction as we get closer to goal
        if distance < 0.5:
            max_speed *= (distance / 0.5)
        
        # Calculate velocities
        # Linear velocity reduces with larger heading errors
        linear_vel = max_speed * math.cos(alpha)
        linear_vel = max(0.05, min(linear_vel, max_speed))
        
        # Angular velocity using the original calculation but with improved scaling
        angular_vel = max_angular_speed * (alpha / math.pi)
        
        # Scale angular velocity based on distance to improve turning behavior
        if distance > 0.5:
            # Stronger turns when farther from goal
            angular_vel *= 1.2
        else:
            # More precise turns when closer to goal
            angular_vel *= 0.8
        
        # Additional rotation adjustments for obstacle avoidance
        if hasattr(self, 'front_proximity'):
            if self.wall_on_left:
                angular_vel = min(angular_vel + (0.6 * self.side_left_proximity), max_angular_speed)
            elif self.wall_on_right:
                angular_vel = max(angular_vel - (0.6 * self.side_right_proximity), -max_angular_speed)
                
            # Enhanced obstacle avoidance in turns
            if abs(angular_vel) > 0.3:  # If we're turning significantly
                if self.front_proximity > 0.3:  # If obstacle is detected in front
                    linear_vel *= 0.6  # Reduce speed in turns with obstacles
        
        # Ensure minimum forward velocity for testing
        if linear_vel < 0.1:
            linear_vel = 0.1875
        
        # When very close to goal and aligning heading, prioritize rotation
        if distance < 0.4 and abs(alpha) > 0.1:
            linear_vel *= 0.5
            angular_vel *= 1.5
        
        return linear_vel, angular_vel
    
    def navigate_to_goal(self, robotX_tf, robotY_tf, robot_yaw):
        """
        Main navigation function using pure pursuit
        """
        self.get_logger().info("Starting navigation to goal")
        
        if not hasattr(self.waypoint, 'pose'):
            self.get_logger().warning("No waypoint available for navigation")
            return Twist()
            
        goal_x = self.waypoint.pose.position.x
        goal_y = self.waypoint.pose.position.y
        self.get_logger().info(f"Goal position: ({goal_x}, {goal_y})")
        
        current_pos = (robotX_tf, robotY_tf)
        goal_pos = (goal_x, goal_y)
        
        if self.is_at_waiting_point(current_pos, goal_pos):
            if self.current_waiting_point != goal_pos:
                self.current_waiting_point = goal_pos
                self.wait = True
                self.get_logger().info(f"Arrived at waiting point: {goal_pos}")
            velocity_vec = Twist()
            velocity_vec.linear.x = 0.0
            velocity_vec.angular.z = 0.0
            return velocity_vec

        self.current_waiting_point = None
        self.wait = False

        linear_vel, angular_vel = self.pure_pursuit(robotX_tf, robotY_tf, robot_yaw, goal_x, goal_y)
        
        if hasattr(self, 'obstacle_front'):
            if self.obstacle_front:
                self.get_logger().warning("Obstacle detected in front")
                linear_vel = 0.2
                angular_vel = 0.8 if self.prefer_right else -0.8
            
            elif self.wall_on_left or self.wall_on_right:
                self.get_logger().warning("Following wall")
                linear_vel *= 0.8
                
                if self.wall_on_left:
                    angular_vel = min(angular_vel + 0.3, 1.0)
                elif self.wall_on_right:
                    angular_vel = max(angular_vel - 0.3, -1.0)
            
            elif self.obstacle_side_left:
                self.get_logger().warning("Obstacle on left side")
                linear_vel *= 0.8
                angular_vel = min(angular_vel + 0.5, 1.0)
            elif self.obstacle_side_right:
                self.get_logger().warning("Obstacle on right side")
                linear_vel *= 0.8
                angular_vel = max(angular_vel - 0.5, -1.0)
            
            if self.obstacle_front or self.obstacle_side_left or self.obstacle_side_right:
                linear_vel = min(linear_vel, 0.2)
                self.get_logger().debug("Reduced speed near obstacles")

        velocity_vec = Twist()
        velocity_vec.linear.x = linear_vel
        velocity_vec.angular.z = angular_vel
        
        self.get_logger().info(f"Velocity command: Linear={linear_vel}, Angular={angular_vel}")
        
        return velocity_vec
    
    def scan_callback(self, msg):

        self.last_scan = msg
            
        front_center = msg.ranges[0:15] + msg.ranges[-15:]  # Wider front arc
        front_left = msg.ranges[-60:-15]    # Wider left front sector
        front_right = msg.ranges[15:60]     # Wider right front sector
        side_left = msg.ranges[-90:-60]     # Left side
        side_right = msg.ranges[60:90]      # Right side
        
        extended_left = msg.ranges[-135:-90]  # Extended left sector
        extended_right = msg.ranges[90:135]   # Extended right sector


        VERY_CLOSE = 0.3
        CLOSE = 0.5
        SAFE = 0.7
        
        # Calculate proximity factors (0 to 1, where 1 is maximum proximity)
        def get_proximity_factor(distances, threshold):
            min_dist = min([x for x in distances if x > msg.range_min])
            if min_dist > threshold:
                return 0.0
            return min(1.0, (threshold - min_dist) / threshold)
            
        self.front_proximity = get_proximity_factor(front_center, SAFE)
        self.front_left_proximity = get_proximity_factor(front_left, SAFE)
        self.front_right_proximity = get_proximity_factor(front_right, SAFE)
        self.side_left_proximity = get_proximity_factor(side_left, SAFE)
        self.side_right_proximity = get_proximity_factor(side_right, SAFE)

        # Get minimum distances in different sectors
        self.obstacle_front = min([x for x in front_center if x > msg.range_min]) < CLOSE
        self.obstacle_side_left = min([x for x in side_left if x > msg.range_min]) < VERY_CLOSE
        self.obstacle_side_right = min([x for x in side_right if x > msg.range_min]) < VERY_CLOSE
        
        # Update obstacle detection states
            
        self.wall_on_left = (min([x for x in side_left if x > msg.range_min]) < SAFE and 
                            min([x for x in extended_left if x > msg.range_min]) < SAFE)
        self.wall_on_right = (min([x for x in side_right if x > msg.range_min]) < SAFE and 
                            min([x for x in extended_right if x > msg.range_min]) < SAFE)
        
        left_space = (sum(front_left) / len(front_left)) * (1 - self.front_left_proximity)
        right_space = (sum(front_right) / len(front_right)) * (1 - self.front_right_proximity)
        
        # Add wall penalties 
        if self.wall_on_left:
            left_space *= 0.15
        if self.wall_on_right:
            right_space *= 0.15
        
        # Calculate preferred avoidance direction
        self.prefer_right = right_space > left_space
     
    def odom_callback(self, msg):
        global robotX # global keyword makes the variable accessable even outside the function!
        global robotY # global keyword makes the variable accessable even outside the function!
        global robotX_tf # global keyword makes the variable accessable even outside the function!
        global robotY_tf # global keyword makes the variable accessable even outside the function!
        global robot_yaw # global keyword makes the variable accessable even outside the function!
        
        robotX = msg.pose.pose.position.x
        robotY = msg.pose.pose.position.y
        
        to_frame_rel = "map"
        from_frame_rel = "base_footprint"
        try:
            # grab the latest available transform from the odometry frame 
            # (robot's original location - usually the same as the map unless the odometry becomes inaccurate) to the robot's base.
            t = self.tf_buffer.lookup_transform(
                to_frame_rel,
                from_frame_rel,
                rclpy.time.Time())
        except TransformException as ex:
            self.get_logger().info(
                f'Could not transform {to_frame_rel} to {from_frame_rel}: {ex}')
            return

        # Convert the quaternion-based orientation of the latest message to Euler representation in order to get z axis rotation
        _,_,robot_orient_z = euler_from_quaternion(t.transform.rotation.x,t.transform.rotation.y,t.transform.rotation.z,t.transform.rotation.w)
        robotX_tf = t.transform.translation.x
        robotY_tf = t.transform.translation.y
        robot_yaw = robot_orient_z # # only need the z axis, degree of orientation, between pi and -pi
        self.get_logger().info('X:'+str(robotX_tf),throttle_duration_sec=0.5) # once at a half of a second
        self.get_logger().info('Y:'+str(robotY_tf),throttle_duration_sec=0.5) # once at a half of a second
        self.get_logger().info('Yaw:'+str(robot_yaw),throttle_duration_sec=0.5) # once at a half of a second

        # TURTLEBOT: I HAVE NO CLUE, WHICH INFORMATION SHOULD I DEPEND FOR INTELLIGENT WAYPOINT FOLLOWING? HELP ME MY FELLOW ENGINEER! 
        # TURTLEBOT: I HAVE NO CLUE, WHICH INFORMATION SHOULD I DEPEND FOR INTELLIGENT WAYPOINT FOLLOWING? HELP ME MY FELLOW ENGINEER! 
        # Twist is a type of ROS Message that enables us to send velocity commands to the robot
        velocity_vec = self.navigate_to_goal(robotX_tf, robotY_tf, robot_yaw)
        self.publish_twist.publish(velocity_vec) # publish twist message through cmd_vel topic
        self.sleep_check()
        if (self.chatty_map):
            # you may set chatty_map to true if you want to see map on the terminal
            # map is only acquired for once and does not change since then.
            self.get_logger().info(str(self.occupancy_grid))
            self.get_logger().info("Length of the map array:" + str(len(self.occupancy_grid)))
            self.get_logger().info("Height:" + str(self.map_height) + " Width:"+ str(self.map_height))
            self.get_logger().info("Origin of the map (Cell 0,0):" + str(self.map_origin))
            self.get_logger().info("Resolution (Size of each grid cell):" + str(self.map_resolution))

            self.chatty_map = False # avoid repetitive printing.
        

        
def main(args=None):
    # DO NOT CHANGE HERE
    # DO NOT CHANGE HERE
    # DO NOT CHANGE HERE
    # DO NOT CHANGE HERE
    rclpy.init(args=args)

    navigator_node = Navigator()
    navigator_node.send_request() # send request to map server
    get_response=False
    while rclpy.ok():
        rclpy.spin_once(navigator_node) 
        if (navigator_node.future.done() & (not get_response)):
            # if future job is accomplished (GetMap) and not accomplished before
            navigator_node.get_logger().info("map is acquired")
            try:
                response = navigator_node.future.result() # get map response
                get_response = True # raise the response flag
                navigator_node.occupancy_grid= response.map.data # get the occupancy grid array
                navigator_node.map_height= response.map.info.height # get the occupancy grid array
                navigator_node.map_width= response.map.info.width # get the occupancy grid array
                navigator_node.map_origin= response.map.info.origin # get the occupancy grid array
                navigator_node.map_resolution= response.map.info.resolution # get the occupancy grid array
                navigator_node.get_logger().info(str(navigator_node.map_height))
                
            except Exception as e:
                navigator_node.get_logger().info(e) # raise an error if response could not be acquired.
                get_response = False # lower the flag


    # Destroy the node explicitly
    # (optional - otherwise it will be done automatically
    # when the garbage collector destroys the node object)
    navigator_node.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()