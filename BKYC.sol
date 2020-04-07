pragma solidity >=0.4.25 <0.6.0;

contract BKYC
{
	enum StateType { Active, Approved, Terminated, Rejected }
	
	address public InstanceCreator;
	
	
        string public Name;
        string public TaxPayerID;
        StateType public State;
    	address public InstanceApprover;
	
	    constructor(address approver, string memory name, string memory _Tin) public
    	{
        	InstanceCreator = msg.sender;
	    	InstanceApprover = approver;
        	Name = name;
        	TaxPayerID = _Tin;
        	State = StateType.Active;
    	}

    	function Terminate() public
    	{
        	if (InstanceCreator != msg.sender)
        	{
            		revert();
        	}

        	State = StateType.Terminated;
    	}

    	function Modify(address approver, string memory name, string memory _Tin) public
    	{
        	if (State != StateType.Active)
        	{
            		revert();
        	}
        	if (InstanceCreator!= msg.sender)
        	{
            		revert();
        	}

                InstanceApprover = approver;
            	Name = name;
                TaxPayerID = _Tin;
	
    	}

    	function Create(address approver, string memory name, string memory _Tin) public
    	{
        	if (State != StateType.Active)
        	{
            		revert();
        	}
        	if (InstanceCreator!= msg.sender)
        	{
            		revert();
        	}

                 InstanceApprover = approver;
                 Name = name;
                 TaxPayerID = _Tin;
    	}



    	function Approve() public
    	{
	        if (InstanceApprover != msg.sender)
            {
                   revert();
            }

            if (State == StateType.Active)
            {
                   State = StateType.Approved;
            }
            else
            {
                   revert();
            }
        }

         function Reject() public
         {
            if (State != StateType.Active)
            {
                 revert();
            }
            if (InstanceApprover != msg.sender)
            {
                revert();
            }
        
                State = StateType.Rejected;
          }    

//         function getValue() public view returns(string memory)
//         {

//            	return AdharNumber;
//         }	

}



//contract KYCProcess
//{
//	enum StateType { Active, Disapprove, Approve, Terminate}
	
//	address public InstanceRequestor;
//	string public DataAdharNumber;
//    string public AdharNumber;
//	address public UniqueKey;
//    StateType public State;

//	address public InstanceCustomer;
	
//	function getRetriveValue(address uniqueKey) public view returns (string memory)
//	{
	
// 			KYC kyc = KYC(uniqueKey);
//			return kyc.getValue();
	
//	}
	
//	constructor(address customer,string memory adharNumber) public
//    	{
//	    	InstanceRequestor = msg.sender;
//        	InstanceCustomer = customer;
//	    	AdharNumber = adharNumber;
//	    	State = StateType.Active;
//    	}

		
//	function Proceed(address uniqueKey) public
//	{
//		if (State != StateType.Active)
//        	{
//            		revert();
//        	}
//        	if (InstanceCustomer!= msg.sender)
//        	{
//            		revert();
//        	}
		
//		UniqueKey = uniqueKey;
//		DataAdharNumber = getRetriveValue(UniqueKey);
		
		
//		if (keccak256(abi.encodePacked((DataAdharNumber))) == keccak256(abi.encodePacked((AdharNumber))))
//		{
//			State = StateType.Approve;
//		}
//		else
//		{
//			State = StateType.Disapprove;
//		}
		

//	}

//	function Terminate() public
//    	{
//        	if (InstanceRequestor != msg.sender)
//        	{
//            		revert();
//        	}

//        	State = StateType.Terminate;
//    	}	
		
//}


