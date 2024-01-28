##################################################
## Abdullah Jafar Mansour Shamout
## 150200919
##################################################

def question5(a, epsilon):
    # Since "a" can be either positive or negative I need to initialize the intervals of testing accordingly
    #if a >= 0 then the minimum value for a^(1/5) is 0 thus our minimum interval will start at 0 and our maximum will start at "a" since a^(1/5) can be a maximum of "a" when a=1
    if a >= 0:
        min = 0
        max = a
    else:
        min = a
        max = 0

    mid = (min + max) / 2 # Here I am using the bisection method to initialize the mid value
    while abs(a - mid**5) > epsilon: # Here I started a loop that would update min/max values with newly found mid untill we get an error less than epsilon
        if mid ** 5 < a:
            min = mid   # Here if mid^5 is less than the "a" we need that, means that mid is a closer minimum to our "a" value so we update min
        else:
            max = mid   # Here if mid^5 is greater than the "a" we need that, means that mid is a closer maximum to our "a" value so we update max
        mid = (min + max) / 2 # Here we calculate a new min and check it again in the loop
            
    return mid

print("#########Here are some examples##########")

# Some examples as requested in the question
# Example 1
a = 32
epsilon = 0.01
x = question5(a,epsilon)
print(x)

# Example 1 negative case
a = -32
epsilon = 0.01
x = question5(a,epsilon)
print(x)

# Example 2
a = 243
epsilon = 0.001
x = question5(a,epsilon)
print(x)

# Example 2 negative case
a = -243
epsilon = 0.001
x = question5(a,epsilon)
print(x)

print("#########################################")
print("Enter the values you want to test for 'a' and epsilon")
a = input("Enter the value for a: ")
epsilon = input("Enter the value for epsilon: ")
x = question5(float(a),abs(float(epsilon)))
print(x)