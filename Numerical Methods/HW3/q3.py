#Abdullah Jafar Mansour Shamout
#150200919
import numpy as np
import matplotlib.pyplot as plt

def Lagrange_interpolation_method(fx, x, val):
    sum = 0
    iterations = len(x)
    for i in range(iterations):
        expression = fx[i]
        for j in range(iterations):
            if j != i:
                expression *= (val - x[j]) / (x[i] - x[j])
        sum += expression
    return sum



x = [-1.2, 0.3, 1.1]
y = [-5.76, -5.61, -3.69]
range_x = np.linspace(min(x),max(x), 100)
range_y = Lagrange_interpolation_method(y, x, range_x)

x_given_input = float(input("give the value to interpolate at: "))
value = Lagrange_interpolation_method(y, x, x_given_input)
print("value: ", str(round(value,2)))

plt.scatter(x, y, color='green', label='Data Points')
plt.plot(range_x, range_y, label='Interpolated Curve')
plt.xlabel('x')
plt.ylabel('y')
plt.title('Lagrange Interpolation')
plt.legend()
plt.grid(True)
plt.show()
