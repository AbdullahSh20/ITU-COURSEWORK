#abdullah jafar mansour shamout
#150200919

import matplotlib.pyplot as plt
import numpy as np

x = np.array([0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10])
y = np.array([0.72, 1.63, 1.88, 3.39, 4.02, 3.89, 4.25, 3.99, 4.68, 5.03, 5.27, 4.82, 5.67, 5.95, 5.72, 6.01, 5.50, 6.41, 5.83, 6.33])

y1 = 1.923 + 0.5*x
y2 = -0.0686*x**2 + 1.22*x + 0.603
y3 = 1.78 + 1.945*np.log(x)

plt.plot(x, y, 'o', label='points')
plt.plot(x, y1, label='L(x)')
plt.plot(x, y2, label='P(x)')
plt.plot(x, y3, label='f(x)')

plt.title('Plot of Points and Lines')
plt.xlabel('x')
plt.ylabel('y')
plt.legend()
plt.show()
