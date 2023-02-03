
FUNCTION_BLOCK SfDomainConnect (*Establishes a connection to the defined SafeDOMAIN with given user identification*)
	VAR_INPUT
		SfDomain : REFERENCE TO SfDomType; (*Incoming SafeDOMAIN handle*) (* *) (*#PAR#;*)
		Enable : BOOL; (*Enables/Disables the function block*) (* *) (*#PAR#;*)
		UserName : STRING[80]; (*Logged in user name*) (* *) (*#PAR#;*)
		Password : STRING[80]; (*Password for the user for authentication*) (* *) (*#PAR#;*)
		UDID_Acknowledge : BOOL; (*Set true to acknowledge UDID change*) (* *) (*#PAR#;*)
	END_VAR
	VAR_OUTPUT
		Busy : BOOL; (*Function block is busy processing a command*) (* *) (*#PAR#;*)
		Active : BOOL; (*Command has finished and was successful.*) (* *) (*#PAR#; *)
		Error : BOOL; (*Indicates an error.*) (* *) (*#CMD#OPT#;*)
		StatusID : DINT; (*Error/Status information*) (* *) (*#CMD#*)
		SafeDomainID : UINT; (*ID of SafeDOMAIN to connect to*) (* *) (*#PAR#;*)
		CurrentUser : STRING[80]; (*Logged in user name*) (* *) (*#PAR#;*)
		PermissionLevel : SfDomainPermLevelEnum; (*Defines which permission level the connected user has*) (* *) (*#CMD#OPT#;*)
		UDID_low : UDINT; (*UDID low*) (* *) (*#CMD#OPT#;*)
		UDID_high : UINT; (*UDID high*) (* *) (*#CMD#OPT#;*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} SfDomainInternalDataType; (*Internal data*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK SfDomainTransfer (*Transfers a SafeAPPLICATION and/or a SafeCOMMISSIONING file to the connected SafeDOMAIN*)
	VAR_INPUT
		SfDomain : REFERENCE TO SfDomType; (*Incoming SafeDOMAIN handle*) (* *) (*#PAR#;*)
		Execute : BOOL; (*Executes the function block*) (* *) (*#PAR#;*)
		SafeAppFilePath : STRING[260]; (*Path to the safe application file.*) (* *) (*#PAR#;*)
		SafeCommFilePath : STRING[260]; (*Path to the safe commissioning file.*) (* *) (*#PAR#;*)
	END_VAR
	VAR_OUTPUT
		Done : BOOL; (*Has finished and was successful.*) (* *) (*#PAR#;*)
		Busy : BOOL; (*Function block is busy processing a command.*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates an error.*) (* *) (*#CMD#OPT#;*)
		StatusID : DINT; (**Error/Status information*) (* *) (*#CMD#*)
		Progress : USINT; (*Progress of the file transfer*) (* *) (*#CMD#OPT#;*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} SfDomainInternalDataType; (*Internal data*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK SfDomainCompletion (*Acknowledges the data of the connected SafeDOMAIN*)
	VAR_INPUT
		SfDomain : REFERENCE TO SfDomType; (*Incoming SafeDOMAIN handle*) (* *) (*#PAR#;*)
		Execute : BOOL; (*Executes the function block*) (* *) (*#PAR#;*)
		Info : SfDomainInfoType; (*Information about SafeDOMAIN*) (* *) (*#PAR#;*)
	END_VAR
	VAR_OUTPUT
		Done : BOOL; (*Has finished and was successful.*) (* *) (*#PAR#;*)
		Busy : BOOL; (*Function block is busy processing a command.*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates an error.*) (* *) (*#CMD#OPT#;*)
		StatusID : DINT; (**Error/Status information*) (* *) (*#CMD#*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} SfDomainInternalDataType; (*Internal data*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK SfDomainInfo (*Reads status information from the SafeLOGIC and its SafeAPPLICATION and SafeCOMMISSIONING*)
	VAR_INPUT
		SfDomain : REFERENCE TO SfDomType; (*Incoming SafeDOMAIN handle*) (* *) (*#PAR#;*)
		Execute : BOOL; (*Executes the function block*) (* *) (*#PAR#;*)
	END_VAR
	VAR_OUTPUT
		Done : BOOL; (*Has finished and was successful.*) (* *) (*#PAR#;*)
		Busy : BOOL; (*Function block is busy processing a command.*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates an error.*) (* *) (*#CMD#OPT#;*)
		StatusID : DINT; (**Error/Status information*) (* *) (*#CMD#*)
		Info : SfDomainInfoType; (*Information structure, filled with information from the SafeDOMAIN*) (* *) (*#CMD#*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} SfDomainInternalDataType; (*Internal data*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK SfDomainExchange (*Confirms requests from the SafeLOGIC of the connected SafeDOMAIN*)
	VAR_INPUT
		SfDomain : REFERENCE TO SfDomType; (*Incoming SafeDOMAIN handle*) (* *) (*#PAR#;*)
		Execute : BOOL; (*Executes the function block*) (* *) (*#PAR#;*)
		Info : SfDomainInfoType; (*Information about SafeDOMAIN*) (* *) (*#PAR#;*)
	END_VAR
	VAR_OUTPUT
		Done : BOOL; (*Has finished and was successful.*) (* *) (*#PAR#;*)
		Busy : BOOL; (*Function block is busy processing a command.*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates an error.*) (* *) (*#CMD#OPT#;*)
		StatusID : DINT; (**Error/Status information*) (* *) (*#CMD#*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} SfDomainInternalDataType; (*Internal data*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK SfDomainControl (*Performs control actions on the connected SafeLOGIC*)
	VAR_INPUT
		SfDomain : REFERENCE TO SfDomType; (*Incoming SafeDOMAIN handle*) (* *) (*#PAR#;*)
		Execute : BOOL; (*Executes the function block*) (* *) (*#PAR#;*)
		ControlCommand : SfDomainCtrlCmdEnum; (*Reboot/Format Execut comands*) (* *) (*#PAR#;*)
	END_VAR
	VAR_OUTPUT
		Done : BOOL; (*Has finished and was successful.*) (* *) (*#PAR#;*)
		Busy : BOOL; (*Function block is busy processing a command.*) (* *) (*#PAR#;*)
		Error : BOOL; (*Indicates an error.*) (* *) (*#CMD#OPT#;*)
		StatusID : DINT; (**Error/Status information*) (* *) (*#CMD#*)
	END_VAR
	VAR
		Internal : {REDUND_UNREPLICABLE} SfDomainInternalDataType; (*Internal data*)
	END_VAR
END_FUNCTION_BLOCK
