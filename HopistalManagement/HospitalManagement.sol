// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HospitalManagement{

    struct Doctor{
        string name;
        string qualification;
        string specialist;
        uint256 salary;
        bool isEmployed;
    }

    struct Patient{
        string name;
        uint8 age;
        uint256 admitDate;
        bool isAdmited;
    }

    mapping(uint => Doctor) public doctor;
    mapping(uint => Patient) private patient;
    mapping(uint => string[]) private disease;    

    address public manager;

    modifier onlyManager(){
        require(manager == msg.sender, "You are not a Manager");
        _;
    }
     
    constructor(){
       manager = msg.sender;
    }

    function addDoctor(uint256 id, string calldata name, string calldata qualification, string calldata specialist, uint256 salary) external onlyManager{
        require(doctor[id].isEmployed == false, "Already Added");
        doctor[id] = Doctor({name: name, qualification: qualification, specialist: specialist, salary: salary, isEmployed: true});
    }

    function admitPatient(uint256 id, string calldata name, uint8 age, string calldata _disease) external onlyManager{
        require(patient[id].isAdmited == false, "Already Admited");
        patient[id] = Patient({name: name, age: age, admitDate: block.timestamp, isAdmited: true});
        disease[id].push(_disease);
    }

    function addMedicalRecord(uint256 id, string calldata _disease) external onlyManager{
        require(patient[id].isAdmited == true, "Patient is not Admited");
        disease[id].push(_disease);
    }

    function paientRecord(uint256 id) external view returns(Patient memory, string[] memory){
        return(patient[id], disease[id]);
    }
}