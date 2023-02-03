(* 
Name					Date				Version				Note
Jamal Muhammad			10.10.2021			V2021.1				First version
*)

PROGRAM _INIT
	MpAxisBasic_0.Enable := TRUE;
	xHomingCmd := TRUE;

	AxisParameters.Velocity := 5.0;
	AxisParameters.Acceleration := 20.0;
	AxisParameters.Deceleration := 20.0;
	
	xPartLoadFirstCycle := TRUE;
	xPartUnloadFirstCycle := TRUE;
	// For simulation purpose
	FOR i:=1 TO 20 DO
		aBufferData[i].usiSeqNumber:= i;
		aBufferData[i].usiPartId := 100+i;
	END_FOR	
	usiPartId := 120;		
END_PROGRAM


PROGRAM _CYCLIC
	// Inputs
	lrServoPosition := MpAxisBasic_0.Position;
	
	stServoState.PowerON := MpAxisBasic_0.PowerOn;
	stServoState.Active := MpAxisBasic_0.Active;
	stServoState.MoveActive := MpAxisBasic_0.MoveActive;
	stServoState.Error := MpAxisBasic_0.Error;

	// Initialisation
	IF xInit = FALSE THEN
		ton_1(IN:=NOT ton_1.Q,PT:=T#3500MS);
		IF ton_1.Q THEN
			ton_1(IN:=FALSE,PT:=t#0MS);
			xInit := TRUE;
		END_IF
	END_IF	
	
	//	Enabling/Disabling servo
	IF xServoError OR xEmergencyStopInactive_NC=FALSE OR xDriveStopInactive_NC=FALSE THEN
		xServoEnable:=FALSE;
	ELSE
		xServoEnable:=TRUE;
	END_IF
		
	// Enabling servo power automatically after initialisation & xServoEnable are ON
	IF xServoEnable AND xInit AND MpAxisBasic_0.PowerOn = FALSE THEN
		MpAxisBasic_0.Power := TRUE;
	END_IF
	
	// If xHomingCmd is ON then move servo to zero position
	IF MpAxisBasic_0.Position = 0 THEN
		xHomingCmd := FALSE;
	ELSIF MpAxisBasic_0.Position<>0 AND xHomingCmd = TRUE AND MpAxisBasic_0.PowerOn THEN
		AxisParameters.Position := 0.0;
		MpAxisBasic_0.MoveAbsolute := TRUE;
	END_IF;
	
	// Part unloading has priority-1, part unloading has priority-2
	IF xUnloadPartCmd THEN
		xLoadPartCmd := FALSE;
	END_IF	
	
	//Check if buffer is full
	usiCounter := 0;
	FOR i:=1 TO usiPartBufferMax DO
		IF aBufferData[i].usiPartId <> 0 THEN
			usiCounter := usiCounter+1;
		END_IF
	END_FOR	
	IF usiCounter = usiPartBufferMax THEN
		xBufferFull:=TRUE;
	ELSE
		xBufferFull:=FALSE;
	END_IF	
	
	// State Machine > Unloading buffer
	IF xUnloadPartCmd AND xHomingCmd=FALSE AND MpAxisBasic_0.Enable THEN
		enumState_part_loading:=ST_LD_TO_ZERO_POS_1;
		xPartLoadFirstCycle:=TRUE;
		
		CASE enumState_part_unloading OF
			//*********************
			ST_UNLD_TO_ZERO_POS_1:
				IF xPartUnloadFirstCycle AND lrServoPosition<>0 THEN
					AxisParameters.Position := 0.0;
					AxisParameters.Velocity := 40.0;
					AxisParameters.Acceleration := 160.0;
					AxisParameters.Deceleration := 160.0;					
					AxisUpdate;
					IF xAxisUpdateDone AND MpAxisBasic_0.MoveActive=FALSE THEN
						MpAxisBasic_0.MoveAbsolute := TRUE;
						enumState_part_unloading:=ST_UNLD_TO_ZERO_POS_2;
					END_IF
				ELSE
					enumState_part_unloading:=ST_UNLD_SET_AXIS_PARAMS_1;	
				END_IF
			//*********************
			ST_UNLD_TO_ZERO_POS_2:
				IF lrServoPosition=0 THEN
					xPartUnloadFirstCycle := FALSE;
					MpAxisBasic_0.MoveAbsolute := FALSE;
					enumState_part_unloading:=ST_UNLD_SET_AXIS_PARAMS_1;
				END_IF			
			//*********************
			ST_UNLD_SET_AXIS_PARAMS_1:
				IF lrServoPosition<690 AND MpAxisBasic_0.MoveActive=FALSE THEN
					AxisParameters.Position := 690.0;
					AxisParameters.Velocity := 10.0;
					AxisParameters.Acceleration := 40.0;
					AxisParameters.Deceleration := 40.0;
					AxisUpdate;
					IF xAxisUpdateDone THEN
						enumState_part_unloading:=ST_UNLD_IF_UNLOAD_CMD;
					END_IF
				END_IF								
			//*********************
			ST_UNLD_IF_UNLOAD_CMD:
				IF xUnloadPartCmd THEN
					enumState_part_unloading:=ST_UNLD_FIND_UNLOADING_TARGET;
				END_IF	
			//*********************	
			ST_UNLD_FIND_UNLOADING_TARGET:
				FOR i:=1 TO usiPartBufferMax DO
					IF aBufferData[i].usiPartId <> 0 THEN
						FOR j:=1 TO usiPartBufferMax DO
							IF aBufferData[j].usiPartId<>0 AND i<>j AND aBufferData[i].usiPartId < aBufferData[j].usiPartId THEN
								usiTarget := i;
							ELSIF i=usiPartBufferMax THEN
								usiTarget := i;
							ELSE
								usiTarget := 0;
							END_IF
						END_FOR
						IF usiTarget<>0 THEN 
							enumState_part_unloading:=ST_UNLD_SET_AXIS_PARAMS_2;
							EXIT;
						END_IF
					END_IF	
				END_FOR
			//*********************	
			ST_UNLD_SET_AXIS_PARAMS_2:
				AxisParameters.Position := usiTarget*34.5;
				AxisParameters.Velocity := 10.0;
				AxisParameters.Acceleration := 40.0;
				AxisParameters.Deceleration := 40.0;					
				IF xAxisUpdateDone THEN
					enumState_part_unloading:=ST_UNLD_SERVO_MOVE_TO_TARGET;
				END_IF
			//*********************	
			ST_UNLD_SERVO_MOVE_TO_TARGET:
				MpAxisBasic_0.MoveAbsolute := TRUE;

				IF AxisParameters.Position > lrServoPosition  THEN
					IF lrServoPosition > AxisParameters.Position-5 THEN						
						MpAxisBasic_0.MoveAbsolute := FALSE;
						enumState_part_unloading:=ST_UNLD_SET_AXIS_PARAMS_3;
					END_IF;
				END_IF

				IF AxisParameters.Position < lrServoPosition  THEN
					IF lrServoPosition < AxisParameters.Position+5 THEN						
						MpAxisBasic_0.MoveAbsolute := FALSE;
						enumState_part_unloading:=ST_UNLD_SET_AXIS_PARAMS_3;
					END_IF;
				END_IF				
			//*********************
			ST_UNLD_SET_AXIS_PARAMS_3:
				IF MpAxisBasic_0.MoveActive = FALSE THEN
					AxisParameters.Velocity := 1.0;
					AxisParameters.Acceleration := 4.0;
					AxisParameters.Deceleration := 4.0;
					AxisUpdate;					
					IF xAxisUpdateDone THEN
						enumState_part_unloading:=ST_UNLD_SERVO_MOVE_SLOW;	
					END_IF
				END_IF
			//*********************	
			ST_UNLD_SERVO_MOVE_SLOW:
				MpAxisBasic_0.MoveAbsolute := TRUE;
				IF lrServoPosition=usiTarget*34.5 THEN
					MpAxisBasic_0.MoveAbsolute := FALSE;
					enumState_part_unloading:=ST_UNLD_UPDATE_BUFFER_INFO;
				END_IF			
			//*********************	
			ST_UNLD_UPDATE_BUFFER_INFO:
				aBufferData[usiTarget].usiPartId:=0;
				IF xPartUnloaded THEN 
					enumState_part_unloading:=ST_UNLD_DELAY;
				END_IF									
			//*********************	
			ST_UNLD_DELAY:
				ton_1(IN:=NOT ton_1.Q,PT:=T#750MS);
				IF ton_1.Q AND MpAxisBasic_0.MoveActive=FALSE THEN
					enumState_part_unloading:=ST_UNLD_IF_UNLOAD_CMD;
				END_IF				
		END_CASE
	END_IF	
	
	// Loading buffer
	IF 	xLoadPartCmd
		AND MpAxisBasic_0.Enable 
		AND xHomingCmd=FALSE
		AND xBufferFull=FALSE THEN
		enumState_part_unloading:=ST_UNLD_TO_ZERO_POS_1;
			xPartUnloadFirstCycle:=TRUE;

		CASE enumState_part_loading OF
			//*********************	
			ST_LD_TO_ZERO_POS_1:
				IF xPartLoadFirstCycle AND lrServoPosition<>0 THEN
					AxisParameters.Position := 0.0;
					AxisParameters.Velocity := 40.0;
					AxisParameters.Acceleration := 160.0;
					AxisParameters.Deceleration := 160.0;					
					AxisUpdate;
					IF xAxisUpdateDone THEN
						MpAxisBasic_0.MoveAbsolute := TRUE;
						enumState_part_loading:=ST_LD_TO_ZERO_POS_2;
					END_IF
				ELSE
					enumState_part_loading:=ST_LD_SET_AXIS_PARAMS_1;	
				END_IF
			//*********************	
			ST_LD_TO_ZERO_POS_2:
				IF lrServoPosition=0 THEN
					xPartLoadFirstCycle := FALSE;
					MpAxisBasic_0.MoveAbsolute := FALSE;
					enumState_part_loading:=ST_LD_SET_AXIS_PARAMS_1;
				END_IF	
			//*********************		
			ST_LD_SET_AXIS_PARAMS_1:
				IF lrServoPosition<690 AND MpAxisBasic_0.MoveActive = FALSE THEN
					AxisParameters.Position := 690.0;
					AxisParameters.Velocity := 10.0;
					AxisParameters.Acceleration := 40.0;
					AxisParameters.Deceleration := 40.0;
					AxisUpdate;
					IF xAxisUpdateDone THEN
						enumState_part_loading:=ST_LD_FIND_LOADING_TARGET;
					END_IF	
				END_IF				
			//*********************	
			ST_LD_FIND_LOADING_TARGET:
				FOR i:=1 TO 20 DO
					IF aBufferData[i].usiPartId = 0 THEN
						usiTarget := i;
						enumState_part_loading:=ST_LD_SERVO_MOVE_FAST;
						EXIT;
					END_IF
				END_FOR	
			//*********************		
			ST_LD_SERVO_MOVE_FAST:
				MpAxisBasic_0.MoveAbsolute := TRUE;

				IF lrServoPosition>((usiTarget*34.5)-4)THEN
					MpAxisBasic_0.MoveAbsolute := FALSE;
					enumState_part_loading:=ST_LD_SET_AXIS_PARAMS_2;
				END_IF
			//*********************	
			ST_LD_SET_AXIS_PARAMS_2:
				IF MpAxisBasic_0.MoveActive = FALSE THEN		
					AxisParameters.Velocity := 1.0;
					AxisParameters.Acceleration := 4.0;
					AxisParameters.Deceleration := 4.0;
					AxisUpdate;
					IF xAxisUpdateDone THEN
						enumState_part_loading:=ST_LD_SERVO_MOVE_SLOW;	
					END_IF
				END_IF	
			//*********************	
			ST_LD_SERVO_MOVE_SLOW:
				MpAxisBasic_0.MoveAbsolute := TRUE;				

				IF ((lrServoPosition=usiTarget*34.5) OR (lrServoPosition>(usiTarget*34.5))) THEN
					MpAxisBasic_0.MoveAbsolute := FALSE;
					enumState_part_loading:=ST_LD_UPDATE_BUFFER_INFO_1;
				END_IF
			//*********************		
			ST_LD_UPDATE_BUFFER_INFO_1:
				IF aBufferData[usiTarget].usiPartId = 0 THEN
					enumState_part_loading:=ST_LD_UPDATE_BUFFER_INFO_2;
				END_IF	
			//*********************		
			ST_LD_UPDATE_BUFFER_INFO_2:
				IF xPartLoaded THEN
					usiPartId := usiPartId+1;
					aBufferData[usiTarget].usiPartId:=usiPartId;
					enumState_part_loading:=ST_LD_DELAY;
				END_IF
			//*********************		
			ST_LD_DELAY:
				ton_1(IN:=NOT ton_1.Q,PT:=T#750MS);
				IF ton_1.Q AND MpAxisBasic_0.MoveActive=FALSE THEN
					ton_1(IN:=FALSE,PT:=T#0MS);
					enumState_part_loading:=ST_LD_SET_AXIS_PARAMS_1;
				END_IF				
		END_CASE
	END_IF

		
	// Servo axis movement command
	MpAxisBasic_0.MpLink     := ADR(gAxis_1);
	MpAxisBasic_0.Parameters := ADR(AxisParameters);
	MpAxisBasic_0();

	// Outputs
	IF xUnloadPartCmd=FALSE AND xLoadPartCmd=FALSE AND xHomingCmd = FALSE THEN
		MpAxisBasic_0.MoveAbsolute := FALSE;
	END_IF
	
END_PROGRAM

PROGRAM _EXIT	
	;	
END_PROGRAM

