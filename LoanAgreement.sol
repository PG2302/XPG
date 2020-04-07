pragma solidity >=0.4.25 <0.6.0;

import './BKYC.sol';

contract LoanAgreement
{
	enum StateType { Active, Verified, PendingCustomerSign, Signed, PendingApproval, Approved, Disbursed, Terminated, VerificationFailed}
	
	address public InstanceCreator;
	string public Name;
	string public DataName;
	string public Bank;
    string public TaxPayerID;
    string public DataTaxPayerID;
    string public LoanAmt;
	string public PrincAmt;
    string public LoanId;
	string public Unkey;
    string public InterestRate;
    StateType public State;
    	
	address public InstanceBank;
	address public InstanceBroker;
    address public UniqueKey;


//Constructor for bank agreement management


	constructor(address bank, address broker, string memory name, string memory loanId, string memory _Tin, string memory interest, string memory princamt, string memory unkey) public
    	{
        	InstanceCreator = msg.sender;
		InstanceBank = bank;
	//	Bank = bank;
	    	InstanceBroker = broker;
        	Name = name;
		LoanId = loanId;
	    	TaxPayerID = _Tin;
        	State = StateType.Active;
        	InterestRate = interest;
        	PrincAmt = princamt;
		Unkey = unkey;
    	}


	function Reject() public
    	{
        	if (InstanceBank != msg.sender && InstanceBroker != msg.sender)
        	{
            		revert();
        	}

        	State = StateType.Terminated;
    	}

//Terminate contract

	function Terminate() public
    	{
        	if (InstanceBank != msg.sender && InstanceBroker != msg.sender)
        	{
            		revert();
        	}

        	State = StateType.Terminated;
    	}



// Create loan & control agreement 


    	function Create(address bank, address broker, string memory name, string memory loanId, string memory _Tin, string memory interest, string memory princamt, string memory unkey) public
    	{
        	if (State != StateType.Active)
        	{
            		revert();
        	}
        	if (InstanceBank!= msg.sender)
        	{
            		revert();
        	}

         //       InstanceBank = bank;
        	InstanceBroker = broker;
	//	InstanceCreator = name;
		Name = name;
        	LoanId = loanId;
	    	TaxPayerID = _Tin;
        	State = StateType.Active;
        	InterestRate = interest;
        	PrincAmt = princamt;
		Unkey = unkey;
    	}


//Modify agreement details


	function Modify(address broker, string memory name, string memory _Tin, string memory princamt, string memory interest, string memory loanId, string memory unkey) public
    	{
        	if (State != StateType.Active)
        	{
            		revert();
        	}
        	if (InstanceBank!= msg.sender)
        	{
            		revert();
        	}

                InstanceBroker = broker;
        	Name = name;
        	LoanId = loanId;
	    	TaxPayerID = _Tin;
        	State = StateType.Active;
        	InterestRate = interest;
        	PrincAmt = princamt;
		Unkey = unkey;
	
    	}


//function getRetriveValue(address uniqueKey) public view returns (string memory)
	//{
	
 //			LoanAgreement name = LoanAgreement(uniqueKey);
//			LoanAgreement TaxPayerID = LoanAgreement(uniqueKey);
//			return name.getValue();
//	        return TaxPayerID.getValue();
//	}
	
//	constructor(string memory name, string memory _Tin, address uniqueKey) public
//    	{
//	    	InstanceBank = msg.sender;
//        	Name = Name;
//        	TaxPayerID = TaxPayerID;
//	    	UniqueKey = uniqueKey;
//	    	State = StateType.Active;
//	    	
//	 }


// Get value from Blockchain

// function getValue() public view returns(string memory)
//         {

//            	return (Name, TaxPayerID);
//		        return TaxPayerID;
		
//         }

// Verify function -. Bank will provide the unique key and the verification will be done auto.

function Verify(address uniqueKey) public
    	{
    	    
	        if (InstanceBank != msg.sender)
            {
                   revert();
            }

            if (State == StateType.Active)
            {
                  
		UniqueKey = uniqueKey;
//		DataName = getRetriveValue(UniqueKey);
		DataTaxPayerID = getRetriveValue(UniqueKey);
		
		if (keccak256(abi.encodePacked((DataTaxPayerID))) == keccak256(abi.encodePacked((TaxPayerID))))
		{
			State = StateType.Verified;
		}
		else
		{
			State = StateType.VerificationFailed;
		}

			State = StateType.Verified;
            }
            else
            {
                   revert();
            }
        }

//get value for other address

function getRetriveValue(address uniqueKey) public view returns (string memory)
	{
	
 			BKYC bkyc = BKYC(uniqueKey);
			return bkyc.getValue();
	
	}

// Approve function -. Broker approves the control agreement.

function Approve() public
    	{
	        if (InstanceBroker != msg.sender)
            {
                   revert();
            }

            if (State == StateType.PendingApproval)
            {
                   State = StateType.Approved;
            }
            else
            {
                   revert();
            }
        }

//Pending confirmation: Not required currently

//	function PendingConfirmation() public
//	{
//		if (State != StateType.Active)
//            {
//                 revert();
//            }
//            if (InstanceBank != msg.sender)
//            {
//                revert();
//            }
//		State = StateType.PendingConfirmation;
//	}

//Confirmed: ot required currently
//	function Confirmed() public
//	{
//		if (State != StateType.PendingConfirmation)
//            {
//                 revert();
//            }
//            if (InstanceBroker != msg.sender)
//            {
//                revert();
//            }
//		State = StateType.Confirmed;
//	}

//PendingCustomerSign: Customer sign required on the control agreement thet is created by Bank

	function PendingCustomerSign() public
	{
		if (State != StateType.Verified)
            {
                 revert();
            }
            if (InstanceBank != msg.sender)
            {
                revert();
            }
		State = StateType.PendingCustomerSign;
	}

//Signed: Customer signs the control agreement as accepted
	
	function Signed() public
	{
		if (State != StateType.PendingCustomerSign)
            {
                 revert();
            }
            if (InstanceCreator != msg.sender)
            {
                revert();
            }
		State = StateType.Signed;
	}

//Approval: After signing the control agreement the customer moves for broker approval

	function PendingApproval() public
	{
		if (State != StateType.Signed)
            {
                 revert();
            }
            if (InstanceCreator != msg.sender)
            {
                revert();
            }
		State = StateType.PendingApproval;
	}
	

//PendingDisbursement : Currently not in use

//	function PendingDisbursement() public
//	{
//		if (State != StateType.Approved)
//            {
//                 revert();
//            }
//            if (InstanceBroker != msg.sender)
//            {
//                revert();
//            }
//		State = StateType.PendingDisbursement;
//	}

	function Disburse() public
	{
		if (State != StateType.Approved)
            {
                 revert();
            }
            if (InstanceBank != msg.sender)
            {
                revert();
            }
		State = StateType.Disbursed;
	}
}