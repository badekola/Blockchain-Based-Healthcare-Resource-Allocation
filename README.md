# Blockchain-Based Healthcare Resource Allocation System

This project implements a blockchain-based system for healthcare resource allocation using Clarity smart contracts on the Stacks blockchain. The system enables efficient tracking, allocation, and management of medical resources across healthcare facilities.

## System Components

The system consists of five main smart contracts:

1. **Facility Verification Contract**: Validates healthcare providers and maintains their credentials
2. **Resource Inventory Contract**: Records available medical supplies and equipment
3. **Demand Forecasting Contract**: Predicts resource requirements based on historical data
4. **Allocation Contract**: Manages distribution of resources based on priority and need
5. **Usage Tracking Contract**: Monitors consumption of resources by healthcare facilities

## Contract Functionality

### Facility Verification Contract

- Register and verify healthcare facilities
- Maintain facility credentials and licensing information
- Activate/deactivate facilities as needed

### Resource Inventory Contract

- Track available medical supplies and equipment
- Monitor inventory levels across facilities
- Set critical threshold levels for resources

### Demand Forecasting Contract

- Record historical demand data
- Generate forecasts for future resource needs
- Provide confidence levels for predictions

### Allocation Contract

- Process resource allocation requests
- Prioritize requests based on urgency and need
- Track allocation approvals and fulfillment

### Usage Tracking Contract

- Monitor resource consumption
- Link usage to specific allocations
- Generate usage reports and analytics

## Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Clarity development environment
- [Stacks CLI](https://github.com/blockstack/stacks.js) - For interacting with the Stacks blockchain

### Installation

1. Clone the repository:
