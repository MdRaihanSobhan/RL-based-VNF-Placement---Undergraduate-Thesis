# Deep Reinforcement Learning-driven Optimal Placement of Virtual Network Functions in a Distributed Network for Fault Tolerant State Replication and Migration

This project builds upon the baseline paper: [**DEFT: Distributed, Elastic, and Fault-tolerant State Management of Network Functions**](https://arxiv.org/pdf/2311.18595). The original DEFT system chooses servers for placing VNFs (Virtual Network Functions) without leveraging intelligent decision-making. 

- Have a look at the [Extended Abstract](/Extended Abstract.pdf)

Our enhancement incorporates a **Reinforcement Learning (RL) Algorithm** to optimize the placement of VNFs, improving key metrics such as:

- **Latency**
- **Throughput**
- **Packet Drops**
- **Overload Mitigation**

The RL-based approach ensures optimal node selection for VNF placement, enhancing overall system performance and resilience.

## How to Run

Follow these steps to set up and run the project:

### 1. Install Open vSwitch
```bash
sudo apt-get -y install openvswitch-switch
```

### 2. Install Docker and Docker-compose
Follow the official instructions to install [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/).

### 3. Navigate to the Project Directory
Change to the relevant directory in the project:
- For DEFT (Original Paper)
```bash
cd DEFT/src/txts_unit
```
- For our work, DeftRL 
```bash
cd DeftRL-Revised/src/txts_unit
```

### 4. Add the .env file
- Create a file .env inside src/txts_unit directory. 
- Copy the contents of .env.example from the same directory and paste them into the .env file you created. Save the file.
  
### 5. Run the Test Script
Execute the test runner script to start the system:
```bash
sudo -E bash test_runner.sh
```

### 6. Install Necessary Libraries and Tools (if needed)
If the script encounters missing dependencies, install them using the package manager or relevant commands provided in the error logs.

---

## Additional Information

For any questions or troubleshooting, please refer to the documentation in the project directory or contact the contributors. Contributions are welcome to further improve the system's performance and functionality.
