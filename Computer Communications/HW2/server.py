#Abdullah Jafar Mansour Shamout
#150200919
#code for server to receive and send file to client.
#server should be on first before client
import socket

server_ip = '161.9.121.123'     #I am using my own ip address currently as the server
server_port = 5000              #random not used port number for server

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_address = (server_ip, server_port)
server_socket.bind(server_address)
server_socket.listen(1)
print(f"Server is listening for incoming connections at port {server_port}")    #starting the server

client_socket, client_address = server_socket.accept()                  #accepting connection 1 from client to download file
print(f"Incoming connection from {client_address}")
file_data = client_socket.recv(1024)
file_name = "student_info_from_client.txt"
with open(file_name, 'w') as file:
    file.write(file_data.decode())
print(f"Received file: {file_name}")
client_socket.close()

client_socket, client_address = server_socket.accept()                #accepting connection 2 from client to upload file
print(f"Incoming connection from {client_address}")
with open(file_name, 'r') as file:
    file_data = file.read().encode()
client_socket.sendall(file_data)
print("File sent to the client")
client_socket.close()
