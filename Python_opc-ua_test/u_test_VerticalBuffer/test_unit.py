from opcua import Client
from opcua import ua
import py
import time
import pytest
import Tags
import logging
import OPC as server
from importlib import reload
reload(Tags)

logging.basicConfig(level=logging.INFO)
_logger = logging.getLogger('opcua')

#///////////////////Initialize///////////////////

tag_struct= Tags.MotorTestTags
varpath=  Tags.MotorTestpath

#client = Client("opc.tcp://DESKTOP-5DM01DM:4842")
client = Client("opc.tcp://127.0.0.1:4842") 



reset_tag=tag_struct[0]
delay_time=0.05

#///////////////////////////////////////////////////    

#Init test
def test_init_prg():
    server.OPC_Connect(client)
    print("Client is connected")
    #server.end_test(client,tag_struct,varpath, reset_tag)


#Unit test: 3 parts unloading from buffer
def test_u_gd_000():
    for x in range(3):
        #xUnloadPartCmd
        xUnloadPartCmd = client.get_node("ns=6;s=::Program:xUnloadPartCmd")
        dv = ua.DataValue(ua.Variant([True], ua.VariantType.Boolean))
        dv.ServerTimestamp = None
        dv.SourceTimestamp = None        
        xUnloadPartCmd.set_data_value(dv)
         
        time.sleep(1)
        
        #MpAxisBasic_0.MoveActive
        MoveActive = client.get_node("ns=6;s=::Program:MpAxisBasic_0.MoveActive")
        varvalue = MoveActive.get_value()
        while varvalue!=False:
            time.sleep(1)
            varvalue = MoveActive.get_value()
        
        #Program:xPartUnloaded    
        xPartUnloaded = client.get_node("ns=6;s=::Program:xPartUnloaded")
        dv = ua.DataValue(ua.Variant([True], ua.VariantType.Boolean))
        dv.ServerTimestamp = None
        dv.SourceTimestamp = None        
        xPartUnloaded.set_data_value(dv)     
        time.sleep(0.1)    
        dv = ua.DataValue(ua.Variant([False], ua.VariantType.Boolean))       
        xPartUnloaded.set_data_value(dv)    
    
        #xUnloadPartCmd
        dv = ua.DataValue(ua.Variant([False], ua.VariantType.Boolean))      
        xUnloadPartCmd.set_data_value(dv) 
       
# #Test Stop Button
# def test_u_gd_001():
    
#     objects=server.getvar(client)
  
#     server.write_opc_var(objects,varpath, tag_struct[0], True)
#     time.sleep(delay_time)
#     data=server.read_opc_var(objects, varpath,tag_struct[4])
#     assert data==1
    
#     server.write_opc_var(objects,varpath, tag_struct[1], True)
#     time.sleep(delay_time)
#     data=server.read_opc_var(objects, varpath,tag_struct[4])
#     assert data==0
    
    
#     server.end_test(client, tag_struct, varpath, reset_tag)
    

# #Test EMGC Button
# def test_u_gd_002():
    
#     objects=server.getvar(client)
  
#     server.write_opc_var(objects,varpath, tag_struct[0], True)
#     time.sleep(delay_time)
#     data=server.read_opc_var(objects, varpath,tag_struct[4])
#     assert data==1
    
#     server.write_opc_var(objects,varpath, tag_struct[2], True)
#     time.sleep(delay_time)
#     data=server.read_opc_var(objects, varpath,tag_struct[4])
#     assert data==0
    
    
#     server.end_test(client, tag_struct, varpath, reset_tag)

# #Test OVLD Button
# def test_u_gd_003():
    
#     objects=server.getvar(client)
  
#     server.write_opc_var(objects,varpath, tag_struct[0], True)
#     time.sleep(delay_time)
#     data=server.read_opc_var(objects, varpath,tag_struct[4])
#     assert data==1
    
#     server.write_opc_var(objects,varpath, tag_struct[3], True)
#     time.sleep(delay_time)
#     data=server.read_opc_var(objects, varpath,tag_struct[4])
#     assert data==0
    
    
#     server.end_test(client, tag_struct, varpath, reset_tag)


#end connection 
def test_u_disconnect():
    
    server.OPC_Disconnect(client)
    

 