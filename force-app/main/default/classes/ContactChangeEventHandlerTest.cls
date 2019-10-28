/**
 * Copyright (c) 2016-2019, Bill anderson.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *
 *   * Neither the name of Bill anderson nor the names of its
 *     contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * @author Bill anderson
 * @description all behaviour logic relating to the testing the ContactChangeEventHandler
 *
 * NOTE: AN EXANMPLE ... JUST USED FOR TESTING.
 *
 * This UNIT TEST does not assume the use of sf-trigger-handler framework. You would normally, wire in a
 * Unit Test via the custom metadata ( marked with a 'test' environment); however, because of the
 * flexibility of the framework, we will invoke methods in our test.
 *
 *@group Test Layer
 **/

@isTest
private class ContactChangeEventHandlerTest {

    /////////////////////////////////////////////////////////////////////////////////////////
    // Data Members
    /////////////////////////////////////////////////////////////////////////////////////////
    /*
     * Map of out ChangeType with expected message logged in the handlers
     */
    static Map<String,String> changeTypesInHandler = new Map<String,String>  {
        accc_CDCEventBase.CDC_CREATE_CHANGE_TYPE=>ContactChangeEventHandler.TEST_CREATE_MSG,
        accc_CDCEventBase.CDC_UPDATE_CHANGE_TYPE=>ContactChangeEventHandler.TEST_UPDATE_MSG,
        accc_CDCEventBase.CDC_DELETE_CHANGE_TYPE=>ContactChangeEventHandler.TEST_DELETE_MSG,
        accc_CDCEventBase.CDC_UNDELETE_CHANGE_TYPE=>ContactChangeEventHandler.TEST_UNDELETE_MSG,
        // +++ GAP +++
        accc_CDCEventBase.CDC_GAPUPDATE_CHANGE_TYPE=>ContactChangeEventHandler.TEST_GAP_UPDATE_MSG,
        accc_CDCEventBase.CDC_GAPDELETE_CHANGE_TYPE=>ContactChangeEventHandler.TEST_GAP_DELETE_MSG,
        accc_CDCEventBase.CDC_GAPUNDELETE_CHANGE_TYPE=>ContactChangeEventHandler.TEST_GAP_UNDELETE_MSG,
        accc_CDCEventBase.CDC_GAPCREATE_CHANGE_TYPE=>ContactChangeEventHandler.TEST_GAP_CREATE_MSG

    };
    /*
     * Default fields that our event says changed
     */
    static final List<String> DEFAULT_CHANGED_FIELDS =  new List<String> { 'Phone'};

    /////////////////////////////////////////////////////////////////////////////////////////
    // Test Members
    /////////////////////////////////////////////////////////////////////////////////////////
    /*
     * @description: We are testing that the handlers are called. Iterate over the list of
     * handlers, invoked the handler ( which deciphers the change type of the event) and
     * calls the different handlers
     */
    @isTest
    static void testHandlers() {

        // assign
        final String EVENT_NAME = ContactChangeEvent.class.getName();

        // act
        for ( String changeType: ContactChangeEventHandlerTest.changeTypesInHandler.keySet() ) {
            ContactChangeEventHandler cceh = new ContactChangeEventHandler(ContactChangeEvent.class);

            // create a new CDC Header per change type
            cceh.header( ContactChangeEventHandlerTest.createEventBase(changeType,
                                                                       EVENT_NAME));
            /*
             * This method will look at the incoming event, process the event ( that is the event type created)
             * and call handle<operation>.
             *
             * Note: Another approach, is to create a test class (CUT) whereby we inherit from ContactChangeEventHandler
             * within this unit test and drive funcitonality testing via CUT.
             */
            Boolean result = cceh.handleEventMethod(new ContactChangeEvent ());
            //
            // assert
            //
            // expecting no issues to to handling the method
            system.assertEquals(true,result );
            // As you may recall, in the handle methods, we logged actions
            // now we are checking that the method went through ( as it is logged only in TESTING)
            system.assertEquals(true,accc_ApexUtilities.containsInTestLog(ContactChangeEventHandlerTest.changeTypesInHandler.get(changeType)));
        }
        // assert

        // Note, because we are going thru a method onAfterInsertChild calls (within it's loop)
        // the post processing WILL NOT BE CALLED
        system.assertEquals(false,accc_ApexUtilities.containsInTestLog(ContactChangeEventHandler.TEST_DONE_CALLED));

    }// end of testHandlers

    /*
     * @description: We are testing that the handlers are called. Iterate over the list of
     * handlers, invoked the handler ( which deciphers the change type of the event) and
     * calls the different handlers
     */
    @isTest
    static void testafterOnAfterInsertChild() {

        // assign
        final List<SObject> myRecords = new List<SObject> {
            new Contact()
        };
        ContactChangeEventHandler cceh = new ContactChangeEventHandler(ContactChangeEvent.class);

        // act
        cceh.onAfterInsertChild(myRecords);
        // assert

        // At the end of processing thru ALL the events we may want to perform
        // some post processing. In the testing we checked that it was called
        system.assertEquals(true,accc_ApexUtilities.containsInTestLog(ContactChangeEventHandler.TEST_DONE_CALLED));

    } // end of testafterOnAfterInsertChild

    /*
     * @description: We are testing that the events changed fields are correct in identifying
     * the chields that have changed in the event.
     */
    @isTest
    static void testdataHasChanged() {
        // assign
        ContactChangeEventHandler cceh = new ContactChangeEventHandler(ContactChangeEvent.class);
        // act
        for ( String data : ContactChangeEventHandler.STRINGS_OF_INTEREST) {
            // assert
            system.assertEquals (true,cceh.dataHasChanged (new Set<String> {data}));
        }
        // assert
        system.assertEquals(false,cceh.dataHasChanged(null));
        system.assertEquals(false,cceh.dataHasChanged(new Set<String>()));
    }// end of testdataHasChanged

    ////////////////////////////////////////////////////////////////////////////////////////
    // Private Methods
    ////////////////////////////////////////////////////////////////////////////////////////


    /**
     * @description we create a Contact change Event Header
     * @param changetype -- this is the different change types as discern by the event
     * @param entityname -- this is the event name,i.e., 'ContactChangeEvent'
     * @return EventBus.ChangeEventHeader
     **/
    static EventBus.ChangeEventHeader createEventBase(String changetype, string entityname) {
        return createEventBase(changetype,entityname,DEFAULT_CHANGED_FIELDS);
    } // end of createEventBase

    /**
     * @description we create a change Event Header
     * @param changetype -- this the different change types as discern by the event
     * @param entityname -- this is the event name,i.e., 'ContactChangeEvent'
     * @param changedFields-- the field names that changed
     * @return EventBus.ChangeEventHeader
     **/
    static EventBus.ChangeEventHeader createEventBase(String changetype
                                                      ,string entityname
                                                      ,List<String> changedFields) {
        EventBus.ChangeEventHeader result = new EventBus.ChangeEventHeader();

        result.changeOrigin = accc_CDCEventBase.FOR_TEST_CHANGE_ORIGIN_NAME;
        result.setChangeType(changetype);
        result.commitnumber = 1;
        result.committimestamp = DateTime.now().getTime();
        result.commituser = UserInfo.getUserId();
        result.entityname = entityname;
        result.recordids = new List<String> {
            '005000200000001',
            '005000200000002'
        };

        // only for updates
        if ( changetype == accc_CDCEventBase.CDC_UPDATE_CHANGE_TYPE
             || changetype == accc_CDCEventBase.CDC_GAPUPDATE_CHANGE_TYPE) {
            result.changedFields = new List<String>(changedFields);
        }
        result.sequencenumber = 1;
        result.transactionkey = accc_ApexUtilities.newGuid();

        return result;
    } // end of createEventBase

}// end of ContactChangeEventHandlerTest
