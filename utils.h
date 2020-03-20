uint16_t getNodeFrequency(int node_id) { 
    uint16_t timer;

    switch (TOS_NODE_ID)
  	{
  	    case 1:
  	        timer = 1000;
  	        break;
  	    case 2:
  	        timer = 333;
  	        break;
  	    case 3:
  	        timer = 200;
  	        break;
  	    default:
  	        timer = 1000;
  	}
  	
  	return timer;
}



