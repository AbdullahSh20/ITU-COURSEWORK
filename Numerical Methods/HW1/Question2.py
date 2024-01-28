##################################################
## Abdullah Jafar Mansour Shamout
## 150200919
##################################################

# since nothing was mentioned about the standard to represent the numbers in, for -ve numbers I will just take them with their absoulute value as input
# and in the output I will put a -ve sign, I can also use a bit to represent it but i didnt want their to be confusion so i will just add the sign

def question2(x):
    # Here I am extracting the integer part of the rational number x by casting it to an int and truncating the decimal values
    whole_part = abs(int(x))

    # Here I extract the fractional part
    fractional_part = abs(x) - whole_part
    
    # Here I convert the integer part to its binary representation by using a loop
    # First I start with an empty string
    Bwhole_part = ''
    # I check for if the whole part is 0
    if whole_part == 0:
        Bwhole_part = '0'
    while whole_part > 0:   # Here I go through a loop while the whole part is not 0
        Bwhole_part = str(whole_part % 2) + Bwhole_part     # I use modulus 2 to get the remainder, convert it to a string and concatenate it to the left of the string
        whole_part //= 2    # Here I floor divide the number since I dont need the remainder as I calculated it
    
    # Here I convert the fractional part to its binary representation
    # First I start with an empty string
    Bfractional_part = ''
    if fractional_part == 0:
        Bfractional_part = '0'
    while fractional_part > 0.000001:  # Just like the method used in class I am multiplying by 2 and taking the whole number part for my binary representation while its not 0.000001 because it may run forever for certain values
        fractional_part *= 2
        int_part = int(fractional_part)
        Bfractional_part += str(int_part) # Here I am concatinating the result I got to my representation
        fractional_part -= int_part # Here I remove the integer part from the fractional part to continue with the calculation
    
    # Here I combine both parts to get my full representation
    binary = Bwhole_part + '.' + Bfractional_part

    # Here I add a -ve sign to the representation if the number is -ve
    if x < 0:
        binary = '-' + binary
    
    return binary   #finally I return the binary representation

# Some examples as requested in the question
# Example 1

print("#########Here are some examples##########")

x = 12.125
binary = question2(x)
print(binary)

# Example 2
x = 0.25
binary = question2(x)
print(binary)

# Example 3
x = 32.625
binary = question2(x)
print(binary)

# Example 4
x = 2.1
binary = question2(x)
print(binary)

# Example 5
x = -12.125
binary = question2(x)
print(binary)

print("#########################################")
x = float(input("Enter the value of the rational number you want to test for in decimal format: "))
binary = question2(x)
print(binary)