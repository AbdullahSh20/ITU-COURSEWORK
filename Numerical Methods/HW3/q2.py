#Abdullah Jafar Mansour Shamout
#150200919

# finding the divided difference table
def populate_table(x, y, n):
    for j in range(1, n):   #0 is taken by the first f(x) values
        for i in range(n - j): #each time we reduce the size by 1 and j is incrementing by 1 thats why n-j makes sense
            y[i][j] = ((y[i][j - 1] - y[i + 1][j - 1]) / (x[i] - x[j + i])) #i refers to row while j refers to column
    return y

# function for displaying divided difference table
def print_table(x, y, n):
    for i in range(n):
        print(x[i],"\t\t", end="")
        for j in range(n - i):
            print(int(y[i][j]),"\t\t", end="")
        print("")

# function used to find the amount of X-Xi in the function used to solve the question
# b1 + b2(x-x1) + b2(x-x1)(x-x2) + b3(x-x1)(x-x2)(x-x3) + b4(x-x1)(x-x2)(x-x3)(x-x4) + b5(x-x1)(x-x2)(x-x3)(x-x4)(x-x5)
def expression(i, val, x):
    repetition = 1
    for j in range(i):
        repetition = repetition * (val - x[j])
    return repetition

# interpolating for the given value
def interpolate(x, y, n, val):
    sum = y[0][0]
    for i in range(1, n):   #add all the full expressions from b1 to b5
        sum = sum + (y[0][i] * expression(i, val, x))
    return sum

n = 5   #No. of inputs
y = [[0 for i in range(5)] for j in range(5)]   #since the code is catered for the data given in the question, going 5*5 is enough
x = [0, 1, 2, 4, 6]

y[0][0] = 1
y[1][0] = 9
y[2][0] = 23
y[3][0] = 93
y[4][0] = 259

y = populate_table(x, y, n)
print("X\t\tf(x)\t\t1st\t\t2nd\t\t3rd\t\t4th")
print_table(x, y, n)
val = 4.2
print("##################################################################")
print("part c: ", end="")
print("the value at "+ str(val)+ " is " + str(round(interpolate(x, y, n, val),3)))