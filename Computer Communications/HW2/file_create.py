#Abdullah Jafar Mansour Shamout
#150200919
#code to create text file to be sent to server

student_info = """
Student Name: Abdullah Jafar Mansour Shamout
Student Number: 150200919
Course Name: Principles of Computer Communications
"""

file_name = "student_info.txt"

with open(file_name, 'w') as file:
    file.write(student_info)

print(f"Created file: {file_name}")
