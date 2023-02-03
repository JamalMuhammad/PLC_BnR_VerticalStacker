/* Automation Studio generated header file */
/* Do not edit ! */
/* SfDomain 5.12.2 */

#ifndef _SFDOMAIN_
#define _SFDOMAIN_
#ifdef __cplusplus
extern "C" 
{
#endif
#ifndef _SfDomain_VERSION
#define _SfDomain_VERSION 5.12.2
#endif

#include <bur/plctypes.h>

#ifndef _BUR_PUBLIC
#define _BUR_PUBLIC
#endif
/* Datatypes and datatypes of function blocks */
typedef enum SfDomainSafeOSStateEnum
{	sfDOM_OS_STATE_INVALID = 0,
	sfDOM_OS_STATE_ON = 15,
	sfDOM_OS_STATE_LOADING = 51,
	sfDOM_OS_STATE_SAFE_STOP = 85,
	sfDOM_OS_STATE_SAFE_RUN = 102,
	sfDOM_OS_STATE_DEBUG_HALT = 153,
	sfDOM_OS_STATE_DEBUG_STOP = 170,
	sfDOM_OS_STATE_DEBUG_RUN = 204,
	sfDOM_OS_STATE_NO_EXECUTION = 240,
	sfDOM_OS_STATE_DEBUG_OFFLINE = 255
} SfDomainSafeOSStateEnum;

typedef enum SfDomainSafeNodesStateEnum
{	sfDOM_NODES_STATE_OK = 0,
	sfDOM_NODES_STATE_EXCHANGED = 1,
	sfDOM_NODES_STATE_MISSING = 2
} SfDomainSafeNodesStateEnum;

typedef enum SfDomainSystemStateEnum
{	sfDOM_SYSTEM_STATE_OK = 0,
	sfDOM_SYSTEM_STATE_FW_EXCHANGE = 1,
	sfDOM_SYSTEM_STATE_SK_EXCHANGE = 2
} SfDomainSystemStateEnum;

typedef enum SfDomainOperationalModeEnum
{	sfDOM_OP_MODE_OPERATIONAL = 0,
	sfDOM_OP_MODE_PREOPERATIONAL = 1,
	sfDOM_OP_MODE_FAILSAFE = 2
} SfDomainOperationalModeEnum;

typedef enum SfDomainSafeComUnusedEnum
{	sfDOM_UNUSED_NONE = 0,
	sfDOM_BOOL_AVAILABILITY = 1,
	sfDOM_NUMBERS = 2,
	sfDOM_BOOL_AVAILABILITY_NUMBERS = 3,
	sfDOM_NODE = 4,
	sfDOM_NODE_BOOL_AVAILABILITY = 5,
	sfDOM_NODE_NUMBERS = 6,
	sfDOM_BOOL_AVAIL_NUMBERS = 7
} SfDomainSafeComUnusedEnum;

typedef enum SfDomainPermLevelEnum
{	sfDOM_PERMLEVEL_APPLENGINEER = 0,
	sfDOM_PERMLEVEL_MAOPERATOR = 1
} SfDomainPermLevelEnum;

typedef enum SfDomainCtrlCmdEnum
{	sfDOM_REBOOT = 0,
	sfDOM_FORMAT_REBOOT = 1
} SfDomainCtrlCmdEnum;

typedef struct SfDomainInfoStatusType
{	enum SfDomainSafeOSStateEnum SafeOSState;
	enum SfDomainSafeNodesStateEnum SafeNodesState;
	enum SfDomainSystemStateEnum SystemState;
	enum SfDomainOperationalModeEnum OperationalModeState;
	enum SfDomainSafeComUnusedEnum SafeCommissioningUnused;
	plcbit FWExchanged;
	unsigned short NumberOfFWExchanged;
	plcbit SNExchanged;
	unsigned short NumberOfSNExchanged;
	plcbit SKExchanged;
	plcbit SetupModeActive;
} SfDomainInfoStatusType;

typedef struct SfDomainInfoFileType
{	plcbit ExistOnSafeLogic;
	plcstring Name[261];
	plcstring UserName[261];
	unsigned long TimeStamp;
	unsigned long CRC;
	plcbit Acknowledged;
} SfDomainInfoFileType;

typedef struct SfDomainInfoType
{	struct SfDomainInfoStatusType Status;
	struct SfDomainInfoFileType SafeApplication;
	struct SfDomainInfoFileType SafeCommissioning[1];
} SfDomainInfoType;

typedef struct SfDomainInternalFlags
{	plcbit Toggled;
	plcbit WaitForOneCycle;
	plcbit ActiveDoneReached;
} SfDomainInternalFlags;

typedef struct SfDomInternalIfType
{	plcdword vTable;
} SfDomInternalIfType;

typedef struct SfDomType
{	struct SfDomInternalIfType* controlIf;
} SfDomType;

typedef struct SfDomainInternalDataType
{	unsigned long pObject;
	unsigned long State;
	struct SfDomainInternalFlags Flag;
	struct SfDomType* SfDomainInternal;
} SfDomainInternalDataType;

typedef struct SfDomainConnect
{
	/* VAR_INPUT (analog) */
	struct SfDomType* SfDomain;
	plcstring UserName[81];
	plcstring Password[81];
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	unsigned short SafeDomainID;
	plcstring CurrentUser[81];
	enum SfDomainPermLevelEnum PermissionLevel;
	unsigned long UDID_low;
	unsigned short UDID_high;
	/* VAR (analog) */
	struct SfDomainInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	plcbit UDID_Acknowledge;
	/* VAR_OUTPUT (digital) */
	plcbit Busy;
	plcbit Active;
	plcbit Error;
} SfDomainConnect_typ;

typedef struct SfDomainTransfer
{
	/* VAR_INPUT (analog) */
	struct SfDomType* SfDomain;
	plcstring SafeAppFilePath[261];
	plcstring SafeCommFilePath[261];
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	unsigned char Progress;
	/* VAR (analog) */
	struct SfDomainInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} SfDomainTransfer_typ;

typedef struct SfDomainCompletion
{
	/* VAR_INPUT (analog) */
	struct SfDomType* SfDomain;
	struct SfDomainInfoType Info;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	/* VAR (analog) */
	struct SfDomainInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} SfDomainCompletion_typ;

typedef struct SfDomainInfo
{
	/* VAR_INPUT (analog) */
	struct SfDomType* SfDomain;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	struct SfDomainInfoType Info;
	/* VAR (analog) */
	struct SfDomainInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} SfDomainInfo_typ;

typedef struct SfDomainExchange
{
	/* VAR_INPUT (analog) */
	struct SfDomType* SfDomain;
	struct SfDomainInfoType Info;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	/* VAR (analog) */
	struct SfDomainInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} SfDomainExchange_typ;

typedef struct SfDomainControl
{
	/* VAR_INPUT (analog) */
	struct SfDomType* SfDomain;
	enum SfDomainCtrlCmdEnum ControlCommand;
	/* VAR_OUTPUT (analog) */
	signed long StatusID;
	/* VAR (analog) */
	struct SfDomainInternalDataType Internal;
	/* VAR_INPUT (digital) */
	plcbit Execute;
	/* VAR_OUTPUT (digital) */
	plcbit Done;
	plcbit Busy;
	plcbit Error;
} SfDomainControl_typ;



/* Prototyping of functions and function blocks */
_BUR_PUBLIC void SfDomainConnect(struct SfDomainConnect* inst);
_BUR_PUBLIC void SfDomainTransfer(struct SfDomainTransfer* inst);
_BUR_PUBLIC void SfDomainCompletion(struct SfDomainCompletion* inst);
_BUR_PUBLIC void SfDomainInfo(struct SfDomainInfo* inst);
_BUR_PUBLIC void SfDomainExchange(struct SfDomainExchange* inst);
_BUR_PUBLIC void SfDomainControl(struct SfDomainControl* inst);


#ifdef __cplusplus
};
#endif
#endif /* _SFDOMAIN_ */

