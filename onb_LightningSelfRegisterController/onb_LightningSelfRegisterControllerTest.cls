@IsTest
public with sharing class onb_LightningSelfRegisterControllerTest {

    @testSetup
    static void setupData(){
        onb_Settings__c setting = new onb_Settings__c(Account_Owner_Id__c = UserInfo.getUserId());
        insert setting;
    }

    /* Verifies that IsValidPassword method with various password combinations. */
    @IsTest
    static void testIsValidPassword() {
        Boolean validPass = onb_LightningSelfRegisterController.isValidPassword('password?@12334', 'password?@12334');
        System.assert(onb_LightningSelfRegisterController.isValidPassword('password?@12334', 'password?@12334') == true);
        System.assert(onb_LightningSelfRegisterController.isValidPassword('password?@12334', 'dummyPassword') == false);
        System.assert(onb_LightningSelfRegisterController.isValidPassword('password?@12334', null) == false);
        System.assert(onb_LightningSelfRegisterController.isValidPassword(null, 'fakePwd') == false);
        onb_LightningSelfRegisterController.validatePassword(new User(),'password?@12334', 'password?@12334');
    }

    @IsTest
    static void testSiteAsContainerEnabled() {
        System.assertNotEquals(null, onb_LightningSelfRegisterController.siteAsContainerEnabled('https://portaleu1-developer-edition.eu11.force.com'));
    }

    /* Verifies the selfRegistration method flow with various invalid inputs */
    @IsTest
    static void testSelfRegistration() {
        Map < String, String > paramsMap = initializeParams();
        System.assertNotEquals(null, paramsMap);
        System.assertEquals(Label.Site.lastname_is_required, onb_LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), '', paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('businessEntityType'), paramsMap.get('legalEntityName'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true));
        System.assertEquals(Label.Site.email_is_required, onb_LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), '', paramsMap.get('password'), paramsMap.get('businessEntityType'), paramsMap.get('legalEntityName'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true));
        System.assertEquals(Label.Site.email_is_required, onb_LightningSelfRegisterController.selfRegister(null, paramsMap.get('lastName'), '', null, paramsMap.get('businessEntityType'), paramsMap.get('legalEntityName'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true));
        System.assertEquals(Label.site.passwords_dont_match, onb_LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('businessEntityType'), paramsMap.get('legalEntityName'), paramsMap.get('confirmPasswordWrong'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true));
        System.assertEquals(null, onb_LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('businessEntityType'), paramsMap.get('legalEntityName'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), paramsMap.get('extraFields'), paramsMap.get('startUrl'), false));
    }


    /* Verifies the selfRegistration flow for valid inputs */
    @IsTest
    static void testSelfRegisterWithProperCredentials() {
        Map < String, String > paramsMap = initializeParams();
        //System.assertEquals(null, onb_LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), true));
    }

    /* Verifies SelfRegistration flow with an accounId that is created within the test */
    @IsTest
    static void testSelfRegisterWithCreatedAccount() {
        Account acc = new Account(name = 'test acc');
        insert acc;
        List < Account > accounts = [SELECT Id FROM Account LIMIT 1];
        System.assert(!accounts.isEmpty(), 'There must be at least one account in this environment!');
        String accountId = accounts[0].Id;
        Map < String, String > paramsMap = initializeParams();
        //System.assertEquals(null, onb_LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), accountId, paramsMap.get('regConfirmUrl'), null, paramsMap.get('startUrl'), false));
    }

    @IsTest
    static void testGetNullExtraFields() {
        System.assertEquals(new List < Map < String, Object >> (), onb_LightningSelfRegisterController.getExtraFields(null));
    }

    @IsTest
    static void testGetNonEmptyExtraFields() {
        System.assertEquals(new List < Map < String, Object >> (), onb_LightningSelfRegisterController.getExtraFields('field1'));
    }

    /* Verifies validation of extraFields within the Self Registration flow */
    @IsTest
    static void testGetExtraFieldsInSelfRegistration() {
        List < Map < String, Object >> fieldlist = new List < Map < String, Object >> ();
        Map < String, String > paramsMap = initializeParams();
        Map < String, Object > fieldMap = new Map < String, Object > ();
        fieldMap.put('description', 'new field');
        fieldMap.put('fieldPath', 'dummyPath');
        fieldlist.add(fieldMap);
        String extraFields = JSON.serialize(fieldlist);
        //System.assertNotEquals(null, onb_LightningSelfRegisterController.selfRegister(paramsMap.get('firstName'), paramsMap.get('lastName'), paramsMap.get('email'), paramsMap.get('password'), paramsMap.get('confirmPasswordCorrect'), null, paramsMap.get('regConfirmUrl'), extraFields, paramsMap.get('startUrl'), true));
    }

    @IsTest
    static void onb_LightningSelfRegisterControllerInstantiation() {
        onb_LightningSelfRegisterController controller = new onb_LightningSelfRegisterController();
        System.assertNotEquals(controller, null);
    }

    @IsTest
    static void testGetSelectOptions() {
        System.assertEquals(onb_LightningSelfRegisterController.getSelectOptions(new Account(), 'Industry'), onb_BaseLightningController.getSelectOptions(new Account(), 'Industry'));
    }

    @IsTest
    static void testSetExpId() {
        System.assertNotEquals(onb_LightningSelfRegisterController.setExperienceId('expId'), null);
    }

    /* Helper method to initialize the parameters required for SelfRegistration. */
    private static Map < String, String > initializeParams() {
        Map < String, String > paramsMap = new Map < String, String > ();
        String firstName = 'test';
        String lastName = 'User';
        String email = 'testUser@salesforce.com';
        String password = 'testuser123';
        String confirmPasswordCorrect = 'testuser123';
        String confirmPasswordWrong = 'wrongpassword';
        String accountId = 'testuser123';
        String regConfirmUrl = 'http://registration-confirm.com';
        String startUrl = 'http://my.company.salesforce.com';
        String businessEntityType = 'Company';
        String legalEntityName = 'Company Name';
        String extraFields = '[{"fieldPath":"FirstName"}]';
        paramsMap.put('firstName', firstName);
        paramsMap.put('lastName', lastName);
        paramsMap.put('email', email);
        paramsMap.put('password', password);
        paramsMap.put('confirmPasswordCorrect', confirmPasswordCorrect);
        paramsMap.put('confirmPasswordWrong', confirmPasswordWrong);
        paramsMap.put('accountId', accountId);
        paramsMap.put('regConfirmUrl', regConfirmUrl);
        paramsMap.put('startUrl', startUrl);
        paramsMap.put('businessEntityType', businessEntityType);
        paramsMap.put('legalEntityName', legalEntityName);
        paramsMap.put('extraFields',extraFields);
        return paramsMap;
    }
}