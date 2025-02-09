# Deep Reinforcement Learning‑driven Optimal Placement of Virtual Network Functions

## Overview
Network Function Virtualization (NFV) enables elastically scalable and fault-tolerant network functions (NFs). Since most NFs are stateful, state migration and replication across Virtual Machines (VMs) play a crucial role in maintaining elasticity and fault tolerance. However, these approaches introduce overhead in terms of increased communication and bandwidth consumption. 

This research leverages Deep Reinforcement Learning (DRL) to optimize the placement of Virtual Network Functions (VNFs) in a distributed network, thereby minimizing overhead and improving system performance and resilience.

## Objectives
Our primary objective is to develop a complete NF state management system that ensures elastic scaling, fault tolerance, and optimized VNF placement. Specifically, our goals include:

1. **RL-driven Optimal Placement:** Using Reinforcement Learning (RL) to dynamically select the best node for placing backup VNFs to minimize communication overhead.
2. **Traffic Load Balancing:** Employing RL-based policies to distribute traffic loads effectively and prevent overload scenarios.
3. **Failure Recovery:** Optimizing flow and state migration upon a VNF failure while minimizing the associated overhead.

## Methodology

### 1. **Adopting DEFT for State Management**
We build upon the existing DEFT system, which is designed for fault tolerance and elastic scalability. Our enhancements focus on reducing the communication overhead and improving overload handling.

### 2. **System Architecture**
- **Primary and Backup VNFs Placement:** Primary and backup VNFs are placed on separate nodes to ensure failover resilience. If a node fails, at least one VNF instance remains operational.
- **State Synchronization:** The system uses a **Two-Phase Commit (2PC) Protocol** to synchronize state updates between primary and backup VNFs.
- **Feature Extraction & Policy Network:** 
  - A **state matrix** is generated based on network conditions and incoming requests.
  - A **four-layer neural network** processes the matrix:
    - **Input Layer:** Receives the state matrix representing network conditions.
    - **Convolutional Layer:** Learns spatial patterns in the network topology.
    - **Softmax Layer:** Outputs probability distributions for node selection.
    - **Filtering Layer:** Removes infeasible nodes and selects the highest-probability node for VNF instantiation.

### 3. **Key Assumptions**
- The system tolerates **fail-stop failures** but does not handle Byzantine failures.
- **No communication link failures** or packet losses are considered.
- **An SDN controller** manages traffic distribution and failure detection.
- Per-flow packet distribution is assumed for primary NFs.

## Challenges & Solutions

| Challenges | Solutions |
|------------|-----------|
| Optimizing VNF placement under resource constraints | Designing appropriate RL-based cost functions |
| Adapting to dynamic network conditions | Continuous learning and adaptive policies |
| Efficient state synchronization between primary and backup VNFs | Applying optimized commit protocols |
| Designing a perfect reward function for RL | Trial and error, reward shaping, and balancing trade-offs |

## Expected Outcomes
By integrating RL-driven optimal placement strategies, we aim to enhance NFV deployments with the following improvements:

1. **Improved Resilience:** The system ensures robustness against node failures in virtualized NF environments.
2. **Enhanced Scalability:** It dynamically adapts to changing network conditions.
3. **Optimized Resource Utilization:** The risk of overload scenarios is reduced through intelligent traffic distribution.

## Technical Skills Utilized
- **Networked & Distributed Systems**
- **Reinforcement Learning**
- **Software-Defined Networking (SDN)**
- **Open vSwitch & Docker**
- **Hazelcast & Redis**

## Supervision & Timeline
**Supervised by:** Dr. Rezwana Reaz  
**Duration:** November 2023 – Present

## At A Glance 
- Developed a DRL‐based VNF placement strategy to minimize state migration and replication overhead in NFV using Proximal Policy Optmization 
- Enhanced DEFT’s state management system for better resilience, scalability, and resource optimization
- Ensured the deployment of primary and backup VNFs on separate servers, eliminating single points of failure
- Incorporated server capacity constraints into our reward function to proactively mitigate future overload scenarios
- Our proposed system improved latency, throughput, packet drops, and overload mitigation


## Conclusion
Our RL-based approach optimizes VNF placement, reducing the overhead of state migration and replication while ensuring system resilience and efficiency. By improving upon the DEFT state management system, our work aims to create a more scalable and fault-tolerant network architecture.
