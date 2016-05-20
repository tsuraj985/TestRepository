@isTest
private class UCFBWithLoginControllerTest {
  /*----------------------------------   /  Test method related to Position object / --------------------------------------------*/
    static testMethod void ControllerTest() {

        String RecordTypeId;
        RecordType strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Business Account'];
        //String RecordTypeIdApplicant;
        RecordType strRecordTypeIdApplicant = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Applicant'];
       
       List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.RecordTypeId = strRecordTypeId.Id;
        acc.Name = 'Test Account';
        acc.Full_Address__c = 'Test address for the account';

        Account acc1 = new Account();
        acc1.RecordTypeId = strRecordTypeIdApplicant.Id;
        acc1.LastName = 'Test Account1';
        acc1.Full_Address__c = 'Test address for the account';
        accList.add(acc);
        accList.add(acc1);
        insert accList;
        
        ApexPages.currentPage().getParameters().put('accId',acc1.Id);
        String id = ApexPages.currentPage().getParameters().get('accId');
        //Test.setCurrentPage(UCFBWithLogin2);   
        //ApexPages.currentPage().getParameters().put('id', acc1.Id);

        List<Position__c> positionList = new List<Position__c>();
            Position__c P = new Position__c(Name = 'TestName1', Brief_Description_of_Duties__c = 'abcdefgh', 
            				Salary__c = 2000, Start_Date__c = System.Today()+1, Application_Deadline__c = System.Today(), Key_Responsibilities__c = 'ijklmnop', Experience_Required__c = 'xyzabcdssmm'
            				, Paid_Unpaid__c = 'Paid', Url__c = 'www.google.com', Company__c = acc.Id, End_Date__c=date.Today(), IsActive__c=True);
            positionList.add(p);
            Position__c P2 = new Position__c(Name = 'TestName2', Brief_Description_of_Duties__c = 'abcdefgh', 
            				Salary__c = 2000, Start_Date__c = System.Today()+1, Application_Deadline__c = System.Today(), Key_Responsibilities__c = 'ijklmnop', Experience_Required__c = 'xyzabcdssmm', 
            				Paid_Unpaid__c = 'Paid', Url__c = 'www.google.com', Company__c = acc.Id, End_Date__c=date.Today()-40, IsActive__c=True);
            positionList.add(p2);
       insert positionList;

       List<Job_Application__c> applicationList = new List<Job_Application__c>();
            Job_Application__c Application = new Job_Application__c(Company__c=acc.Id, Position__c=P.Id, Applicant_Name__c=acc1.Id, IsActive__c= TRUE);
            applicationList.add(Application);
            Job_Application__c Application2 = new Job_Application__c(Company__c=acc.Id, Position__c=P.Id, Applicant_Name__c = id, IsActive__c=TRUE);
            applicationList.add(Application2);
       insert applicationList;
    
    Attachment attach3=new Attachment();     
     attach3.Name='Unit Test Attachment 3';
     Blob bodyBlob3=Blob.valueOf('Unit Test Attachment Body 3');
     attach3.body=bodyBlob3;
       attach3.parentId=Application.id;
       insert attach3;

    Attachment attach2=new Attachment();     
     attach2.Name='Unit Test Attachment 2';
     Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body 2');
     attach2.body=bodyBlob2;
       attach2.parentId=Application2.id;
       insert attach2;   
       
    Attachment attach=new Attachment();   	
	   attach.Name='Unit Test Attachment';
	   Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
	   attach.body=bodyBlob;
       attach.parentId=P.id;
       insert attach;

    	
       Attachment attach1=new Attachment();   	
	   attach1.Name='Unit Test Attachment';
	   Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body of attachment');
	   attach1.body=bodyBlob1;
       attach1.parentId=P2.id;
       insert attach1;
           	
       List<Attachment> attachments=[select id, name from Attachment where parent.id=:P.id];
       System.assertEquals(1, attachments.size());
    	
       List<Attachment> att=[select id, name from Attachment where parent.id=:P2.id];
       System.assertEquals(1, att.size());

       UCFBWithLoginController obj = new UCFBWithLoginController();
       UCFBWithLoginController.getCareers();
       UCFBWithLoginController.deleteTheApp(P.Id,acc1.Id);
       UCFBWithLoginController.createApplicationObj(attach3.Name, attach3.ContentType, EncodingUtil.base64Encode(attach3.Body), 'Test Job', 'Test Description', (String)P.Id, (String)acc1.Id, (String)acc.Id);
       UCFBWithLoginController.createReAttachment(attach3.ContentType, EncodingUtil.base64Encode(attach3.Body), (String)Application2.Id);
       UCFBWithLoginController.getPositionAttachments();
       UCFBWithLoginController.updateListToBeUpdated();
       UCFBWithLoginController.getAllJobApplications();
       UCFBWithLoginController.getJobApplicationAttachments(); 
        /*----------------------------------   /  Test method related to Position object / --------------------------------------------*/
    } 

     /*----------------------------------   /  Test method related to Complementary Courses object / --------------------------------------------*/ 
    static testMethod void ControllerCoursesTest() {

        String RecordTypeId;
        RecordType strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Business Account'];
        //String RecordTypeIdApplicant;
        RecordType strRecordTypeIdApplicant = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Applicant'];
       
       List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.RecordTypeId = strRecordTypeId.Id;
        acc.Name = 'Test Account';
        acc.Full_Address__c = 'Test address for the account';

        Account acc1 = new Account();
        acc1.RecordTypeId = strRecordTypeIdApplicant.Id;
        acc1.LastName = 'Test Account1';
        acc1.Full_Address__c = 'Test address for the account';
        accList.add(acc);
        accList.add(acc1);
        insert accList;
        
        ApexPages.currentPage().getParameters().put('accId',acc1.Id);
        String id = ApexPages.currentPage().getParameters().get('accId');
        
        List<Complimentary_Curriculum__c> positionList = new List<Complimentary_Curriculum__c>();
            Complimentary_Curriculum__c P = new Complimentary_Curriculum__c(Name = 'TestName1', End_Date__c=date.Today(), IsActive__c=True);
            positionList.add(p);
            Complimentary_Curriculum__c P2 = new Complimentary_Curriculum__c(Name = 'TestName2', End_Date__c=date.Today()-40, IsActive__c=True);
            positionList.add(p2);
       insert positionList;
       
     Attachment attach3=new Attachment();     
     attach3.Name='Profile Picture';
     Blob bodyBlob3=Blob.valueOf('Unit Test Attachment Body 3');
     attach3.body=bodyBlob3;
       attach3.parentId=acc1.id;
       insert attach3;

    Attachment attach2=new Attachment();     
     attach2.Name='Profile Picture';
     Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body 2');
     attach2.body=bodyBlob2;
       attach2.parentId=acc1.id;
       insert attach2;   

     Attachment attach=new Attachment();     
     attach.Name='Unit Test Attachment';
     Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
     attach.body=bodyBlob;
       attach.parentId=P.id;
       insert attach;

      
     Attachment attach1=new Attachment();     
     attach1.Name='Unit Test Attachment';
     Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body of attachment');
     attach1.body=bodyBlob1;
       attach1.parentId=P2.id;
       insert attach1;
            
       List<Attachment> attachments=[select id, name from Attachment where parent.id=:P.id];
       System.assertEquals(1, attachments.size());
      
       List<Attachment> att=[select id, name from Attachment where parent.id=:P2.id];
       System.assertEquals(1, att.size());

        List<Course_Registration__c> applicationList = new List<Course_Registration__c>();
            Course_Registration__c Application = new Course_Registration__c(Course_Name__c=P.Id, Account__c=acc1.Id, IsActive__c= TRUE);
            applicationList.add(Application);
            Course_Registration__c Application2 = new Course_Registration__c(Course_Name__c=P2.Id, Account__c = id, IsActive__c=TRUE);
            applicationList.add(Application2);
       insert applicationList;

       UCFBWithLoginController.getAllCourses();
       UCFBWithLoginController.getAllAccounts();
       UCFBWithLoginController.getAccountAttachments();
       UCFBWithLoginController.getCoursesAttachments();
       UCFBWithLoginController.getAllRegistration();
       UCFBWithLoginController.createCourseRecord(p2.Id,id);
       UCFBWithLoginController.deleteTheComp(p.Id,acc1.Id);
        /*----------------------------------   /  Test method related to Complementary Courses object / --------------------------------------------*/ 
    }

    /*----------------------------------   /  Test method related to Guest Speakers object / --------------------------------------------*/

     static testMethod void ControllerSpeakersTest() {

        String RecordTypeId;
        RecordType strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Business Account'];
        //String RecordTypeIdApplicant;
        RecordType strRecordTypeIdApplicant = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Applicant'];
       
       List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.RecordTypeId = strRecordTypeId.Id;
        acc.Name = 'Test Account';
        acc.Full_Address__c = 'Test address for the account';

        Account acc1 = new Account();
        acc1.RecordTypeId = strRecordTypeIdApplicant.Id;
        acc1.LastName = 'Test Account1';
        acc1.Full_Address__c = 'Test address for the account';
        accList.add(acc);
        accList.add(acc1);
        insert accList;
        
        ApexPages.currentPage().getParameters().put('accId',acc1.Id);
        String id = ApexPages.currentPage().getParameters().get('accId');

        List<Guest_speaker__c> positionList = new List<Guest_speaker__c>();
            Guest_speaker__c P = new Guest_speaker__c(Name = 'TestName1', End_Date__c=date.Today(), IsActive__c=True, Number_of_registration_allowed__c = 20);
            positionList.add(p);
            Guest_speaker__c P2 = new Guest_speaker__c(Name = 'TestName2', End_Date__c=date.Today()-40, IsActive__c=True, Number_of_registration_allowed__c = 20);
            positionList.add(p2);
       insert positionList;
       
       
     Attachment attach=new Attachment();     
     attach.Name='Unit Test Attachment';
     Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
     attach.body=bodyBlob;
     attach.parentId=P.id;
     insert attach;

      
     Attachment attach1=new Attachment();     
     attach1.Name='Unit Test Attachment';
     Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body of attachment');
     attach1.body=bodyBlob;
       attach1.parentId=P2.id;
       insert attach1;
            
       List<Attachment> attachments=[select id, name from Attachment where parent.id=:P.id];
       System.assertEquals(1, attachments.size());
      
       List<Attachment> att=[select id, name from Attachment where parent.id=:P2.id];
       System.assertEquals(1, att.size());

        List<Event_Registration__c> applicationList = new List<Event_Registration__c>();
            Event_Registration__c Application = new Event_Registration__c(Guest_Speaker__c=P.Id, Account__c=acc1.Id, IsActive__c= TRUE);
            applicationList.add(Application);
            Event_Registration__c Application2 = new Event_Registration__c(Guest_Speaker__c=P2.Id, Account__c = id, IsActive__c=TRUE);
            applicationList.add(Application2);
       insert applicationList;

       UCFBWithLoginController.getAllGuestspeakers();
       UCFBWithLoginController.getAllEvents();
       UCFBWithLoginController.createEventObject(p2.Id,id);
       UCFBWithLoginController.deleteTheReg(P.Id,acc1.Id);
       UCFBWithLoginController.getSpeakerAttachments();
       UCFBWithLoginController.getEmploymentStatus();
       /*----------------------------------   /  Test method related to Guest Speakers object / --------------------------------------------*/
    } 
    /*----------------------------------   /  Test method related to Downloadable Resources object / --------------------------------------------*/ 
    static testMethod void ControllerResourcesTest() {
      List<Resources__c> ResourceList = new List<Resources__c>();
      Resources__c Resource = new Resources__c(Name = 'Test Resource');
      ResourceList.add(Resource);  
      Resources__c Resource1 = new Resources__c(Name = 'Test Resource');
      ResourceList.add(Resource1);
      insert ResourceList;
      UCFBWithLoginController.getAllResource();
       UCFBWithLoginController.getStillWantingWork();
        UCFBWithLoginController.getMailingCountry();
        UCFBWithLoginController.getMailingState();
        UCFBWithLoginController.getAccountLocation();
      
     Attachment attach=new Attachment();     
     attach.Name='Unit Test Attachment';
     Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
     attach.body=bodyBlob;
     attach.parentId=Resource.id;
     insert attach;

      
     Attachment attach1=new Attachment();     
     attach1.Name='Unit Test Attachment';
     Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body of attachment');
     attach1.body=bodyBlob;
     attach1.parentId=Resource1.id;
     insert attach1;
     UCFBWithLoginController.getResourceAttachments();
     UCFBWithLoginController.getEmploymentType();
     UCFBWithLoginController.getAllIndustry();
     UCFBWithLoginController.getAllEmploymentStatus();
     UCFBWithLoginController.getAllEmploymentType();
     UCFBWithLoginController.getJobExpectationsMet();

      List<file__c> fileList = new List<file__c>();
      file__c files = new file__c(Name = 'Test files', resource__c=Resource.Id, IsActive__c = True);
      fileList.add(files);  
      file__c files1 = new file__c(Name = 'Test files1', resource__c=Resource.Id,IsActive__c = True);
      fileList.add(files1);
      insert fileList;
      UCFBWithLoginController.getAllFiles();
      UCFBWithLoginController ctrl=new UCFBWithLoginController();
      List<SelectOption> selOpts = ctrl.getTimings();
      List<SelectOption> selReasons = ctrl.getReason();

      ctrl.ReasonOfMeeting='test';
      ctrl.Bookings='test';
     
     Attachment attach2=new Attachment();     
     attach2.Name='Unit Test Attachment';
     Blob bodyBlob3=Blob.valueOf('Unit Test Attachment Body');
     attach2.body=bodyBlob3;
     attach2.parentId=files.id;
     insert attach2;

      
     Attachment attach3=new Attachment();     
     attach3.Name='Unit Test Attachment';
     Blob bodyBlob4=Blob.valueOf('Unit Test Attachment Body of attachment');
     attach3.body=bodyBlob4;
     attach3.parentId=files1.id;
     insert attach3;
     UCFBWithLoginController.getfilesAttachments();
     UCFBWithLoginController.getAllReasonsList();
     UCFBWithLoginController.getIndustry();
     UCFBWithLoginController.getEmploymentLevel();
    /*----------------------------------   /  Test method related to Downloadable Resources object / --------------------------------------------*/ 
    }
    /*----------------------------------   /  Test method related to Booking object / --------------------------------------------*/
    static testMethod void ControllerBookingTest() {
       RecordType strRecordTypeIdApplicant = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Applicant'];
       Account acc1 = new Account();
        acc1.RecordTypeId = strRecordTypeIdApplicant.Id;
        acc1.LastName = 'Test Account1';
        acc1.PersonMobilePhone = '54897521';
        acc1.PersonEmail = 'test@gmail.com';
        acc1.PersonOtherPhone = '879456321';
        acc1.Current_Location_of_Study__pc = 'Wembley';
        acc1.Full_Address__c = 'Test address for the account';
        insert acc1;

       ApexPages.currentPage().getParameters().put('accId',acc1.Id);
       String id = ApexPages.currentPage().getParameters().get('accId');
       
       UCFBWithLoginController.saveAccDetails(acc1.Id, acc1.PersonMobilePhone, acc1.PersonOtherPhone, acc1.Full_Address__c);
       
       List<Booking__c> bookingList = new List<Booking__c>();
            Booking__c book = new Booking__c(Date__c=date.Today()+1, IsAvaialble__c = FALSE, Account__c=id, Location__c=acc1.Current_Location_of_Study__pc);
            bookingList.add(book);
            Booking__c book2 = new Booking__c();
              book2.Date__c=date.Today()+2;
              book2.Email__c=acc1.PersonEmail;
              book2.Reason_for_Meeting__c='Job Application';
              book2.Time__c='09:30 - 10:00';
              book2.Account__c=id;
              book2.IsAvaialble__c = FALSE;
              book2.Location__c=acc1.Current_Location_of_Study__pc;
            bookingList.add(book2);
       insert bookingList;
       //UCFBWithLoginController.bookMeetingCtrl();
       UCFBWithLoginController.getRelatedBookings();
       UCFBWithLoginController.getAllBookingsDates();
       UCFBWithLoginController.deleteTheBook(book2.Id,acc1.Id);
       UCFBWithLoginController.getAllTimingsList();
       UCFBWithLoginController.getAllEmploymentLevel();
       UCFBWithLoginController.validateMettingsToday(acc1.Id);
       //UCFBWithLoginController.getAllTimingsBooked('2', acc1.Id);
     /*----------------------------------   /  Test method related to Booking object / --------------------------------------------*/ 
    }
    /*----------------------------------   /  Test method related to Employment History object / --------------------------------------------*/
    static testMethod void ControllerEmployementTest() {
        RecordType strRecordTypeIdApplicant = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Applicant'];
        Account acc1 = new Account();
        acc1.RecordTypeId = strRecordTypeIdApplicant.Id;
        acc1.LastName = 'Test Account1';
        acc1.Current_Location_of_Study__pc = 'Wembley';
        acc1.Full_Address__c = 'Test address for the account';
        insert acc1;

        String RecordTypeId;
        RecordType strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Business Account'];
        Account acc = new Account();
        acc.RecordTypeId = strRecordTypeId.Id;
        acc.Name = 'Test Account';
        acc.Full_Address__c = 'Test address for the account';
        insert acc;

        ApexPages.currentPage().getParameters().put('accId',acc1.Id);
        String id = ApexPages.currentPage().getParameters().get('accId');
        
        List<Alumni_Employment_History__c> employmentList = new List<Alumni_Employment_History__c>();
            Alumni_Employment_History__c employ = new Alumni_Employment_History__c(Account_Name__c=id);
            employmentList.add(employ);
            Alumni_Employment_History__c employ2 = new Alumni_Employment_History__c(Account_Name__c=id);
            employmentList.add(employ2);
        insert employmentList;
        UCFBWithLoginController.getAllEmploymentHistory();
        UCFBWithLoginController.getAllEmploymentHistoryNew(acc1.Id);
        UCFBWithLoginController.deleteEmpHistory(employ2.Id);
        //UCFBWithLoginController.getAllEmploymentHistoryNew(acc1.Id, 'test Company', 'Company Region', );
        RecordType TopTypeId = [Select Id From RecordType Where SobjectType = 'Top_Menu__c' and Name = 'Page'];
        Top_Menu__c TM = new Top_Menu__c();
        TM.RecordTypeId = TopTypeId.Id;
        TM.Name = 'Test Menu';
        insert TM;
        UCFBWithLoginController.getAllTopMenus();

        RecordType SectionTypeId = [Select Id From RecordType Where SobjectType = 'Top_Menu__c' and Name = 'Section'];
        Top_Menu__c TM1 = new Top_Menu__c();
        TM1.RecordTypeId = SectionTypeId.Id;
        TM1.Name = 'Test Section';
        insert TM1;
        UCFBWithLoginController.getAllSections();

        List<Sub_Menu__c> menuList = new List<Sub_Menu__c>();
        for(integer i=1; i<10; i++) {
          Sub_Menu__c SM = new Sub_Menu__c();
          SM.Name = 'Test Submenu' +i;
          menuList.add(SM);  
        }
        insert menuList;
        UCFBWithLoginController.getAllSubMenus();

    }
    /*----------------------------------   /  Test method related to Employment History object / --------------------------------------------*/

    /*----------------------------------   /  Test method related to Account object / --------------------------------------------*/
     static testMethod void AccountDetailTest() {
        //UCFBWithLoginController.encrypt('password');
        RecordType strRecordTypeIdApplicant = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Applicant'];
        List<Account> accList = new List<Account>();
        Account acc1 = new Account();
        acc1.RecordTypeId = strRecordTypeIdApplicant.Id;
        acc1.LastName = 'Test Account1';
        acc1.PersonEmail = 'testemail@gmail.com';
        acc1.UCFB_ID__pc = 'AFGSFD4561';
        //acc1.password__c = 'tetsLogin';
        acc1.Student_Status__pc = 'Active';
        acc1.End_Date_at_UCFB__pc = System.today();
        acc1.IsSiteEnable__c = TRUE;
        acc1.Current_Location_of_Study__pc = 'Wembley';
        acc1.Full_Address__c = 'Test address for the account';
        accList.add(acc1);

        Account acc = new Account();
        acc.RecordTypeId = strRecordTypeIdApplicant.Id;
        acc.LastName = 'Test Account123';
        acc.PersonEmail = 'testemail@gmail.com';
        acc.UCFB_ID__pc = 'SFD456145';
        //acc.password__c = 'tetsLogin';
        acc1.Student_Status__pc = 'Graduated';
        acc1.End_Date_at_UCFB__pc = System.today().addYears(3);
        acc.IsSiteEnable__c = TRUE;
        acc.Current_Location_of_Study__pc = 'Wembley';
        acc.Full_Address__c = 'Test address for the account';
        acclist.add(acc);
        insert accList;

        UCFBWithLoginController.findEmailAddress(acc1.PersonEmail);
        UCFBWithLoginController.findUCFBId(acc.UCFB_ID__pc);
        UCFBWithLoginController.statusOfAccount(acc.Id);
        UCFBWithLoginController.checkFirstTimeLoginOrNot(acc1.Id);
        UCFBWithLoginController.setChangePassword((string)acc1.Id, 'testnkasn');

        Login_History__c history = new Login_History__c();
        history.Name = acc1.Name;
        history.Account_Name__c = acc1.Id;
        insert history;
        UCFBWithLoginController.statusOfAccount(acc.Id);
        UCFBWithLoginController.createLoginHistoryRecordFailed(acc.Id, 'sudbbdsduudbd');
        UCFBWithLoginController.getStaticSessionId();
        UCFBWithLoginController.createLoginHistoryRecord((string)acc1.Id);
        UCFBWithLoginController.getSessionKey();
        UCFBWithLoginController.getSessionValue();

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testmethod@test.com');

        System.runAs(u) {
          // The following code runs as user 'u' 
          System.debug('Current User: ' + UserInfo.getUserName());
          System.debug('Current Profile: ' + UserInfo.getProfileId()); 
          UCFBWithLoginController.getAllUsers();
        }
     }     
}