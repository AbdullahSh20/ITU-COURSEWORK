# Abdullah Jafar Mansour Shamout
# 150200919
# Socket Programming Project

This project is about Socket Programming. In this project, we were supposed to write a client and server application and have them communicate with each other using socket programming. 

## Project Description

The client application will contact to the server application using TCP protocol and upload a text file including student name, student number, course name to the server that file name will be `student_info.txt`. The server will keep this information in a file called `student_info_from_client.txt`. After the connection closed, the client will make a second connection to the server and download the text file that it recieved if the first connection was successful, the file will be called `server_downloaded_student_info.txt`. Then the client will compare the file already existing at the host device and the one downloaded. If they are the same, it will generate a message to the terminal indicating successful transmission of the message. Otherwise, it will generate an error message.

## Project Documents

The project documents will include:

- 3 Source files `file_create.py`, `server.py`, `client.py`
- A video demonstration of the program running <video src="demonstration.mp4" controls title="video demo"></video>
- A document explaining the project together with the outcomes, this `README.md` file :D .

## Results

As it can be seen per the `demonstration.mp4` file, a file that is to be transmitted needs to be created using the `file_create.py` script. Afterwards by starting the `server.py` script, we can start listening to connection requests on port 5000. Then using the `client.py` script, we connect to the server twice with different connections each and exchange data and determine whether there has been packet lossage or corruption. In my demonstration as it can be seen, the data was transmitted and recieved fine, thus I had no errors. In this project I learned about socket programming using a TCP connection, I learned about how to exchange data and verify whether the data has been changed or not.