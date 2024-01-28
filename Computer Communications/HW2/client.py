#Abdullah Jafar Mansour Shamout
#150200919
#code for client to send and receive file from server. Also to compare the two files and give the result
import socket
import filecmp

server_ip = '192.168.1.5'     #I am using my own ip address currently as the server
server_port = 5000              #random not used port number for server

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_address = (server_ip, server_port)
server_socket.connect(server_address)                               #connection 1 to send file
file_name = "student_info.txt"
with open(file_name, 'r') as file:
    file_data = file.read().encode()
server_socket.sendall(file_data)
print(f"Uploaded file: {file_name}")
server_socket.close()

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.connect(server_address)                               #connection 2 to receive file
downloaded_data = server_socket.recv(1024)
downloaded_file_name = "server_downloaded_student_info.txt"
with open(downloaded_file_name, 'w') as file:
    file.write(downloaded_data.decode())
print(f"Downloaded file: {downloaded_file_name}")
server_socket.close()

#comparing the two files and giving the result as a print statement
if filecmp.cmp(file_name, downloaded_file_name):
    print("Successful transmission and reception of file, no corruption or loss of data")
else:
    print("Error: Files are not identical. Something went wrong during transmission/reception")
