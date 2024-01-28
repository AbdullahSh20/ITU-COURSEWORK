# Abdullah Jafar Manosur Shamout
# 150200919
# HW3

import tkinter as tk
from tkinter import ttk
from PIL import Image, ImageTk

class SimulatorApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Reliable Transport Protocol Simulator")
        self.simulation_scenario = tk.StringVar(value="normal")

        self.create_widgets()

        self.image_paths = {
            #general pictures
            "rdt_send": "RDT_model/rdt_send.png",
            "udt_send": "RDT_model/udt_send.png",
            "rdt_rcv": "RDT_model/rdt_rcv.png",
            "deliver_data": "RDT_model/deliver_data.png",
            
            #rdt1.0 pictures
            "rdt1.0_send_FSM": "rdt1.0/FSM/rdt_send.png",
            "udt1.0_send_FSM": "rdt1.0/FSM/udt_send.png",
            "rdt1.0_rcv_FSM": "rdt1.0/FSM/rdt_rcv.png",
            "deliver1.0_data_FSM": "rdt1.0/FSM/deliver_data.png",

            "rdt1.0_send_FSM": "rdt1.0/FSM/rdt_send.png",
            "udt1.0_send_FSM": "rdt1.0/FSM/udt_send.png",
            "rdt1.0_rcv_FSM": "rdt1.0/FSM/rdt_rcv.png",
            "deliver1.0_data_FSM": "rdt1.0/FSM/deliver_data.png",

            "rdt1.0_send_OSD": "rdt1.0/OSD/send.png",
            "rdt1.0_default_OSD": "rdt1.0/OSD/default.png",

            #rdt2.0 pictures
            #normal case
            "rdt2.0_send_FSM": "rdt2.0/FSM/rdt_send.png",
            "udt2.0_send_FSM": "rdt2.0/FSM/udt_send.png",
            "rdt2.0_rcv_FSM": "rdt2.0/FSM/rdt_rcv_nocorr.png",
            "deliver2.0_data_FSM": "rdt2.0/FSM/deliver_ack.png",
            "rdt2.0_ack_FSM": "rdt2.0/FSM/rdt_rcv_ack.png",

            "rdt2.0_send_OSD": "rdt2.0/OSD/send.png",
            "rdt2.0_recieve_OSD": "rdt2.0/OSD/recieve.png",
            "rdt2.0_ack_OSD": "rdt2.0/OSD/ack.png",
            "rdt2.0_rcvack_OSD": "rdt2.0/OSD/rcvack.png",
            "rdt2.0_default_OSD": "rdt2.0/OSD/default.png",

            #lost case
            "rdt2.0_rcvcorr_FSM": "rdt2.0/FSM/rdt_rcv_corr.png",
            "udt2.0_sendNAK_FSM": "rdt2.0/FSM/not_ack.png",
            "rdt2.0_rcv_NAK": "rdt2.0/FSM/rdt_rcv_NAK.png",
            "udt2.0_send2_FSM": "rdt2.0/FSM/udt_send2.png",

            "rdt2.0_recievecor_OSD": "rdt2.0/OSD/rcvcorrupt.png",
            "rdt2.0_nack_OSD": "rdt2.0/OSD/nack.png",
            "rdt2.0_rcv_NAK_OSD": "rdt2.0/OSD/rcvnack0.png",
            "rdt2.0_send2_OSD": "rdt2.0/OSD/send2.png",

            #rdt3.0 pictures
            #normal case
            #OSD
            "rdt3.0_send_OSD": "rdt3.0/normal/OSD/rdt_send.png",
            "rdt3.0_recieve_OSD": "rdt3.0/normal/OSD/rdt_recieve.png",
            "rdt3.0_ack_OSD": "rdt3.0/normal/OSD/ack.png",
            "rdt3.0_rcvack_OSD": "rdt3.0/normal/OSD/rcvack.png",
            "rdt3.0_default_OSD": "rdt3.0/normal/OSD/default.png",

            #FSM
            "rdt3.0_send_FSM": "rdt3.0/normal/FSM/rdt_send.png",
            "udt3.0_send_FSM": "rdt3.0/normal/FSM/udt_send.png",
            "rdt3.0_rcv_FSM": "rdt3.0/normal/FSM/rdt_recieve.png",
            "rdt3.0_ack_FSM": "rdt3.0/normal/FSM/ack.png",
            "rdt3.0_rcvack_FSM": "rdt3.0/normal/FSM/rcvack.png",

            #lost ack case
            #OSD
            "rdt3.0lack_send_OSD": "rdt3.0/lostack/OSD/send.png",
            "rdt3.0lack_recieve_OSD": "rdt3.0/lostack/OSD/recieve.png",
            "rdt3.0lack_ack_OSD": "rdt3.0/lostack/OSD/ack.png",
            "rdt3.0lack_timeout_OSD": "rdt3.0/lostack/OSD/timeout.png",
            "rdt3.0lack_resend_OSD": "rdt3.0/lostack/OSD/resend.png",

            #FSM
            "rdt3.0lack_send_FSM": "rdt3.0/lostack/FSM/rdt_send.png",
            "udt3.0lack_send_FSM": "rdt3.0/lostack/FSM/udt_send.png",
            "rdt3.0lack_recieve_FSM": "rdt3.0/lostack/FSM/rdt_rcv.png",
            "rdt3.0lack_ack_FSM": "rdt3.0/lostack/FSM/ack.png",
            "rdt3.0lack_timeout_FSM": "rdt3.0/lostack/FSM/timeout.png",
            "rdt3.0lack_resend_FSM": "rdt3.0/lostack/FSM/udt_send2.png",

            #timeout case
            #OSD
            "rdt3.0timeout_send_OSD": "rdt3.0/timeout/OSD/send.png",
            "rdt3.0timeout_recieve_OSD": "rdt3.0/timeout/OSD/recieve.png",
            "rdt3.0timeout_ack_OSD": "rdt3.0/timeout/OSD/ack.png",
            "rdt3.0timeout_timeout_OSD": "rdt3.0/timeout/OSD/timeout.png",
            "rdt3.0timeout_duplicateack_OSD": "rdt3.0/timeout/OSD/duplicateack.png",

            #FSM
            "rdt3.0timeout_send_FSM": "rdt3.0/timeout/FSM/send.png",
            "udt3.0timeout_send_FSM": "rdt3.0/timeout/FSM/send_udt.png",
            "rdt3.0timeout_recieve_FSM": "rdt3.0/timeout/FSM/recieve.png",
            "rdt3.0timeout_ack_FSM": "rdt3.0/timeout/FSM/ack.png",
            "rdt3.0timeout_timeout_FSM": "rdt3.0/timeout/FSM/timeout.png",
            "rdt3.0timeout_duplicateack_FSM": "rdt3.0/timeout/FSM/ack2.png",
            "rdt3.0timeout_resend_FSM": "rdt3.0/timeout/FSM/sendagain.png",
            "rdt3.0timeout_recieve2_FSM": "rdt3.0/timeout/FSM/recieve2.png",

            #packet loss case
            #OSD
            "rdt3.0packetloss_send_OSD": "rdt3.0/packetloss/OSD/send.png",
            "rdt3.0packetloss_timeout_OSD": "rdt3.0/packetloss/OSD/timeout.png",
            "rdt3.0packetloss_resend_OSD": "rdt3.0/packetloss/OSD/resend.png",
            "rdt3.0packetloss_recieve_OSD": "rdt3.0/packetloss/OSD/recieve.png",
            "rdt3.0packetloss_ack_OSD": "rdt3.0/packetloss/OSD/ack.png",
            "rdt3.0packetloss_ackack_OSD": "rdt3.0/packetloss/OSD/ackack.png",

            #FSM
            "rdt3.0packetloss_send_FSM": "rdt3.0/packetloss/FSM/send.png",
            "udt3.0packetloss_send_FSM": "rdt3.0/packetloss/FSM/sendudt.png",
            "rdt3.0packetloss_timeout_FSM": "rdt3.0/packetloss/FSM/timeout.png",
            "rdt3.0packetloss_resend_FSM": "rdt3.0/packetloss/FSM/resend.png",
            "rdt3.0packetloss_recieve_FSM": "rdt3.0/packetloss/FSM/recieve.png",
            "rdt3.0packetloss_ack_FSM": "rdt3.0/packetloss/FSM/ack.png",
            "rdt3.0packetloss_ackack_FSM": "rdt3.0/packetloss/FSM/ackack.png",
        }
        
    def create_widgets(self):
        ttk.Label(self.root, text="Reliable Data Transfer Service Model", font=("Helvetica", 14, "bold"), foreground="blue").grid(row=0, column=0, columnspan=2)
        self.rdt_model_canvas = tk.Canvas(self.root, bg="white", height=200)
        self.rdt_model_canvas.grid(row=1, column=0, columnspan=2, sticky="nsew")


        ttk.Label(self.root, text="State Diagram Actions/Events", font=("Helvetica", 14, "bold"), foreground="blue").grid(row=0, column=2, columnspan=2)
        self.state_diagram_canvas = tk.Canvas(self.root, bg="white", height=200)
        self.state_diagram_canvas.grid(row=1, column=2, columnspan=2, sticky="nsew")


        ttk.Label(self.root, text="Operation Sequence Diagram", font=("Helvetica", 14, "bold"), foreground="blue").grid(row=2, column=0, columnspan=2)
        self.operation_sequence_canvas = tk.Canvas(self.root, bg="white", height=200)
        self.operation_sequence_canvas.grid(row=3, column=0, columnspan=2, sticky="nsew")


        ttk.Label(self.root, text="Command Prompt", font=("Helvetica", 14, "bold"), foreground="blue").grid(row=2, column=2, columnspan=2)
        self.command_prompt_text = tk.Text(self.root, width=40, height=10, font=("Helvetica", 16))
        self.command_prompt_text.grid(row=3, column=2, columnspan=2, sticky="nsew")
        
        
        ttk.Label(self.root, text="Simulation Scenarios", font=("Helvetica", 14, "bold"), foreground="blue").grid(row=4, column=0, columnspan=4)

        style = ttk.Style()
        style.configure("TRadiobutton", font=("Helvetica", 14), padding=(20, 5))

        ttk.Radiobutton(self.root, text="Normal", variable=self.simulation_scenario, value="normal", style="TRadiobutton").grid(row=5, column=0)
        ttk.Radiobutton(self.root, text="Lost ACK", variable=self.simulation_scenario, value="lost_ack", style="TRadiobutton").grid(row=5, column=1)
        ttk.Radiobutton(self.root, text="Lost packet", variable=self.simulation_scenario, value="lost packet", style="TRadiobutton").grid(row=5, column=2)
        ttk.Radiobutton(self.root, text="premature timeout", variable=self.simulation_scenario, value="timeout", style="TRadiobutton").grid(row=5, column=3)

        simulate_button_style = ttk.Style()
        simulate_button_style.configure(
            "Simulate.TButton",
            font=("Helvetica", 16),
            padding=(10, 5)
        )

        ttk.Button(self.root, text="Simulate rdt1.0", command=self.simulate_rdt1, style="Simulate.TButton").grid(row=6, column=0)
        ttk.Button(self.root, text="Simulate rdt2.0", command=self.simulate_rdt2, style="Simulate.TButton").grid(row=6, column=1)
        ttk.Button(self.root, text="Simulate rdt3.0", command=self.simulate_rdt3, style="Simulate.TButton").grid(row=6, column=2)
        ttk.Button(self.root, text="Simulate TCP", command=self.simulate_tcp, style="Simulate.TButton").grid(row=6, column=3)

        for i in range(4):
            self.root.columnconfigure(i, weight=1)
            self.root.rowconfigure(i, weight=1)

    def show_image(self, image_path, canvas):
        canvas_width = canvas.winfo_width()
        canvas_height = canvas.winfo_height()
        img = Image.open(image_path)
        img = img.resize((canvas_width, canvas_height), Image.LANCZOS)
        img_tk = ImageTk.PhotoImage(img)
        canvas.create_image(0, 0, anchor=tk.NW, image=img_tk)
        canvas.image = img_tk

    def simulate_rdt1(self):
        self.clear_canvas()
        selected_scenario = self.simulation_scenario.get()
        self.display_message(f"Simulating rdt1.0 case {selected_scenario}...")

        rdt_send_path = self.image_paths["rdt_send"]
        udt_send_path = self.image_paths["udt_send"]
        rdt_rcv_path = self.image_paths["rdt_rcv"]
        deliver_data_path = self.image_paths["deliver_data"]

        rdt1_fsm_path = self.image_paths["rdt1.0_send_FSM"]
        udt1_fsm_path = self.image_paths["udt1.0_send_FSM"]
        rdt1_rcv_fsm_path = self.image_paths["rdt1.0_rcv_FSM"]
        deliver1_data_fsm_path = self.image_paths["deliver1.0_data_FSM"]

        rdt1_osd_path = self.image_paths["rdt1.0_send_OSD"]
        rdt1_osd_default_path = self.image_paths["rdt1.0_default_OSD"]

        self.root.after(0, lambda: self.show_image(rdt_send_path, self.rdt_model_canvas))
        self.root.after(0, lambda: self.show_image(rdt1_fsm_path, self.state_diagram_canvas))
        self.root.after(0, lambda: self.show_image(rdt1_osd_default_path, self.operation_sequence_canvas))
        self.root.after(0, lambda: self.display_message("rdt_send('Hello world')"))
        
        self.root.after(2500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
        self.root.after(2500, lambda: self.show_image(udt1_fsm_path, self.state_diagram_canvas))
        self.root.after(2500, lambda: self.show_image(rdt1_osd_path, self.operation_sequence_canvas))
        self.root.after(2500, lambda: self.display_message("udt_send('Hello world')"))
        
        self.root.after(5000, lambda: self.show_image(rdt_rcv_path, self.rdt_model_canvas))
        self.root.after(5000, lambda: self.show_image(rdt1_rcv_fsm_path, self.state_diagram_canvas))
        self.root.after(5000, lambda: self.show_image(rdt1_osd_default_path, self.operation_sequence_canvas))
        self.root.after(5000, lambda: self.display_message("rdt_rcv('Hello world')"))

        self.root.after(7500, lambda: self.show_image(deliver_data_path, self.rdt_model_canvas))
        self.root.after(7500, lambda: self.show_image(deliver1_data_fsm_path, self.state_diagram_canvas))
        self.root.after(7500, lambda: self.display_message("deliver_data('Hello world')"))

        self.root.after(10000, lambda: self.display_message("Simulation for rdt1.0 completed."))

    def simulate_rdt2(self):
        self.clear_canvas()
        selected_scenario = self.simulation_scenario.get()
        self.display_message(f"Simulating rdt2.0 case {selected_scenario}...")

        
        rdt_send_path = self.image_paths["rdt_send"]
        udt_send_path = self.image_paths["udt_send"]
        rdt_rcv_path = self.image_paths["rdt_rcv"]
        deliver_data_path = self.image_paths["deliver_data"]

        #normal case pictures
        rdt2_fsm_path = self.image_paths["rdt2.0_send_FSM"]
        udt2_fsm_path = self.image_paths["udt2.0_send_FSM"]
        rdt2_rcv_fsm_path = self.image_paths["rdt2.0_rcv_FSM"]
        deliver2_data_fsm_path = self.image_paths["deliver2.0_data_FSM"]
        rdt2_ack_fsm_path = self.image_paths["rdt2.0_ack_FSM"]

        rdt2_osd_path = self.image_paths["rdt2.0_send_OSD"]
        rdt2_recieve_osd_path = self.image_paths["rdt2.0_recieve_OSD"]
        rdt2_ack_osd_path = self.image_paths["rdt2.0_ack_OSD"]
        rdt2_rcvack_osd_path = self.image_paths["rdt2.0_rcvack_OSD"]
        rdt2_osd_default_path = self.image_paths["rdt2.0_default_OSD"]

        #lost case pictures
        rdt2_fsm_path = self.image_paths["rdt2.0_send_FSM"]
        udt2_fsm_path = self.image_paths["udt2.0_send_FSM"]
        rdt2_rcvcorr_fsm_path = self.image_paths["rdt2.0_rcvcorr_FSM"]
        udt2_sendNAK_fsm_path = self.image_paths["udt2.0_sendNAK_FSM"]
        rdt2_rcv_NAK_fsm_path = self.image_paths["rdt2.0_rcv_NAK"]
        udt2_send2_fsm_path = self.image_paths["udt2.0_send2_FSM"]

        rdt2_osd_path = self.image_paths["rdt2.0_send_OSD"]
        rdt2_recievecor_osd_path = self.image_paths["rdt2.0_recievecor_OSD"]
        rdt2_nack_osd_path = self.image_paths["rdt2.0_nack_OSD"]
        rdt2_rcv_NAK_osd_path = self.image_paths["rdt2.0_rcv_NAK_OSD"]
        rdt2_send2_osd_path = self.image_paths["rdt2.0_send2_OSD"]
        
        if selected_scenario == "normal" or selected_scenario == "lost_ack" or selected_scenario == "timeout":
            self.root.after(0, lambda: self.show_image(rdt_send_path, self.rdt_model_canvas))
            self.root.after(0, lambda: self.show_image(rdt2_fsm_path, self.state_diagram_canvas))
            self.root.after(0, lambda: self.show_image(rdt2_osd_default_path, self.operation_sequence_canvas))
            self.root.after(0, lambda: self.display_message("rdt_send('Hello world')"))
            
            self.root.after(2500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(2500, lambda: self.show_image(udt2_fsm_path, self.state_diagram_canvas))
            self.root.after(2500, lambda: self.show_image(rdt2_osd_path, self.operation_sequence_canvas))
            self.root.after(2500, lambda: self.display_message("udt_send('Hello world')"))
            
            self.root.after(5000, lambda: self.show_image(rdt_rcv_path, self.rdt_model_canvas))
            self.root.after(5000, lambda: self.show_image(rdt2_rcv_fsm_path, self.state_diagram_canvas))
            self.root.after(5000, lambda: self.show_image(rdt2_recieve_osd_path, self.operation_sequence_canvas))
            self.root.after(5000, lambda: self.display_message("rdt_rcv('Hello world')"))

            self.root.after(7500, lambda: self.show_image(deliver_data_path, self.rdt_model_canvas))
            self.root.after(7500, lambda: self.show_image(deliver2_data_fsm_path, self.state_diagram_canvas))
            self.root.after(7500, lambda: self.show_image(rdt2_ack_osd_path, self.operation_sequence_canvas))
            self.root.after(7500, lambda: self.display_message("deliver_data('Hello world')"))
            self.root.after(7500, lambda: self.display_message("udt_send('ACK')"))

            self.root.after(10000, lambda: self.show_image(rdt2_rcvack_osd_path, self.operation_sequence_canvas))
            self.root.after(10000, lambda: self.show_image(rdt2_ack_fsm_path, self.state_diagram_canvas))
            self.root.after(10000, lambda: self.display_message("rdt_rcv('ACK')"))
            self.root.after(10000, lambda: self.display_message("Simulation for rdt1.0 completed."))
        
        elif selected_scenario == "lost packet":

            self.root.after(0, lambda: self.show_image(rdt_send_path, self.rdt_model_canvas))
            self.root.after(0, lambda: self.show_image(rdt2_fsm_path, self.state_diagram_canvas))
            self.root.after(0, lambda: self.show_image(rdt2_osd_default_path, self.operation_sequence_canvas))
            self.root.after(0, lambda: self.display_message("rdt_send('Hello world')"))

            self.root.after(2500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(2500, lambda: self.show_image(udt2_fsm_path, self.state_diagram_canvas))
            self.root.after(2500, lambda: self.show_image(rdt2_osd_path, self.operation_sequence_canvas))
            self.root.after(2500, lambda: self.display_message("udt_send('Hello world')"))
            
            self.root.after(5000, lambda: self.show_image(rdt_rcv_path, self.rdt_model_canvas))
            self.root.after(5000, lambda: self.show_image(rdt2_rcvcorr_fsm_path, self.state_diagram_canvas))
            self.root.after(5000, lambda: self.show_image(rdt2_recievecor_osd_path, self.operation_sequence_canvas))
            self.root.after(5000, lambda: self.display_message("rdt_rcv('bye mars')"))

            self.root.after(7500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(7500, lambda: self.show_image(udt2_sendNAK_fsm_path, self.state_diagram_canvas))
            self.root.after(7500, lambda: self.show_image(rdt2_nack_osd_path, self.operation_sequence_canvas))
            self.root.after(7500, lambda: self.display_message("udt_send('NAK')"))

            self.root.after(10000, lambda: self.show_image(rdt_rcv_path, self.rdt_model_canvas))
            self.root.after(10000, lambda: self.show_image(rdt2_rcv_NAK_fsm_path, self.state_diagram_canvas))
            self.root.after(10000, lambda: self.show_image(rdt2_rcv_NAK_osd_path, self.operation_sequence_canvas))
            self.root.after(10000, lambda: self.display_message("rdt_rcv('NAK')"))

            self.root.after(12500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(12500, lambda: self.show_image(udt2_send2_fsm_path, self.state_diagram_canvas))
            self.root.after(12500, lambda: self.show_image(rdt2_send2_osd_path, self.operation_sequence_canvas))
            self.root.after(12500, lambda: self.display_message("udt_send('Hello world')"))

    def simulate_rdt3(self):
        self.clear_canvas()
        selected_scenario = self.simulation_scenario.get()
        self.display_message(f"Simulating rdt3.0 case {selected_scenario}...")

        rdt_send_path = self.image_paths["rdt_send"]
        udt_send_path = self.image_paths["udt_send"]
        rdt_rcv_path = self.image_paths["rdt_rcv"]
        deliver_data_path = self.image_paths["deliver_data"]

        #normal case pictures
        rdt3_fsm_path = self.image_paths["rdt3.0_send_FSM"]
        udt3_fsm_path = self.image_paths["udt3.0_send_FSM"]
        rdt3_rcv_fsm_path = self.image_paths["rdt3.0_rcv_FSM"]
        rdt3_ack_fsm_path = self.image_paths["rdt3.0_ack_FSM"]
        rdt3_rcvack_fsm_path = self.image_paths["rdt3.0_rcvack_FSM"]

        rdt3_osd_path = self.image_paths["rdt3.0_send_OSD"]
        rdt3_recieve_osd_path = self.image_paths["rdt3.0_recieve_OSD"]
        rdt3_ack_osd_path = self.image_paths["rdt3.0_ack_OSD"]
        rdt3_rcvack_osd_path = self.image_paths["rdt3.0_rcvack_OSD"]
        rdt2_osd_default_path = self.image_paths["rdt3.0_default_OSD"]

        if selected_scenario == "normal":
            self.root.after(0, lambda: self.show_image(rdt_send_path, self.rdt_model_canvas))
            self.root.after(0, lambda: self.show_image(rdt3_fsm_path, self.state_diagram_canvas))
            self.root.after(0, lambda: self.show_image(rdt2_osd_default_path, self.operation_sequence_canvas))
            self.root.after(0, lambda: self.display_message("rdt_send('Hello world')"))
            
            self.root.after(2500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(2500, lambda: self.show_image(udt3_fsm_path, self.state_diagram_canvas))
            self.root.after(2500, lambda: self.show_image(rdt3_osd_path, self.operation_sequence_canvas))
            self.root.after(2500, lambda: self.display_message("udt_send('Hello world')"))
            
            self.root.after(5000, lambda: self.show_image(rdt_rcv_path, self.rdt_model_canvas))
            self.root.after(5000, lambda: self.show_image(rdt3_rcv_fsm_path, self.state_diagram_canvas))
            self.root.after(5000, lambda: self.show_image(rdt3_recieve_osd_path, self.operation_sequence_canvas))
            self.root.after(5000, lambda: self.display_message("rdt_rcv('Hello world')"))

            self.root.after(7500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(7500, lambda: self.show_image(rdt3_ack_fsm_path, self.state_diagram_canvas))
            self.root.after(7500, lambda: self.show_image(rdt3_ack_osd_path, self.operation_sequence_canvas))
            self.root.after(7500, lambda: self.display_message("udt_send('ACK')"))

            self.root.after(10000, lambda: self.show_image(rdt3_rcvack_fsm_path, self.state_diagram_canvas))
            self.root.after(10000, lambda: self.show_image(rdt3_rcvack_osd_path, self.operation_sequence_canvas))
            self.root.after(10000, lambda: self.display_message("rdt_rcv('ACK')"))

            
            self.root.after(12500, lambda: self.show_image(deliver_data_path, self.rdt_model_canvas))
            self.root.after(12500, lambda: self.display_message("deliver_data('Hello world')"))

            self.root.after(10000, lambda: self.display_message("Simulation for rdt3.0 completed."))

        elif selected_scenario == "lost_ack":
            #lost ack case pictures
            
            rdt3lack_fsm_path = self.image_paths["rdt3.0lack_send_FSM"]
            udt3lack_fsm_path = self.image_paths["udt3.0lack_send_FSM"]
            rdt3lack_rcv_fsm_path = self.image_paths["rdt3.0lack_recieve_FSM"]
            rdt3lack_ack_fsm_path = self.image_paths["rdt3.0lack_ack_FSM"]
            rdt3lack_timeout_fsm_path = self.image_paths["rdt3.0lack_timeout_FSM"]
            rdt3lack_resend_fsm_path = self.image_paths["rdt3.0lack_resend_FSM"]

            rdt3lack_send_osd_path = self.image_paths["rdt3.0lack_send_OSD"]
            rdt3lack_recieve_osd_path = self.image_paths["rdt3.0lack_recieve_OSD"]
            rdt3lack_ack_osd_path = self.image_paths["rdt3.0lack_ack_OSD"]
            rdt3lack_timeout_osd_path = self.image_paths["rdt3.0lack_timeout_OSD"]
            rdt3lack_resend_osd_path = self.image_paths["rdt3.0lack_resend_OSD"]

            self.root.after(0, lambda: self.show_image(rdt_send_path, self.rdt_model_canvas))
            self.root.after(0, lambda: self.show_image(rdt3lack_fsm_path, self.state_diagram_canvas))
            self.root.after(0, lambda: self.show_image(rdt2_osd_default_path, self.operation_sequence_canvas))
            self.root.after(0, lambda: self.display_message("rdt_send('Hello world')"))
            
            self.root.after(2500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(2500, lambda: self.show_image(udt3lack_fsm_path, self.state_diagram_canvas))
            self.root.after(2500, lambda: self.show_image(rdt3lack_send_osd_path, self.operation_sequence_canvas))
            self.root.after(2500, lambda: self.display_message("udt_send('Hello world')"))
            
            self.root.after(5000, lambda: self.show_image(rdt_rcv_path, self.rdt_model_canvas))
            self.root.after(5000, lambda: self.show_image(rdt3lack_rcv_fsm_path, self.state_diagram_canvas))
            self.root.after(5000, lambda: self.show_image(rdt3lack_recieve_osd_path, self.operation_sequence_canvas))
            self.root.after(5000, lambda: self.display_message("rdt_rcv('Hello world')"))

            self.root.after(7500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(7500, lambda: self.show_image(rdt3lack_ack_fsm_path, self.state_diagram_canvas))
            self.root.after(7500, lambda: self.show_image(rdt3lack_ack_osd_path, self.operation_sequence_canvas))
            self.root.after(7500, lambda: self.display_message("udt_send('ACK')"))

            self.root.after(10000, lambda: self.show_image(rdt3lack_timeout_fsm_path, self.state_diagram_canvas))
            self.root.after(10000, lambda: self.show_image(rdt3lack_timeout_osd_path, self.operation_sequence_canvas))
            self.root.after(10000, lambda: self.display_message("timeout at sender"))

            self.root.after(12500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(12500, lambda: self.show_image(rdt3lack_resend_fsm_path, self.state_diagram_canvas))
            self.root.after(12500, lambda: self.show_image(rdt3lack_resend_osd_path, self.operation_sequence_canvas))
            self.root.after(12500, lambda: self.display_message("udt_send('Hello world')"))

            
            self.root.after(10000, lambda: self.display_message("Simulation for rdt3.0 completed."))

        elif selected_scenario == "timeout":
            #timeout case pictures
            rdt3timeout_fsm_path = self.image_paths["rdt3.0timeout_send_FSM"]
            rdt3timeout_recieve_fsm_path = self.image_paths["rdt3.0timeout_recieve_FSM"]
            rdt3timeout_ack_fsm_path = self.image_paths["rdt3.0timeout_ack_FSM"]
            rdt3timeout_timeout_fsm_path = self.image_paths["rdt3.0timeout_timeout_FSM"]
            rdt3timeout_duplicateack_fsm_path = self.image_paths["rdt3.0timeout_duplicateack_FSM"]
            rdt3timeout_resend_fsm_path = self.image_paths["rdt3.0timeout_resend_FSM"]
            rdt3timeout_recieve2_fsm_path = self.image_paths["rdt3.0timeout_recieve2_FSM"]

            rdt3timeout_send_osd_path = self.image_paths["rdt3.0timeout_send_OSD"]
            rdt3timeout_recieve_osd_path = self.image_paths["rdt3.0timeout_recieve_OSD"]
            rdt3timeout_ack_osd_path = self.image_paths["rdt3.0timeout_ack_OSD"]
            rdt3timeout_timeout_osd_path = self.image_paths["rdt3.0timeout_timeout_OSD"]
            rdt3timeout_duplicateack_osd_path = self.image_paths["rdt3.0timeout_duplicateack_OSD"]

            self.root.after(0, lambda: self.show_image(rdt_send_path, self.rdt_model_canvas))
            self.root.after(0, lambda: self.show_image(rdt3timeout_fsm_path, self.state_diagram_canvas))
            self.root.after(0, lambda: self.show_image(rdt2_osd_default_path, self.operation_sequence_canvas))
            self.root.after(0, lambda: self.display_message("rdt_send('Hello world')"))
            
            self.root.after(2500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(2500, lambda: self.show_image(rdt3timeout_fsm_path, self.state_diagram_canvas))
            self.root.after(2500, lambda: self.show_image(rdt3timeout_send_osd_path, self.operation_sequence_canvas))
            self.root.after(2500, lambda: self.display_message("udt_send('Hello world')"))

            self.root.after(5000, lambda: self.show_image(rdt_rcv_path, self.rdt_model_canvas))
            self.root.after(5000, lambda: self.show_image(rdt3timeout_recieve_fsm_path, self.state_diagram_canvas))
            self.root.after(5000, lambda: self.show_image(rdt3timeout_recieve_osd_path, self.operation_sequence_canvas))
            self.root.after(5000, lambda: self.display_message("rdt_rcv('Hello world')"))

            self.root.after(7500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(7500, lambda: self.show_image(rdt3timeout_ack_fsm_path, self.state_diagram_canvas))
            self.root.after(7500, lambda: self.show_image(rdt3timeout_ack_osd_path, self.operation_sequence_canvas))
            self.root.after(7500, lambda: self.display_message("udt_send('ACK')"))

            self.root.after(10000, lambda: self.show_image(rdt3timeout_timeout_fsm_path, self.state_diagram_canvas))
            self.root.after(10000, lambda: self.show_image(rdt3timeout_timeout_osd_path, self.operation_sequence_canvas))
            self.root.after(10000, lambda: self.display_message("timeout at sender"))
            
            self.root.after(15000, lambda: self.show_image(rdt3timeout_resend_fsm_path, self.state_diagram_canvas))
            self.root.after(15000, lambda: self.show_image(rdt3timeout_timeout_osd_path, self.operation_sequence_canvas))
            self.root.after(15000, lambda: self.display_message("udt_send('Hello world')"))

            self.root.after(12500, lambda: self.show_image(rdt3timeout_duplicateack_fsm_path, self.state_diagram_canvas))
            self.root.after(12500, lambda: self.show_image(rdt3timeout_duplicateack_osd_path, self.operation_sequence_canvas))
            self.root.after(12500, lambda: self.display_message("rdt_rcv('ACK')"))

            self.root.after(17500, lambda: self.show_image(rdt3timeout_recieve2_fsm_path, self.state_diagram_canvas))
            self.root.after(17500, lambda: self.display_message("rdt_rcv('Hello world')"))

            self.root.after(20000, lambda: self.display_message("Simulation for rdt3.0 completed."))

        elif selected_scenario == "lost packet":
            #packet loss case pictures
            rdt3packetloss_fsm_path = self.image_paths["rdt3.0packetloss_send_FSM"]
            udt3packetloss_fsm_path = self.image_paths["udt3.0packetloss_send_FSM"]
            rdt3packetloss_timeout_fsm_path = self.image_paths["rdt3.0packetloss_timeout_FSM"]
            rdt3packetloss_resend_fsm_path = self.image_paths["rdt3.0packetloss_resend_FSM"]
            rdt3packetloss_recieve_fsm_path = self.image_paths["rdt3.0packetloss_recieve_FSM"]
            rdt3packetloss_ack_fsm_path = self.image_paths["rdt3.0packetloss_ack_FSM"]
            rdt3packetloss_ackack_fsm_path = self.image_paths["rdt3.0packetloss_ackack_FSM"]

            rdt3packetloss_send_osd_path = self.image_paths["rdt3.0packetloss_send_OSD"]
            rdt3packetloss_timeout_osd_path = self.image_paths["rdt3.0packetloss_timeout_OSD"]
            rdt3packetloss_resend_osd_path = self.image_paths["rdt3.0packetloss_resend_OSD"]
            rdt3packetloss_recieve_osd_path = self.image_paths["rdt3.0packetloss_recieve_OSD"]
            rdt3packetloss_ack_osd_path = self.image_paths["rdt3.0packetloss_ack_OSD"]
            rdt3packetloss_ackack_osd_path = self.image_paths["rdt3.0packetloss_ackack_OSD"]

            self.root.after(0, lambda: self.show_image(rdt_send_path, self.rdt_model_canvas))
            self.root.after(0, lambda: self.show_image(rdt3packetloss_fsm_path, self.state_diagram_canvas))
            self.root.after(0, lambda: self.show_image(rdt2_osd_default_path, self.operation_sequence_canvas))
            self.root.after(0, lambda: self.display_message("rdt_send('Hello world')"))

            self.root.after(2500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(2500, lambda: self.show_image(udt3packetloss_fsm_path, self.state_diagram_canvas))
            self.root.after(2500, lambda: self.show_image(rdt3packetloss_send_osd_path, self.operation_sequence_canvas))
            self.root.after(2500, lambda: self.display_message("udt_send('Hello world')"))

            
            self.root.after(2500, lambda: self.show_image( rdt3packetloss_timeout_fsm_path, self.state_diagram_canvas))
            self.root.after(2500, lambda: self.show_image(rdt3packetloss_timeout_osd_path, self.operation_sequence_canvas))
            self.root.after(2500, lambda: self.display_message("timeout at sender"))

            self.root.after(5000, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(5000, lambda: self.show_image(rdt3packetloss_resend_fsm_path, self.state_diagram_canvas))
            self.root.after(5000, lambda: self.show_image(rdt3packetloss_resend_osd_path, self.operation_sequence_canvas))
            self.root.after(5000, lambda: self.display_message("udt_send('Hello world')"))

            self.root.after(7500, lambda: self.show_image(rdt_rcv_path, self.rdt_model_canvas))
            self.root.after(7500, lambda: self.show_image(rdt3packetloss_recieve_fsm_path, self.state_diagram_canvas))
            self.root.after(7500, lambda: self.show_image(rdt3packetloss_recieve_osd_path, self.operation_sequence_canvas))
            self.root.after(7500, lambda: self.display_message("rdt_rcv('Hello world')"))

            self.root.after(10000, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(10000, lambda: self.show_image(rdt3packetloss_ack_fsm_path, self.state_diagram_canvas))
            self.root.after(10000, lambda: self.show_image(rdt3packetloss_ack_osd_path, self.operation_sequence_canvas))
            self.root.after(10000, lambda: self.display_message("udt_send('ACK')"))

            self.root.after(12500, lambda: self.show_image(rdt3packetloss_ackack_fsm_path, self.state_diagram_canvas))
            self.root.after(12500, lambda: self.show_image(rdt3packetloss_ackack_osd_path, self.operation_sequence_canvas))
            self.root.after(12500, lambda: self.display_message("rdt_rcv('ACK')"))

            self.root.after(15000, lambda: self.show_image(deliver_data_path, self.rdt_model_canvas))
            self.root.after(15000, lambda: self.display_message("deliver_data('Hello world')"))
            
            self.root.after(17500, lambda: self.display_message("Simulation for rdt3.0 completed."))

    def simulate_tcp(self):
        self.clear_canvas()
        selected_scenario = self.simulation_scenario.get()
        self.display_message(f"Simulating TCP case {selected_scenario}...")

        rdt_send_path = self.image_paths["rdt_send"]
        udt_send_path = self.image_paths["udt_send"]
        rdt_rcv_path = self.image_paths["rdt_rcv"]
        deliver_data_path = self.image_paths["deliver_data"]

        #normal case pictures
        rdt3_fsm_path = self.image_paths["rdt3.0_send_FSM"]
        udt3_fsm_path = self.image_paths["udt3.0_send_FSM"]
        rdt3_rcv_fsm_path = self.image_paths["rdt3.0_rcv_FSM"]
        rdt3_ack_fsm_path = self.image_paths["rdt3.0_ack_FSM"]
        rdt3_rcvack_fsm_path = self.image_paths["rdt3.0_rcvack_FSM"]

        rdt3_osd_path = self.image_paths["rdt3.0_send_OSD"]
        rdt3_recieve_osd_path = self.image_paths["rdt3.0_recieve_OSD"]
        rdt3_ack_osd_path = self.image_paths["rdt3.0_ack_OSD"]
        rdt3_rcvack_osd_path = self.image_paths["rdt3.0_rcvack_OSD"]
        rdt2_osd_default_path = self.image_paths["rdt3.0_default_OSD"]

        if selected_scenario == "normal":
            self.root.after(0, lambda: self.show_image(rdt_send_path, self.rdt_model_canvas))
            self.root.after(0, lambda: self.show_image(rdt3_fsm_path, self.state_diagram_canvas))
            self.root.after(0, lambda: self.show_image(rdt2_osd_default_path, self.operation_sequence_canvas))
            self.root.after(0, lambda: self.display_message("rdt_send('Hello world')"))
            
            self.root.after(2500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(2500, lambda: self.show_image(udt3_fsm_path, self.state_diagram_canvas))
            self.root.after(2500, lambda: self.show_image(rdt3_osd_path, self.operation_sequence_canvas))
            self.root.after(2500, lambda: self.display_message("udt_send('Hello world')"))
            
            self.root.after(5000, lambda: self.show_image(rdt_rcv_path, self.rdt_model_canvas))
            self.root.after(5000, lambda: self.show_image(rdt3_rcv_fsm_path, self.state_diagram_canvas))
            self.root.after(5000, lambda: self.show_image(rdt3_recieve_osd_path, self.operation_sequence_canvas))
            self.root.after(5000, lambda: self.display_message("rdt_rcv('Hello world')"))

            self.root.after(7500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(7500, lambda: self.show_image(rdt3_ack_fsm_path, self.state_diagram_canvas))
            self.root.after(7500, lambda: self.show_image(rdt3_ack_osd_path, self.operation_sequence_canvas))
            self.root.after(7500, lambda: self.display_message("udt_send('ACK')"))

            self.root.after(10000, lambda: self.show_image(rdt3_rcvack_fsm_path, self.state_diagram_canvas))
            self.root.after(10000, lambda: self.show_image(rdt3_rcvack_osd_path, self.operation_sequence_canvas))
            self.root.after(10000, lambda: self.display_message("rdt_rcv('ACK')"))

            
            self.root.after(12500, lambda: self.show_image(deliver_data_path, self.rdt_model_canvas))
            self.root.after(12500, lambda: self.display_message("deliver_data('Hello world')"))

        elif selected_scenario == "lost_ack":
            #lost ack case pictures
            
            rdt3lack_fsm_path = self.image_paths["rdt3.0lack_send_FSM"]
            udt3lack_fsm_path = self.image_paths["udt3.0lack_send_FSM"]
            rdt3lack_rcv_fsm_path = self.image_paths["rdt3.0lack_recieve_FSM"]
            rdt3lack_ack_fsm_path = self.image_paths["rdt3.0lack_ack_FSM"]
            rdt3lack_timeout_fsm_path = self.image_paths["rdt3.0lack_timeout_FSM"]
            rdt3lack_resend_fsm_path = self.image_paths["rdt3.0lack_resend_FSM"]

            rdt3lack_send_osd_path = self.image_paths["rdt3.0lack_send_OSD"]
            rdt3lack_recieve_osd_path = self.image_paths["rdt3.0lack_recieve_OSD"]
            rdt3lack_ack_osd_path = self.image_paths["rdt3.0lack_ack_OSD"]
            rdt3lack_timeout_osd_path = self.image_paths["rdt3.0lack_timeout_OSD"]
            rdt3lack_resend_osd_path = self.image_paths["rdt3.0lack_resend_OSD"]

            self.root.after(0, lambda: self.show_image(rdt_send_path, self.rdt_model_canvas))
            self.root.after(0, lambda: self.show_image(rdt3lack_fsm_path, self.state_diagram_canvas))
            self.root.after(0, lambda: self.show_image(rdt2_osd_default_path, self.operation_sequence_canvas))
            self.root.after(0, lambda: self.display_message("rdt_send('Hello world')"))
            
            self.root.after(2500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(2500, lambda: self.show_image(udt3lack_fsm_path, self.state_diagram_canvas))
            self.root.after(2500, lambda: self.show_image(rdt3lack_send_osd_path, self.operation_sequence_canvas))
            self.root.after(2500, lambda: self.display_message("udt_send('Hello world')"))
            
            self.root.after(5000, lambda: self.show_image(rdt_rcv_path, self.rdt_model_canvas))
            self.root.after(5000, lambda: self.show_image(rdt3lack_rcv_fsm_path, self.state_diagram_canvas))
            self.root.after(5000, lambda: self.show_image(rdt3lack_recieve_osd_path, self.operation_sequence_canvas))
            self.root.after(5000, lambda: self.display_message("rdt_rcv('Hello world')"))

            self.root.after(7500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(7500, lambda: self.show_image(rdt3lack_ack_fsm_path, self.state_diagram_canvas))
            self.root.after(7500, lambda: self.show_image(rdt3lack_ack_osd_path, self.operation_sequence_canvas))
            self.root.after(7500, lambda: self.display_message("udt_send('ACK')"))

            self.root.after(10000, lambda: self.show_image(rdt3lack_timeout_fsm_path, self.state_diagram_canvas))
            self.root.after(10000, lambda: self.show_image(rdt3lack_timeout_osd_path, self.operation_sequence_canvas))
            self.root.after(10000, lambda: self.display_message("timeout at sender"))

            self.root.after(12500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(12500, lambda: self.show_image(rdt3lack_resend_fsm_path, self.state_diagram_canvas))
            self.root.after(12500, lambda: self.show_image(rdt3lack_resend_osd_path, self.operation_sequence_canvas))
            self.root.after(12500, lambda: self.display_message("udt_send('Hello world')"))

        elif selected_scenario == "timeout":
            #timeout case pictures
            rdt3timeout_fsm_path = self.image_paths["rdt3.0timeout_send_FSM"]
            rdt3timeout_recieve_fsm_path = self.image_paths["rdt3.0timeout_recieve_FSM"]
            rdt3timeout_ack_fsm_path = self.image_paths["rdt3.0timeout_ack_FSM"]
            rdt3timeout_timeout_fsm_path = self.image_paths["rdt3.0timeout_timeout_FSM"]
            rdt3timeout_duplicateack_fsm_path = self.image_paths["rdt3.0timeout_duplicateack_FSM"]
            rdt3timeout_resend_fsm_path = self.image_paths["rdt3.0timeout_resend_FSM"]
            rdt3timeout_recieve2_fsm_path = self.image_paths["rdt3.0timeout_recieve2_FSM"]

            rdt3timeout_send_osd_path = self.image_paths["rdt3.0timeout_send_OSD"]
            rdt3timeout_recieve_osd_path = self.image_paths["rdt3.0timeout_recieve_OSD"]
            rdt3timeout_ack_osd_path = self.image_paths["rdt3.0timeout_ack_OSD"]
            rdt3timeout_timeout_osd_path = self.image_paths["rdt3.0timeout_timeout_OSD"]
            rdt3timeout_duplicateack_osd_path = self.image_paths["rdt3.0timeout_duplicateack_OSD"]

            self.root.after(0, lambda: self.show_image(rdt_send_path, self.rdt_model_canvas))
            self.root.after(0, lambda: self.show_image(rdt3timeout_fsm_path, self.state_diagram_canvas))
            self.root.after(0, lambda: self.show_image(rdt2_osd_default_path, self.operation_sequence_canvas))
            self.root.after(0, lambda: self.display_message("rdt_send('Hello world')"))
            
            self.root.after(2500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(2500, lambda: self.show_image(rdt3timeout_fsm_path, self.state_diagram_canvas))
            self.root.after(2500, lambda: self.show_image(rdt3timeout_send_osd_path, self.operation_sequence_canvas))
            self.root.after(2500, lambda: self.display_message("udt_send('Hello world')"))

            self.root.after(5000, lambda: self.show_image(rdt_rcv_path, self.rdt_model_canvas))
            self.root.after(5000, lambda: self.show_image(rdt3timeout_recieve_fsm_path, self.state_diagram_canvas))
            self.root.after(5000, lambda: self.show_image(rdt3timeout_recieve_osd_path, self.operation_sequence_canvas))
            self.root.after(5000, lambda: self.display_message("rdt_rcv('Hello world')"))

            self.root.after(7500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(7500, lambda: self.show_image(rdt3timeout_ack_fsm_path, self.state_diagram_canvas))
            self.root.after(7500, lambda: self.show_image(rdt3timeout_ack_osd_path, self.operation_sequence_canvas))
            self.root.after(7500, lambda: self.display_message("udt_send('ACK')"))

            self.root.after(10000, lambda: self.show_image(rdt3timeout_timeout_fsm_path, self.state_diagram_canvas))
            self.root.after(10000, lambda: self.show_image(rdt3timeout_timeout_osd_path, self.operation_sequence_canvas))
            self.root.after(10000, lambda: self.display_message("timeout at sender"))
            
            self.root.after(15000, lambda: self.show_image(rdt3timeout_resend_fsm_path, self.state_diagram_canvas))
            self.root.after(15000, lambda: self.show_image(rdt3timeout_timeout_osd_path, self.operation_sequence_canvas))
            self.root.after(15000, lambda: self.display_message("udt_send('Hello world')"))

            self.root.after(12500, lambda: self.show_image(rdt3timeout_duplicateack_fsm_path, self.state_diagram_canvas))
            self.root.after(12500, lambda: self.show_image(rdt3timeout_duplicateack_osd_path, self.operation_sequence_canvas))
            self.root.after(12500, lambda: self.display_message("rdt_rcv('ACK')"))

            self.root.after(17500, lambda: self.show_image(rdt3timeout_recieve2_fsm_path, self.state_diagram_canvas))
            self.root.after(17500, lambda: self.display_message("rdt_rcv('Hello world')"))


        elif selected_scenario == "lost packet":
            #packet loss case pictures
            rdt3packetloss_fsm_path = self.image_paths["rdt3.0packetloss_send_FSM"]
            udt3packetloss_fsm_path = self.image_paths["udt3.0packetloss_send_FSM"]
            rdt3packetloss_timeout_fsm_path = self.image_paths["rdt3.0packetloss_timeout_FSM"]
            rdt3packetloss_resend_fsm_path = self.image_paths["rdt3.0packetloss_resend_FSM"]
            rdt3packetloss_recieve_fsm_path = self.image_paths["rdt3.0packetloss_recieve_FSM"]
            rdt3packetloss_ack_fsm_path = self.image_paths["rdt3.0packetloss_ack_FSM"]
            rdt3packetloss_ackack_fsm_path = self.image_paths["rdt3.0packetloss_ackack_FSM"]

            rdt3packetloss_send_osd_path = self.image_paths["rdt3.0packetloss_send_OSD"]
            rdt3packetloss_timeout_osd_path = self.image_paths["rdt3.0packetloss_timeout_OSD"]
            rdt3packetloss_resend_osd_path = self.image_paths["rdt3.0packetloss_resend_OSD"]
            rdt3packetloss_recieve_osd_path = self.image_paths["rdt3.0packetloss_recieve_OSD"]
            rdt3packetloss_ack_osd_path = self.image_paths["rdt3.0packetloss_ack_OSD"]
            rdt3packetloss_ackack_osd_path = self.image_paths["rdt3.0packetloss_ackack_OSD"]

            self.root.after(0, lambda: self.show_image(rdt_send_path, self.rdt_model_canvas))
            self.root.after(0, lambda: self.show_image(rdt3packetloss_fsm_path, self.state_diagram_canvas))
            self.root.after(0, lambda: self.show_image(rdt2_osd_default_path, self.operation_sequence_canvas))
            self.root.after(0, lambda: self.display_message("rdt_send('Hello world')"))

            self.root.after(2500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(2500, lambda: self.show_image(udt3packetloss_fsm_path, self.state_diagram_canvas))
            self.root.after(2500, lambda: self.show_image(rdt3packetloss_send_osd_path, self.operation_sequence_canvas))
            self.root.after(2500, lambda: self.display_message("udt_send('Hello world')"))

            self.root.after(5000, lambda: self.show_image( rdt3packetloss_timeout_fsm_path, self.state_diagram_canvas))
            self.root.after(5000, lambda: self.show_image(rdt3packetloss_timeout_osd_path, self.operation_sequence_canvas))
            self.root.after(5000, lambda: self.display_message("timeout at sender"))

            self.root.after(7500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(7500, lambda: self.show_image(rdt3packetloss_resend_fsm_path, self.state_diagram_canvas))
            self.root.after(7500, lambda: self.show_image(rdt3packetloss_resend_osd_path, self.operation_sequence_canvas))
            self.root.after(7500, lambda: self.display_message("udt_send('Hello world')"))

            self.root.after(10000, lambda: self.show_image(rdt_rcv_path, self.rdt_model_canvas))
            self.root.after(10000, lambda: self.show_image(rdt3packetloss_recieve_fsm_path, self.state_diagram_canvas))
            self.root.after(10000, lambda: self.show_image(rdt3packetloss_recieve_osd_path, self.operation_sequence_canvas))
            self.root.after(10000, lambda: self.display_message("rdt_rcv('Hello world')"))

            self.root.after(12500, lambda: self.show_image(udt_send_path, self.rdt_model_canvas))
            self.root.after(12500, lambda: self.show_image(rdt3packetloss_ack_fsm_path, self.state_diagram_canvas))
            self.root.after(12500, lambda: self.show_image(rdt3packetloss_ack_osd_path, self.operation_sequence_canvas))
            self.root.after(12500, lambda: self.display_message("udt_send('ACK')"))

            self.root.after(15000, lambda: self.show_image(rdt3packetloss_ackack_fsm_path, self.state_diagram_canvas))
            self.root.after(15000, lambda: self.show_image(rdt3packetloss_ackack_osd_path, self.operation_sequence_canvas))
            self.root.after(15000, lambda: self.display_message("rdt_rcv('ACK')"))

            self.root.after(17500, lambda: self.show_image(deliver_data_path, self.rdt_model_canvas))
            self.root.after(17500, lambda: self.display_message("deliver_data('Hello world')"))

        self.display_message("Simulation for TCP completed.")

    def clear_canvas(self):
        self.rdt_model_canvas.delete("all")
        self.state_diagram_canvas.delete("all")
        self.operation_sequence_canvas.delete("all")

    def display_message(self, message):
        self.command_prompt_text.insert(tk.END, message + "\n")
        self.command_prompt_text.see(tk.END)


if __name__ == "__main__":
    root = tk.Tk()
    app = SimulatorApp(root)
    root.mainloop()
