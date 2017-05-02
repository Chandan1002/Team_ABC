#define IDEAL (atm_layer[Layer_3=1] && CoC=1)


int H, V;
bool COC, auto_resolver, pilot_response;
byte atm_layer[4];    	
						/*atm_layer[0]=Layer1, atm_layer[1]=Layer2, atm_layer[2]=Layer3, atm_layer[3]=Layer4*/
byte move_direction[2];
						/*move_direction[0]=1 -> east_to_west 
						  move_direction[0]=0 -> west_to_east
						  move_direction[1]=1 -> north_to_south 
						  move_direction[1]=0 -> south_to_north */
byte climb[3];

proctype fly(){
    
    do
    ::atomic{atm_layer[1]=1; climb[2]=1; COC=0; auto_resolver=0; pilot_response=0}
    ::atomic{atm_layer[1]=1; climb[2]=1; COC=0; auto_resolver=0; pilot_response=1}
    ::atomic{atm_layer[1]=1; climb[2]=1; COC=0; auto_resolver=1; pilot_response=0}
    ::atomic{atm_layer[1]=1; climb[2]=1; COC=0; auto_resolver=1; pilot_response=1}
    ::atomic{atm_layer[1]=1; climb[2]=1; COC=1; auto_resolver=0; pilot_response=0}
    ::atomic{atm_layer[1]=1; climb[2]=1; COC=1; auto_resolver=0; pilot_response=1}
    ::atomic{atm_layer[1]=1; climb[2]=1; COC=1; auto_resolver=1; pilot_response=0}
    ::atomic{atm_layer[1]=1; climb[2]=1; COC=1; auto_resolver=1; pilot_response=1}
	::atomic{atm_layer[2]=1; climb[2]=1; COC=0; auto_resolver=0; pilot_response=0}
    ::atomic{atm_layer[2]=1; climb[2]=1; COC=0; auto_resolver=0; pilot_response=1}
    ::atomic{atm_layer[2]=1; climb[2]=1; COC=0; auto_resolver=1; pilot_response=0}
    ::atomic{atm_layer[2]=1; climb[2]=1; COC=0; auto_resolver=1; pilot_response=1}
    ::atomic{atm_layer[2]=1; climb[2]=1; COC=1; auto_resolver=0; pilot_response=0}
    ::atomic{atm_layer[2]=1; climb[2]=1; COC=1; auto_resolver=0; pilot_response=1}
    ::atomic{atm_layer[2]=1; climb[2]=1; COC=1; auto_resolver=1; pilot_response=0}
    ::atomic{atm_layer[2]=1; climb[2]=1; COC=1; auto_resolver=1; pilot_response=1}
	if
	::atm_layer[2]==1 && COC==0 && pilot_response==0 && move_direction[0]==0 -> climb[0]==1 && atm_layer[1]==1
	::atm_layer[2]==1 && COC==0 && pilot_response==0 && move_direction[0]==1 -> climb[0]==1 && atm_layer[3]==1
    ::atm_layer[2]==1 && COC==0 && pilot_response==0 && move_direction[1]==0 -> climb[1]==1 && atm_layer[1]==1
    ::atm_layer[2]==1 && COC==0 && pilot_response==0 && move_direction[1]==1 -> climb[1]==1 && atm_layer[3]==1
	::atm_layer[2]==1 && COC==1-> climb[2]==1;
	fi
	od
}

proctype horizontal(){
	do
	::atomic{atm_layer[2]==1; climb[2]=1}
    if
    ::atomic{atm_layer[2]==1; climb[2]==1; H>1600 -> COC==1 && auto_resolver==0 && pilot_response==0}
    ::atomic{atm_layer[2]==1; climb[2]==1; 1600>=H>1000 -> COC==0 && auto_resolver==0 && pilot_response==1}
    ::atomic{atm_layer[2]==1; climb[2]==1; 1000>H -> COC==0 && auto_resolver==1 && pilot_response==0 && climb[1]==1}
    fi
    od
    
}

proctype vertical(){
    if
    ::atomic{atm_layer[2]==1; climb[2]==1; V>1200 -> COC==1 && auto_resolver==0 && pilot_response==0}
    ::atomic{atm_layer[2]==1; climb[2]==1; 1200>=V>800 -> COC==0 && auto_resolver==0 && pilot_response==1}
    ::atomic{atm_layer[2]==1; climb[2]==1; 800>V -> COC==0 && auto_resolver==1 && pilot_response==0 && climb[1]==1}
    fi
    
}

init{
    run fly(); run horizontal()
}