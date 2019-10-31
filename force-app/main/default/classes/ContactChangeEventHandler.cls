/**
 * @File Name          : ContactChangeEventHandler.cls
 *
 * @Description        : This example shows how one can handle Change Data Events for Contacts. It shows the HOOKs
 *                       within the framework. The steps are listed below along with markers (i.e STEP 1, etc.).
 *                       In addition, you will see benefits of applying SOLID Principiles to your development practice.
 *
 * In this example, the requirement is to be aware of changes (CRUD) to SPECIFIC fields when changed in a
 * Contact; namely,
 *
 *      => 'FirstName',
 *      => 'LastName',
 *      => 'Email',
 *      => 'Phone'
 *
 * Second, we perform different actions upon Update, Delete, Undelete, Create, etc.
 *
 *   Given what we know, we will do the following:
 *         1) Create a child class, 'ContactChangeEventHandler' that inherits from
 *            the parent class of CDC, 'accc_CDCEventBase'
 *         2) Use the Trigger Handler to have the handler invoked
 *         3) Create a List of Fields we are interested in when an UPDATE occurs
 *            a) Create a method to check for Updates
 *         4) Only handle changes/updates on certain fields.
 *         5) Put hooks to test invocations
 *
 * CONSIDERATIONS: As you begin to go thru this example, you may realize some common funcitonality that could be
 * refactored into a specific BASE class that inherits from  'accc_CDCEventBase'. There are patterns abound; for example,
 * if ALL your CDC events have specific fields to react on, you could refactor into a base class which would then
 * pull the fields of interest from a custom metadata (based on the CDC event ). Then classes like this, would inherit
 * from your base class.
 *
 * GIVENS:
 *    + API version 47
 *    + ACCC version 1.0.1.1 (this include ACCC + PE + TH)
 *    + Trigger Handler (https://github.com/bjanderson70/sf-trigger-handling)
 *
 * NOTES:
 *    This simple example does not perform any exception handling (as there are none). If there
 *    are exceptions, these are already handled in the base class 'accc_CDCEventBase'.
 *
 *    However, there is a 'CAUSE_EXCEPTION' set to false. If you wanted to cause exception handling
 *    within YOUR code, then one would set 'CAUSE_EXCEPTION' in the unit test to true.
 *
 * @Author             : Bill Anderson
 * @Group              : CDC
 *
 * @Modification Log   :
 * Ver       Date            Author                 Modification
 * 1.0    10/28/2019   Bill Anderson     Initial Version
 **/

/*
 * STEP 1: We inherit from 'accc_CDCEventBase' and extend functionality
 */
public with sharing class ContactChangeEventHandler extends accc_CDCEventBase {

    ////////////////////////////////////////////////////////////////////////////////////////
    // DATA Members
    //
    ////////////////////////////////////////////////////////////////////////////////////////
    /**************************************************************************************
     * STEP 5 ....
     * START - Used for Testing
     */
    @TestVisible
    static final String CLASS_EVENT_NAME= 'ContactChangeEventHandler';
    @TestVisible
    static final String TEST_UPDATE_MSG = CLASS_EVENT_NAME + ' update called';
    @TestVisible
    static final String TEST_CREATE_MSG = CLASS_EVENT_NAME + ' create called';
    @TestVisible
    static final String TEST_DELETE_MSG = CLASS_EVENT_NAME + ' delete called';
    @TestVisible
    static final String TEST_UNDELETE_MSG= CLASS_EVENT_NAME + ' undelete called';
    @TestVisible
    static final String TEST_OTHER_MSG= CLASS_EVENT_NAME + ' other methods called';
    @TestVisible
    static final String TEST_GAP_UPDATE_MSG= CLASS_EVENT_NAME + ' GAPUpdate called';
    @TestVisible
    static final String TEST_GAP_CREATE_MSG= CLASS_EVENT_NAME + ' GAPCREATE called';
    @TestVisible
    static final String TEST_GAP_DELETE_MSG= CLASS_EVENT_NAME + ' GAPDelete called';
    @TestVisible
    static final String TEST_GAP_UNDELETE_MSG= CLASS_EVENT_NAME + ' GAPUnDelete called';
    @TestVisible
    static final String TEST_FIELD_CHANGE = CLASS_EVENT_NAME + ' FIELDS CHANGED';
    @TestVisible
    static final String TEST_DONE_CALLED = CLASS_EVENT_NAME + ' IS DONE';
    /*
     * Unit Tests will change this option as needed for exceptions handling tests
     */
    @TestVisible
    static Boolean CAUSE_EXCEPTION = false;
    /*
     * END - Used for Testing
     **************************************************************************************/
    /*
     * STEP 3 -- Fields one cares about
     */
    @TestVisible
    static final Set<String> STRINGS_OF_INTEREST =  new Set<String> {
        'FirstName',
        'LastName',
        'Email',
        'Phone'
    };

    ////////////////////////////////////////////////////////////////////////////////////////
    // Ctors
    //
    ////////////////////////////////////////////////////////////////////////////////////////

    //
    // NOTE: We Only define this ctor here for testing purpose
    //
    //
    /**
     * @description ContactChangeEventHandler passing in the type
     * @param the type of event
     */
    public ContactChangeEventHandler(Type theType) {
        super(theType);
    }// end of ctor

    ////////////////////////////////////////////////////////////////////////////////////////
    // Protected Methods
    //
    // NOTE: Methods below are overridden from the parent. These methods get called when a specific handler is
    // required for Create, Update, Delete, UnDelete, et. al. actions.
    ////////////////////////////////////////////////////////////////////////////////////////

    /**
     * @description parent calls us, after we finish iterating over the events in the on after insert child.
     *
     * @return void
     **/
    @TestVisible
    public  override void onAfterInsertChild(List<SObject> newItems) {
        /* STEP 5....
         * START - USE FOR TESTING
         */
        if( accc_ApexConstants.UNIT_TEST_RUNNING  ) {
            accc_ApexUtilities.log(TEST_DONE_CALLED);
        }
        //
        // Here do any cleanup you want. For example, as you iterate over the events
        // you may wish to send out a notification at the end of processing.
        // This is where you would perform that task
        //
    }// end of afterOnAfterInsertChild

    /**
     * @description child handle update
     * @param SObject event
     * @return void
     */
    @TestVisible
    protected override void handleUpdate(SObject event){
        /* STEP 5....
         * START - USE FOR TESTING
         */
        if( accc_ApexConstants.UNIT_TEST_RUNNING  ) {
            accc_ApexUtilities.log(TEST_UPDATE_MSG);
        }
        /*
         * END - USE FOR TESTING
         */
        // anything changed in fields
        if ( this.dataHasChanged(this.getFieldsChangedInUpdate(event).keySet())) {
            // User Specific Handling
            if( accc_ApexConstants.UNIT_TEST_RUNNING  ) {
                accc_ApexUtilities.log(TEST_FIELD_CHANGE);
            } else {
                //
                // NOTE: THIS IS WHERE YOU INJECT YOUR SPECIFIC CODE TO Handle Event
            }
        }
    }// end of handleUpdate

    /**
     * @description child handle create
     * @param SObject event
     * @return void
     */
    @TestVisible
    protected override void handleCreate(SObject event){
        /* STEP 5 ... .
         * START - USE FOR TESTING
         */
        if( accc_ApexConstants.UNIT_TEST_RUNNING  ) {
            accc_ApexUtilities.log(TEST_CREATE_MSG);
        }
        /*
         * END - USE FOR TESTING
         */

        //
        // NOTE: THIS IS WHERE YOU INJECT YOUR SPECIFIC CODE TO Handle Event
        //
    }// end of handleCreate

    /**
     * @description child to handle delete
     * @param SObject event
     * @return void
     */
    @TestVisible
    protected override void handleDelete(SObject event){
        /* STEP 5 ... .
         * START - USE FOR TESTING
         */
        if( accc_ApexConstants.UNIT_TEST_RUNNING  ) {
            accc_ApexUtilities.log(TEST_DELETE_MSG);
        }
        /*
         * END - USE FOR TESTING
         */

        //
        // NOTE: THIS IS WHERE YOU INJECT YOUR SPECIFIC CODE TO Handle Event
        //

    }// end of handleDelete

    /**
     * @description child handle undelete
     * @param SObject event
     * @return void
     */
    @TestVisible
    protected override void handleUndelete(SObject event){
        /* STEP 5 ... .
         * START - USE FOR TESTING
         */
        if( accc_ApexConstants.UNIT_TEST_RUNNING  ) {
            accc_ApexUtilities.log(TEST_UNDELETE_MSG);
        }
        /*
         * END - USE FOR TESTING
         */

        //
        // NOTE: THIS IS WHERE YOU INJECT YOUR SPECIFIC CODE TO Handle Event
        //
    }// end of handleUndelete

    /**
     * @description child handle GAP update
     * @param SObject event
     * @return void
     */
    @TestVisible
    protected override void handleGAPUpdate(SObject event){
        /* STEP 5 ... .
         * START - USE FOR TESTING
         */
        if( accc_ApexConstants.UNIT_TEST_RUNNING  ) {
            accc_ApexUtilities.log(TEST_GAP_UPDATE_MSG);
        }
        /*
         * END - USE FOR TESTING
         */
        // anything changed in fields
        if ( this.dataHasChanged(this.getFieldsChangedInUpdate(event).keySet())) {
            if( accc_ApexConstants.UNIT_TEST_RUNNING  ) {
                accc_ApexUtilities.log(TEST_FIELD_CHANGE);
            } else {
                //
                // NOTE: THIS IS WHERE YOU INJECT YOUR SPECIFIC CODE TO Handle Event
            }
        }
    }// end of handleGAPUpdate

    /**
     * @description child handle GAP create
     * @param SObject event
     * @return void
     */
    @TestVisible
    protected override void handleGAPCreate(SObject event){
        /* STEP 5 ... .
         * START - USE FOR TESTING
         */
        if( accc_ApexConstants.UNIT_TEST_RUNNING  ) {
            accc_ApexUtilities.log(TEST_GAP_CREATE_MSG);
        }
        /*
         * END - USE FOR TESTING
         */

        //
        // NOTE: THIS IS WHERE YOU INJECT YOUR SPECIFIC CODE TO Handle Event
        //
    }// end of handleGAPCreate

    /**
     * @description child to handle GAP delete
     * @param SObject event
     * @return void
     */
    @TestVisible
    protected override void handleGAPDelete(SObject event){
        /* STEP 5 ... .
         * START - USE FOR TESTING
         */
        if( accc_ApexConstants.UNIT_TEST_RUNNING  ) {
            accc_ApexUtilities.log(TEST_GAP_DELETE_MSG);
        }
        /*
         * END - USE FOR TESTING
         */

        //
        // NOTE: THIS IS WHERE YOU INJECT YOUR SPECIFIC CODE TO Handle Event
        //

    }// end of handleGAPDelete

    /**
     * @description child handle GAP undelete
     * @param SObject event
     * @return void
     */
    @TestVisible
    protected override void handleGAPUndelete(SObject event){
        /* STEP 5 ... .
         * START - USE FOR TESTING
         */
        if( accc_ApexConstants.UNIT_TEST_RUNNING  ) {
            accc_ApexUtilities.log(TEST_GAP_UNDELETE_MSG);
        }
        /*
         * END - USE FOR TESTING
         */

        //
        // NOTE: THIS IS WHERE YOU INJECT YOUR SPECIFIC CODE TO Handle Event
        //

    }// end of handleGAPUndelete

    ////////////////////////////////////////////////////////////////////////////////////////
    // Private Methods
    //
    ////////////////////////////////////////////////////////////////////////////////////////

    /** STEP 4....
     * @description has any of the the fields we are interested in changed?
     * @param changed set of changed fields, if any
     * @return boolean true, a change as occured.
     **/
    @TestVisible
    private boolean dataHasChanged(Set<String> changed) {
        // any work ?
        if ( changed == null || changed.isEmpty() ) {
            return false;
        }
        // copy the fields of interest
        Set<String> original =  new Set<String>(STRINGS_OF_INTEREST);
        // if a change in the original then we have a difference
        return original.removeAll(changed);
    } // end of dataHasChanged

}// end of ContactChangeEventHandler
