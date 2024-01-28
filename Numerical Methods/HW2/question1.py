#abdullah jafar mansour shamout
#150200919

import math
import numpy as np

#defining the functions given in the question

def f(x):
    return 4 * math.log(x) - x

def fprime(x):
    return 4 / x - 1

#I created a list of lists where I had my first list of values based on x0 and I would append every other iteration I calculate using the previous list values using the formula for the newton method
def newton_method(x0, max_iter):
    iters = [[x0, f(x0), fprime(x0)]]
    for i in range(max_iter):
        x = iters[-1][0] - iters[-1][1] / iters[-1][2]
        iters.append([x, f(x), fprime(x)])
    return iters

#I created a list of lists where I had my first two lists of values based on x0 and x1 and I would append every other iteration I calculate using the previous two list values using the formula for the secant method
#The first row wouldnt be able to calculate the fprime so they would have N/A value
def secant_method(x0, x1, max_iter):
    iters = [[x0, f(x0), "N/A"], [x1, f(x1), (f(x1) - f(x0))/(x1 - x0)]]
    for i in range(max_iter):
        x = iters[-1][0] - iters[-1][1] * (iters[-1][0] - iters[-2][0]) / (iters[-1][1] - iters[-2][1])
        iters.append([x, f(x), (f(x) - iters[-1][1]) / (x - iters[-1][0])])
    return iters

#for my estimate error function I compared the calculated iteration at i starting from 0 till my last iteration with my last iteration since I dont know the root R and the last iteration is as close as i go to it in this code
def estimate_error(iters):
    errors = []
    for i in range(len(iters) - 1):
        errors.append(abs(iters[i][0] - iters[-1][0]))
    return errors
#for my convergence rate function I used an equation that I found on the internet since this topic was not discussed in class, I faced some errors when developing it and I dealt with them by printing nan
def convergence_rate(iters):
    rates = []
    for i in range(1, len(iters) - 1):
        try:
            numerator = math.log(abs((iters[i + 1][0] - iters[-1][0]) / (iters[i][0] - iters[-1][0])))
            denominator = math.log(abs((iters[i][0] - iters[-1][0]) / (iters[i-1][0] - iters[-1][0])))
            rates.append(numerator/denominator)
        except (ZeroDivisionError, ValueError):
            rates.append(np.nan)
    return rates


#taking input from the user
x0 = float(input("please enter x0: "))
x1 = float(input("please enter x1: "))
max_iter = int(input("please enter max number of iterations: "))

#my calls
newton_iters = newton_method(x0, max_iter)
secant_iters = secant_method(x0, x1, max_iter)

#in both printing formats I checked if they are on the first iteration printing as for the first stage the |xn − xn−1| error expression cant be calculated due to the lack of a previous value
#my printing format for newton
print("\nNewton method iterates:\n")
print("|{:^15}|{:^15}|{:^15}|{:^15}|".format("Xn", "F(Xn)", "F'(Xn)", "|Xn-Xn-1|"))
for i in range(len(newton_iters)):
    if i > 0 :
        print("|{:^15.10f}|{:^15.10f}|{:^15.10f}|{:^15.10f}|".format(newton_iters[i][0], newton_iters[i][1], newton_iters[i][2], abs(newton_iters[i][0] - newton_iters[i-1][0])))
    else :
        print("|{:^15.10f}|{:^15.10f}|{:^15.10f}|{:^15}|".format(newton_iters[i][0], newton_iters[i][1], newton_iters[i][2], "N/A"))
print("Newton method errors:", estimate_error(newton_iters))
print("Newton method convergence rates:", convergence_rate(newton_iters))

#printing a separation line
print("\n\n#########################################################################################################################")
print("#########################################################################################################################")
print("#########################################################################################################################\n\n")

#my printing format for secant
print("Secant method iterates:\n")
print("|{:^15}|{:^15}|{:^15}|{:^15}|".format("Xn", "F(Xn)", "F'(Xn)", "|Xn-Xn-1|"))
for i in range(len(secant_iters)):
    if i > 0 :
        print("|{:^15.10f}|{:^15.10f}|{:^15.10f}|{:^15.10f}|".format(secant_iters[i][0], secant_iters[i][1], secant_iters[i][2], abs(secant_iters[i][0] - secant_iters[i-1][0])))
    else :
        print("|{:^15.10f}|{:^15.10f}|{:^15}|{:^15}|".format(secant_iters[i][0], secant_iters[i][1], secant_iters[i][2], "N/A"))
print("Secant method errors:", estimate_error(secant_iters))
print("Secant method convergence rates:", convergence_rate(secant_iters))