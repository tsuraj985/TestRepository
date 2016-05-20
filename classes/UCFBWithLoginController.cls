global without sharing class UCFBWithLoginController {
        
        public Date dat {get;set;}
        public Booking__c allBookings {get; set;}
        
    global class CareerWrap {
        //Static Variables
        global String Id, Name, url, Details, smallPhoto, Alias, Email, FullPhotoUrl, City, Status, Account, Position, Description, PositionName,PersonOtherPhone, EmploymentType, CompanyRegion, SubmenuName, SubmenuUrl,
                        CompanyName, Company, Country, Fax, FirstName, LastName, MobilePhone, ParentId, JobType, SpeakerName, guestSpeaker, Prerequisite, Reason, Room, EmploymentStatus, CourseId, PrerequisiteName,
                        Phone, PostalCode, Street, Key_Responsibilities, Experience_Required, Team, Designation, Biography, Presenter, AccountName, slot, Industry, EmploymentLevel, FullAddress, Type, SubMenu, CurrencyIsoCode,
                        Attachments, resourceId, EventDescription, GuestSpeakerBiography, CurrentCourse, EndTime, Campus, StartTime, Gender, Region, YearGroup, Location, LecturerName, AccountId, CourseName, StudentStatus, JobTitle, StillWantIndustry, JobExpectationsMet, PaidUnpaid;
        global Decimal Salary, registrationAllowed, studentRegistered;
        global Date DateSubmitted, ApplicationClosed, Deadline, StartDate, EndDate, eventStartDate, AppointmentDate, BookingDate, AvailableDate;
        global String TopMenu, CurrentAccountId;
        global DateTime GSDeadLine, CreatedDate, LastModifiedDate;
        global address  PersonMailingAddress,PersonOtherAddress;
        
        //Wrapper Class Controller
        CareerWrap() {
           url = '';
           TopMenu = '';
           Details = '';
           Salary= 0.0;
           smallPhoto = '';
           PersonOtherPhone = '';
           Phone = '';
        }
    }
    
    @RemoteAction
    global static String getSiteUrl() {
        String name = 'UCFBsite';
        Site site = [
            SELECT GuestUserId
            FROM Site
            WHERE Name = :name
        ];
        System.debug('--->>>>Site='+site);
        String path = '/sites/servlet.SiteDebugMode';
        PageReference pr = new PageReference(path);
        pr.getParameters().put('guid', site.GuestUserId);
        pr.getParameters().put('sitedebugmode', 'x');
        System.debug('<><><><><>pr='+pr);
        String url = pr.getContent().toString().substringAfter('URL=').substringBefore(path);
        System.debug('---<><><><-----'+pr.getContent().toString());
        return url;
    }
    
    @RemoteAction
    global static boolean checkAccIsCorrect(String accId) {
        List<Account> acc = [SELECT Id FROM Account WHERE Id =: accId];
        if(acc.size() > 0) {
            return true;
        }
        return false;
    }
    
    public PageReference setTheDateValue() {
        System.debug('--->>>>Date = ' + dat);
        return null;
    }
    
    global static String staticSessionId {get; set;}
    
    public UCFBWithLoginController() {
        staticSessionId = UserInfo.getSessionId();
    }
    
    @RemoteAction
    global static void createEventObject(String guestId, String accId) {
        Event_Registration__c eventObj = new Event_Registration__c();
        eventObj.Guest_Speaker__c = guestId;
        eventObj.Account__c = accId;
        eventObj.Status__c = 'Booked';
        eventObj.IsActive__c = TRUE;
        insert eventObj;
    }
    
    @RemoteAction
    global static void createCourseRecord(String CourseId, String accId){
        Course_Registration__c CourseRegistration = new Course_Registration__c();
        CourseRegistration.Account__c = accId;
        CourseRegistration.Course_Name__c = CourseId;
        CourseRegistration.Status__c = 'Booked';
        CourseRegistration.IsActive__c = TRUE;
        insert CourseRegistration;
    }
    
    
 
    
    
    @RemoteAction
    global static String getStaticSessionId() {
        return UserInfo.getSessionId();
    }
    
    @RemoteAction
    global static String getCareers() {
        List<CareerWrap> accWrapList = new List<CareerWrap>();
        List<Position__c> accList = [SELECT Id, Name, Brief_Description_of_Duties__c, Salary__c, Start_Date__c, Application_Deadline__c, Job_Type__c, Current_Course_of_Study__c
                                    , Key_Responsibilities__c, Experience_Required__c, Status__c, Campus__c, Gender__c, Students_Region__c, Year_Group__c, Company__c, Paid_Unpaid__c, Url__c, CurrencyIsoCode, End_Date__c
                                    FROM Position__c
                                    WHERE IsActive__c =: TRUE AND forActiveStudent__c =: True AND End_Date__c >=: (Date.today()-30)
                                    Order By CreatedDate];
        System.debug('>>>>>>>>>.---------'+accList);
        for (Position__c acc : accList) {
                CareerWrap accWrap = new CareerWrap();
                accWrap.Id = acc.Id;
                accWrap.Name = acc.Name;
                accWrap.Location = acc.Campus__c;
                accWrap.Gender = acc.Gender__c;
                accWrap.Region = acc.Students_Region__c;
                accWrap.YearGroup = acc.Year_Group__c;
                accWrap.CurrentCourse = acc.Current_Course_of_Study__c;
                accWrap.Status = acc.Status__c;
                accWrap.CompanyName = acc.Company__c; 
                accWrap.Details = acc.Brief_Description_of_Duties__c;
                accWrap.Salary = acc.Salary__c;
                accWrap.CurrencyIsoCode = acc.CurrencyIsoCode;
                accwrap.JobType = acc.Job_Type__c;
                accwrap.PaidUnpaid = acc.Paid_Unpaid__c;
                accWrap.Key_Responsibilities = acc.Key_Responsibilities__c;
                accWrap.Experience_Required = acc.Experience_Required__c;
                accWrap.DateSubmitted = acc.Start_Date__c; 
                accWrap.ApplicationClosed = acc.Application_Deadline__c;
                accWrap.url = acc.Url__c;
                accWrap.EndDate = acc.End_Date__c;
                accWrapList.add(accWrap);
                System.debug('/////////////'+accWrap);       
        }
        //updateListToBeUpdated(ListToBeUpdated);
        System.debug('<><><><><><>'+accWrapList);
        return JSON.serialize(accWrapList);
    }

    @RemoteAction
    global static String getAllPositionsGraduated() {
        List<CareerWrap> accWrapList = new List<CareerWrap>();
        List<Position__c> accList = [SELECT Id, Name, Brief_Description_of_Duties__c, Salary__c, Start_Date__c, Application_Deadline__c, Job_Type__c, Current_Course_of_Study__c
                                    , Key_Responsibilities__c, Experience_Required__c, Status__c, Campus__c, Gender__c, Students_Region__c, Year_Group__c, Company__c, Paid_Unpaid__c, Url__c, CurrencyIsoCode, End_Date__c
                                    FROM Position__c
                                    WHERE IsActive__c =: TRUE AND forGraduatedStudent__c =: True AND End_Date__c >=: (Date.today()-30)
                                    Order By CreatedDate];
        System.debug('>>>>>>>>>.---------'+accList);
        for (Position__c acc : accList) {
                CareerWrap accWrap = new CareerWrap();
                accWrap.Id = acc.Id;
                accWrap.Name = acc.Name;
                accWrap.Location = acc.Campus__c;
                accWrap.Gender = acc.Gender__c;
                accWrap.Region = acc.Students_Region__c;
                accWrap.YearGroup = acc.Year_Group__c;
                accWrap.CurrentCourse = acc.Current_Course_of_Study__c;
                accWrap.Status = acc.Status__c;
                accWrap.CompanyName = acc.Company__c; 
                accWrap.Details = acc.Brief_Description_of_Duties__c;
                accWrap.Salary = acc.Salary__c;
                accWrap.CurrencyIsoCode = acc.CurrencyIsoCode;
                accwrap.JobType = acc.Job_Type__c;
                accwrap.PaidUnpaid = acc.Paid_Unpaid__c;
                accWrap.Key_Responsibilities = acc.Key_Responsibilities__c;
                accWrap.Experience_Required = acc.Experience_Required__c;
                accWrap.DateSubmitted = acc.Start_Date__c; 
                accWrap.ApplicationClosed = acc.Application_Deadline__c;
                accWrap.url = acc.Url__c;
                accWrap.EndDate = acc.End_Date__c;
                accWrapList.add(accWrap);
                System.debug('/////////////'+accWrap);       
        }
        //updateListToBeUpdated(ListToBeUpdated);
        System.debug('<><><><><><>'+accWrapList);
        return JSON.serialize(accWrapList);
    }
    
    @RemoteAction
    global static void updateListToBeUpdated() {
        List<Position__c> accList = [SELECT Id
                                    FROM Position__c
                                    WHERE End_Date__c <: (Date.today()-30) AND IsActive__c =: TRUE
                                    Order By CreatedDate];
        System.debug('------------->>>>>>>>>>>>>>>>'+accList);
        List<Position__c> newList = new List<Position__c>();
        for(Position__c acc : accList) {
            acc.IsActive__c = FALSE;
            newList.add(acc);
        }
        if(newList.size() > 0) {
            update newList;
        }
    }
    
    @RemoteAction
    global static string getPositionAttachments() {
        List<CareerWrap> attachmentWrapList = new List<CareerWrap>();
        List<Position__c> ResourceList = [SELECT Name FROM Position__c];
         List<Id> ResourceIdList= new List<Id>();
        for(Position__c resourse : ResourceList) {
            ResourceIdList.add(resourse.Id);
        }        
        List <Attachment> attlist = [SELECT Name, ParentId FROM Attachment WHERE ParentId =: ResourceIdList Order by LastModifiedDate];
            for(Attachment att : attlist) {
            CareerWrap attachmentWrap = new CareerWrap();
            attachmentWrap.Id = att.Id;
            attachmentWrap.Name = att.Name;
            attachmentWrap.ParentId = att.ParentId;
            attachmentWrapList.add(attachmentWrap);
        }
        return JSON.serialize(attachmentWrapList);
    }
    
    @RemoteAction
      global static string getAllCourses() {
        List<CareerWrap> courseWrapList = new List<CareerWrap>();
        List<Complimentary_Curriculum__c> courseList = [SELECT Name, Deadline_to_sign_up__c, End_Date__c, Cost__c, Course_Description__c, Logo__c, Prerequisite_Course__c, Current_Course_of_Study__c, 
        Presenter_Biography__c, Presenter_name__c, Start_Date__c, Video_File__c, Campus__c, Gender__c, Region__c, Year_Group__c,  CurrencyIsoCode, Prerequisite_Course__r.Name, Start_Time__c, End_Time__c
        FROM Complimentary_Curriculum__c WHERE  IsActive__c =: TRUE AND forActiveStudent__c =: True];
        for (Complimentary_Curriculum__c c : courseList) {
            CareerWrap courseWrap = new CareerWrap();
            courseWrap.Id = c.Id;
            courseWrap.Name = c.Name;
            courseWrap.StartTime = c.Start_Time__c;
            courseWrap.Gender = c.Gender__c;
            courseWrap.Location = c.Campus__c;
            courseWrap.Region = c.Region__c;
            courseWrap.YearGroup = c.Year_Group__c;
            courseWrap.CurrentCourse = c.Current_Course_of_Study__c;
            courseWrap.EndTime = c.End_Time__c;
            courseWrap.CurrencyIsoCode = c.CurrencyIsoCode;
            courseWrap.Deadline = c.Deadline_to_sign_up__c;
            courseWrap.EndDate = c.End_Date__c;
            courseWrap.Salary = c.Cost__c;
            courseWrap.Description = c.Course_Description__c;
            courseWrap.smallPhoto = c.Logo__c;
            courseWrap.Prerequisite = c.Prerequisite_Course__c;
            courseWrap.PrerequisiteName = c.Prerequisite_Course__r.Name;
            courseWrap.Biography = c.Presenter_Biography__c;
            courseWrap.Presenter = c.Presenter_name__c;
            courseWrap.StartDate = c.Start_Date__c;
            courseWrap.url = c.Video_File__c;
            courseWrapList.add(courseWrap);
        }
        return JSON.serialize(courseWrapList);
    }
    
    @RemoteAction
      global static string getAllGraduatedCourses() {
        List<CareerWrap> courseWrapList = new List<CareerWrap>();
        List<Complimentary_Curriculum__c> courseList = [SELECT Name, Deadline_to_sign_up__c, End_Date__c, Cost__c, Course_Description__c, Logo__c, Prerequisite_Course__c, Current_Course_of_Study__c, 
        Presenter_Biography__c, Presenter_name__c, Start_Date__c, Video_File__c, Campus__c, Gender__c, Region__c, Year_Group__c,  CurrencyIsoCode, Prerequisite_Course__r.Name, Start_Time__c, End_Time__c
        FROM Complimentary_Curriculum__c WHERE  IsActive__c =: TRUE AND forGraduatedStudent__c =: True];
        for (Complimentary_Curriculum__c c : courseList) {
            CareerWrap courseWrap = new CareerWrap();
            courseWrap.Id = c.Id;
            courseWrap.Name = c.Name;
            courseWrap.StartTime = c.Start_Time__c;
            courseWrap.Gender = c.Gender__c;
            courseWrap.Location = c.Campus__c;
            courseWrap.Region = c.Region__c;
            courseWrap.YearGroup = c.Year_Group__c;
            courseWrap.CurrentCourse = c.Current_Course_of_Study__c;
            courseWrap.EndTime = c.End_Time__c;
            courseWrap.CurrencyIsoCode = c.CurrencyIsoCode;
            courseWrap.Deadline = c.Deadline_to_sign_up__c;
            courseWrap.EndDate = c.End_Date__c;
            courseWrap.Salary = c.Cost__c;
            courseWrap.Description = c.Course_Description__c;
            courseWrap.smallPhoto = c.Logo__c;
            courseWrap.Prerequisite = c.Prerequisite_Course__c;
            courseWrap.PrerequisiteName = c.Prerequisite_Course__r.Name;
            courseWrap.Biography = c.Presenter_Biography__c;
            courseWrap.Presenter = c.Presenter_name__c;
            courseWrap.StartDate = c.Start_Date__c;
            courseWrap.url = c.Video_File__c;
            courseWrapList.add(courseWrap);
        }
        return JSON.serialize(courseWrapList);
    }
      
    @RemoteAction
    global static string getCoursesAttachments() {
        List<CareerWrap> attachmentWrapList = new List<CareerWrap>();
        List<Complimentary_Curriculum__c> ResourceList = [SELECT Name FROM Complimentary_Curriculum__c];
         List<Id> ResourceIdList= new List<Id>();
        for(Complimentary_Curriculum__c resourse : ResourceList) {
            ResourceIdList.add(resourse.Id);
        }        
        List <Attachment> attlist = [SELECT Name, ParentId FROM Attachment WHERE ParentId =: ResourceIdList Order by LastModifiedDate];
            for(Attachment att : attlist) {
            CareerWrap attachmentWrap = new CareerWrap();
            attachmentWrap.Id = att.Id;
            attachmentWrap.Name = att.Name;
            attachmentWrap.ParentId = att.ParentId;
            attachmentWrapList.add(attachmentWrap);
        }
        return JSON.serialize(attachmentWrapList);
    }
    
            @RemoteAction
             global static string getAllRegistration() {
                List<CareerWrap> RegistrationWrapList = new List<CareerWrap>();
                List<Course_Registration__c> RegistrationList = [SELECT Account__c, Course_Name__c, Course_Name__r.Name, CreatedDate, Account__r.Current_Location_of_Study__pc 
                                                                                                                FROM Course_Registration__c 
                                                                                                                WHERE Account__c =: ApexPages.currentPage().getParameters().get('accId') AND IsActive__c =: TRUE];
                for (Course_Registration__c RL : RegistrationList) {
                    CareerWrap RegistrationWrap = new CareerWrap();
                    RegistrationWrap.Id = RL.Id;
                    RegistrationWrap.AccountId = RL.Account__c;
                    RegistrationWrap.CourseId = RL.Course_Name__r.Name;
                    RegistrationWrap.CourseName = RL.Course_Name__c;
                    RegistrationWrap.Location = RL.Account__r.Current_Location_of_Study__pc;
                    RegistrationWrap.CreatedDate = RL.CreatedDate;
                    RegistrationWrapList.add(RegistrationWrap);
                }
                return JSON.serialize(RegistrationWrapList);
            }
     @RemoteAction
     global static string getAllGuestspeakers() {
        List<CareerWrap> GuestspeakersWrapList = new List<CareerWrap>();
        List<Guest_speaker__c> GuestspeakersList = [SELECT Name, Picture_of_guest_speaker__c, Guest_Speaker_Biography__c, Event_Description__c, Campus__c, Gender__c, Region__c, Year_Group__c, 
                                                    Deadline_to_sign_up__c, Start_Date__c, End_Date__c, Number_of_registration_allowed__c, Students_Booked__c, Location__c, Current_Course_of_Study__c
                                                    FROM Guest_speaker__c 
                                                    WHERE  IsActive__c =: TRUE AND forActiveStudent__c =: True AND End_Date__c >: Date.today()-30 Order By End_Date__c ASC];
        for (Guest_speaker__c GS : GuestspeakersList) {
            CareerWrap GuestspeakersWrap = new CareerWrap();
            GuestspeakersWrap.Id = GS.Id;
            GuestspeakersWrap.Campus = GS.Campus__c;
            GuestspeakersWrap.Gender = GS.Gender__c;
            GuestspeakersWrap.Region = GS.Region__c;
            GuestspeakersWrap.YearGroup = GS.Year_Group__c;
            GuestspeakersWrap.CurrentCourse = GS.Current_Course_of_Study__c;
            GuestspeakersWrap.registrationAllowed = GS.Number_of_registration_allowed__c;
            GuestspeakersWrap.studentRegistered = GS.Students_Booked__c;
            GuestspeakersWrap.StartDate = GS.Start_Date__c;
            GuestspeakersWrap.Location = GS.Location__c; 
            GuestspeakersWrap.EndDate = GS.End_Date__c;
            GuestspeakersWrap.Name = GS.Name;
            GuestspeakersWrap.GSDeadLine = GS.Deadline_to_sign_up__c;
            GuestspeakersWrap.url = GS.Picture_of_guest_speaker__c;
            GuestspeakersWrap.GuestSpeakerBiography = GS.Guest_Speaker_Biography__c;
            GuestspeakersWrap.EventDescription = GS.Event_Description__c;
            GuestspeakersWrapList.add(GuestspeakersWrap);
        }
        return JSON.serialize(GuestspeakersWrapList);
    }

    @RemoteAction
     global static string getAllspeakersGraduated() {
        List<CareerWrap> GuestspeakersWrapList = new List<CareerWrap>();
        List<Guest_speaker__c> GuestspeakersList = [SELECT Name, Picture_of_guest_speaker__c, Guest_Speaker_Biography__c, Event_Description__c, Campus__c, Gender__c, Region__c, Year_Group__c, 
                                                    Deadline_to_sign_up__c, Start_Date__c, End_Date__c, Number_of_registration_allowed__c, Students_Booked__c, Location__c, Current_Course_of_Study__c
                                                    FROM Guest_speaker__c 
                                                    WHERE  IsActive__c =: TRUE AND forGraduatedStudent__c =: True AND End_Date__c >: Date.today()-30 Order By End_Date__c ASC];
        for (Guest_speaker__c GS : GuestspeakersList) {
            CareerWrap GuestspeakersWrap = new CareerWrap();
            GuestspeakersWrap.Id = GS.Id;
            GuestspeakersWrap.Campus = GS.Campus__c;
            GuestspeakersWrap.Gender = GS.Gender__c;
            GuestspeakersWrap.Region = GS.Region__c;
            GuestspeakersWrap.YearGroup = GS.Year_Group__c;
            GuestspeakersWrap.CurrentCourse = GS.Current_Course_of_Study__c;
            GuestspeakersWrap.registrationAllowed = GS.Number_of_registration_allowed__c;
            GuestspeakersWrap.studentRegistered = GS.Students_Booked__c;
            GuestspeakersWrap.StartDate = GS.Start_Date__c;
            GuestspeakersWrap.Location = GS.Location__c; 
            GuestspeakersWrap.EndDate = GS.End_Date__c;
            GuestspeakersWrap.Name = GS.Name;
            GuestspeakersWrap.GSDeadLine = GS.Deadline_to_sign_up__c;
            GuestspeakersWrap.url = GS.Picture_of_guest_speaker__c;
            GuestspeakersWrap.GuestSpeakerBiography = GS.Guest_Speaker_Biography__c;
            GuestspeakersWrap.EventDescription = GS.Event_Description__c;
            GuestspeakersWrapList.add(GuestspeakersWrap);
        }
        return JSON.serialize(GuestspeakersWrapList);
    }
     
     @RemoteAction
    global static string getSpeakerAttachments() {
        List<CareerWrap> attachmentWrapList = new List<CareerWrap>();
        List<Guest_speaker__c> ResourceList = [SELECT Name FROM Guest_speaker__c];
         List<Id> ResourceIdList= new List<Id>();
        for(Guest_speaker__c resourse : ResourceList) {
            ResourceIdList.add(resourse.Id);
        }        
        List <Attachment> attlist = [SELECT Name, ParentId FROM Attachment 
                                                                WHERE ParentId =: ResourceIdList Order by LastModifiedDate];
            for(Attachment att : attlist) {
            CareerWrap attachmentWrap = new CareerWrap();
            attachmentWrap.Id = att.Id;
            attachmentWrap.Name = att.Name;
            attachmentWrap.ParentId = att.ParentId;
            attachmentWrapList.add(attachmentWrap);
        }
        return JSON.serialize(attachmentWrapList);
    }
    
    @RemoteAction
    global static string getAllJobApplications() {
        List<CareerWrap> JobAplicationWrapList = new List<CareerWrap>();
        List<Job_Application__c> ApplicationList = [SELECT Name, Company__c, Company__r.Name, Job_Description__c, Position__c, Position__r.Name, CreatedDate, Applicant_Name__r.Current_Location_of_Study__pc, Status__c, LastModifiedDate 
                                                                                                FROM Job_Application__c 
                                                                                                WHERE Applicant_Name__c =: ApexPages.currentPage().getParameters().get('accId') AND IsActive__c =: TRUE];
        for(Job_Application__c JA : ApplicationList) {
                CareerWrap ApplicationWrap = new CareerWrap();
                ApplicationWrap.Name = JA.Name;
                ApplicationWrap.Id = JA.Id;
                ApplicationWrap.LastModifiedDate = JA.LastModifiedDate;
                ApplicationWrap.Position = JA.Position__c;
                ApplicationWrap.Company = JA.Company__r.Name;
                ApplicationWrap.status = JA.Status__c;
                ApplicationWrap.CreatedDate = JA.CreatedDate;
                ApplicationWrap.Location = JA.Applicant_Name__r.Current_Location_of_Study__pc;
                ApplicationWrap.PositionName = JA.Position__r.Name;
                ApplicationWrap.Description = JA.Job_Description__c;
                JobAplicationWrapList.add(ApplicationWrap);
        }
        System.debug('------>>>>>' + JSON.serialize(JobAplicationWrapList));
        return JSON.serialize(JobAplicationWrapList);
    }
    
    @RemoteAction
    global static string getJobApplicationAttachments() {
        List<CareerWrap> attachmentWrapList = new List<CareerWrap>();
        List<Job_Application__c> ResourceList = [SELECT Name FROM Job_Application__c 
                                                                                        WHERE Applicant_Name__c =: ApexPages.currentPage().getParameters().get('accId')];
         List<Id> ResourceIdList= new List<Id>();
        for(Job_Application__c resourse : ResourceList) {
            ResourceIdList.add(resourse.Id);
        }        
        List <Attachment> attlist = [SELECT Name, ParentId FROM Attachment 
                                                                WHERE ParentId =: ResourceIdList];
            for(Attachment att : attlist) {
            CareerWrap attachmentWrap = new CareerWrap();
            attachmentWrap.Id = att.Id;
            attachmentWrap.Name = att.Name;
            attachmentWrap.ParentId = att.ParentId;
            attachmentWrapList.add(attachmentWrap);
        }
        return JSON.serialize(attachmentWrapList);
    }
    
    @RemoteAction
    global static string getAllEvents() {
        List<CareerWrap> EventWrapList = new List<CareerWrap>();
        List<Event_Registration__c> EventList = [SELECT Name, Account__c, Guest_Speaker__c, Guest_Speaker__r.Name, Guest_speaker__r.Start_Date__c, CreatedDate 
                                                                                        FROM Event_Registration__c 
                                                                                        WHERE Account__c =: ApexPages.currentPage().getParameters().get('accId') AND IsActive__c =: TRUE];
        for(Event_Registration__c ER : EventList) {
                CareerWrap EventWrap = new CareerWrap();
                EventWrap.Id = ER.Id;
                EventWrap.Name = ER.Name;
                EventWrap.CreatedDate = ER.CreatedDate;
                EventWrap.guestSpeaker = ER.Guest_Speaker__c;
                EventWrap.eventStartDate = ER.Guest_speaker__r.Start_Date__c;
                EventWrap.Account = ER.Account__c;
                EventWrap.SpeakerName = ER.Guest_Speaker__r.Name;
                EventWrapList.add(EventWrap);
        }
        return JSON.serialize(EventWrapList);
    }
    
     @RemoteAction
    global static string getRelatedBookings() {
        List<CareerWrap> BookingWrapList = new List<CareerWrap>();
        List<Booking__c> BookingList = [SELECT Name, Account__c, Location__c, LastModifiedDate, CreatedDate, Account__r.Name, Date__c, Reason_for_Meeting__c, Room__c, Time__c, Lecturer__r.Name, IsAvaialble__c FROM Booking__c 
                                                                        WHERE Account__c =: ApexPages.currentPage().getParameters().get('accId')
                                                                        AND Date__c >=: system.Today() AND IsAvaialble__c =: FALSE ];
        for(Booking__c BL : BookingList) {
                CareerWrap BookingWrap = new CareerWrap();
                BookingWrap.Id = BL.Id;
                BookingWrap.Name = BL.Name;
                BookingWrap.BookingDate = BL.Date__c;
                BookingWrap.LastModifiedDate = BL.LastModifiedDate;
                BookingWrap.CreatedDate = BL.CreatedDate;
                BookingWrap.Location = BL.Location__c;
                BookingWrap.AccountName = BL.Account__r.Name;
                BookingWrap.Account = BL.Account__c;
                BookingWrap.Reason = BL.Reason_for_Meeting__c;
                BookingWrap.Room = BL.Room__c;
                BookingWrap.slot = BL.Time__c;
                BookingWrap.LecturerName = BL.Lecturer__r.Name;
                BookingWrapList.add(BookingWrap);
        }
        return JSON.serialize(BookingWrapList);
    }
    
     @RemoteAction
    global static string getAllBookingsDates() {
        //List<CareerWrap> BookingDateListWrap = new List<CareerWrap>();
        String accId = ApexPages.currentPage().getParameters().get('accId');
        String nullString = '';
        if(NULL != accId) {
                List<Account> locOfAcc = [SELECT Current_Location_of_Study__pc FROM Account WHERE Id =: accId LIMIT 1];
                System.debug('---->>>>locOfAcc = ' + locOfAcc);
                if(locOfAcc.size() > 0) {
                String locationOfAcc = locOfAcc[0].Current_Location_of_Study__pc;
                List<Booking__c> BookingDateList = [SELECT Name, Date__c, Account__r.Current_Location_of_Study__pc, Location__c 
                                                                                FROM Booking__c WHERE Date__c >=: System.Today() AND IsAvaialble__c =: True AND Location__c =: locationOfAcc];
                List<String> availDates = new List<String>();
                for(Booking__c B : BookingDateList) {
                        //CareerWrap DateWrap = new CareerWrap();
                        //DateWrap.Id = B.Id;
                        //DateWrap.AvailableDate = B.Date__c;
                        //BookingDateListWrap.add(DateWrap);
                        String aDate = (B.Date__c).format();
                        availDates.add(aDate);
                }
                availDates.sort();
                Set<String> availDatesSet = new Set<String>();
                availDatesSet.addAll(availDates);
                //Set<CareerWrap> BookingDateSet = new Set<CareerWrap>();
                //BookingDateSet.addAll(BookingDateListWrap);
                //return JSON.serialize(BookingDateSet);
                return JSON.serialize(availDatesSet);
                }
        }
        return JSON.serialize(nullString);
    }
    
    
     @RemoteAction
     global static string getAllResource() {
        List<CareerWrap> ResourceWrapList = new List<CareerWrap>();
        List<Resources__c> ResourceList = [SELECT Name, Description__c FROM Resources__c];
        for (Resources__c R : ResourceList) {
            CareerWrap ResourceWrap = new CareerWrap();
            ResourceWrap.Id = R.Id;
            ResourceWrap.Name = R.Name;
            ResourceWrap.Description = R.Description__c;
            ResourceWrapList.add(ResourceWrap);
        }
        return JSON.serialize(ResourceWrapList);
    }
    
    @RemoteAction
    global static string getAccountAttachments() {
        List<CareerWrap> attachmentWrapList = new List<CareerWrap>();
        List<Account> ResourceList = [SELECT Name FROM Account WHERE Id =: ApexPages.currentPage().getParameters().get('accId')];
        System.debug('----->>>>>ResourceList='+ResourceList);
         List<Id> ResourceIdList= new List<Id>();
         
        for(Account resourse : ResourceList) {
            ResourceIdList.add(resourse.Id);
        }        
        System.debug('----->>>>>ResourceIdList='+ResourceIdList);
        List <Attachment> attlist = [SELECT Name, ParentId FROM Attachment WHERE ParentId =: ResourceIdList AND Name Like '%Profile Picture%' Order by LastModifiedDate];
        System.debug('----->>>>>attList='+attList);
            for(Attachment att : attlist) {
            CareerWrap attachmentWrap = new CareerWrap();
            attachmentWrap.Id = att.Id;
            attachmentWrap.Name = att.Name;
            attachmentWrap.ParentId = att.ParentId;
            attachmentWrapList.add(attachmentWrap);
        }
        System.debug('----->>>>>attachmentWrapList='+attachmentWrapList);
        return JSON.serialize(attachmentWrapList);
    }
    
    
    @RemoteAction
     global static string getAllAccounts() {
        List<CareerWrap> AccountWrapList = new List<CareerWrap>();
        List<Account> AccountList = [SELECT Name, Student_Status__pc, Gender__pc, Region__c, UCFB_Year_Group__pc, Current_Location_of_Study__pc, Full_Address__c, PersonMobilePhone, 
                                                                         PersonOtherPhone, FirstName, LastName, PersonMailingCountry, Current_Course_of_Study__pc
                                                                FROM Account WHERE Id =: ApexPages.currentPage().getParameters().get('accId')];
        for (Account acc : AccountList) {
            CareerWrap AccountWrap = new CareerWrap();
            AccountWrap.Id = acc.Id;
            AccountWrap.Name = acc.Name;
            AccountWrap.Region = acc.Region__c;
            AccountWrap.YearGroup = acc.UCFB_Year_Group__pc;
            AccountWrap.Gender = acc.Gender__pc;
            AccountWrap.StudentStatus = acc.Student_Status__pc;
			AccountWrap.CurrentCourse = acc.Current_Course_of_Study__pc;
            AccountWrap.FullAddress = acc.Full_Address__c;
            AccountWrap.Phone = acc.PersonMobilePhone;
           // AccountWrap.PersonOtherAddress = acc.PersonOtherAddress;
            AccountWrap.PersonOtherPhone = acc.PersonOtherPhone;
            AccountWrap.FirstName = acc.FirstName;
            AccountWrap.LastName = acc.LastName;
            AccountWrap.Location = acc.Current_Location_of_Study__pc;
            AccountWrapList.add(AccountWrap);
        }
        return JSON.serialize(AccountWrapList);
    }
    
    
     @RemoteAction
     global static string getAllEmploymentHistory() {
        List<CareerWrap> EmploymentHistoryWrapList = new List<CareerWrap>();
        List<Alumni_Employment_History__c> EmploymentHistoryList = [SELECT Company__c, Company__r.Name, Appointment_Date__c, Industry__c, Employment_Level__c, 
                                                                                                                                Employment_Status__c, Employment_Type__c, Job_Expectations_Met__c, Job_Title__c, Still_wanting_work_in_sports_industry__c, Company_Region__c, Postal_Code__c
        FROM Alumni_Employment_History__c 
        WHERE Account_Name__c =: ApexPages.currentPage().getParameters().get('accId')];
        if(EmploymentHistoryList.size() > 0) {
                for (Alumni_Employment_History__c EL : EmploymentHistoryList) {
                    CareerWrap EmploymentHistoryWrap = new CareerWrap();
                    EmploymentHistoryWrap.Id = EL.Id;
                    EmploymentHistoryWrap.AccountName = EL.Company__r.Name;
                    EmploymentHistoryWrap.AppointmentDate = EL.Appointment_Date__c;
                    EmploymentHistoryWrap.Industry = EL.Industry__c;
                    EmploymentHistoryWrap.CompanyRegion = EL.Company_Region__c;
                    EmploymentHistoryWrap.PostalCode = EL.Postal_Code__c;
                    EmploymentHistoryWrap.EmploymentLevel = EL.Employment_Level__c;
                    EmploymentHistoryWrap.EmploymentStatus = EL.Employment_Status__c;
                    EmploymentHistoryWrap.EmploymentType = EL.Employment_Type__c;
                    EmploymentHistoryWrap.JobExpectationsMet = EL.Job_Expectations_Met__c;
                    EmploymentHistoryWrap.JobTitle = EL.Job_Title__c;
                    EmploymentHistoryWrap.StillWantIndustry = EL.Still_wanting_work_in_sports_industry__c;
                    EmploymentHistoryWrapList.add(EmploymentHistoryWrap);
                }
                return JSON.serialize(EmploymentHistoryWrapList);
        }
        return null;
    }
            
         @RemoteAction
     global static List<CareerWrap> getAllEmploymentHistoryNew(String accId) {
        List<CareerWrap> EmploymentHistoryWrapList = new List<CareerWrap>();
        List<String> returnList = new List<String>();
        List<Alumni_Employment_History__c> EmploymentHistoryList = [SELECT Company__c, Company__r.Name, Appointment_Date__c, Industry__c, Employment_Level__c, 
                                                                    Start_Date__c, End_Date__c, Company_Text__c, Employment_Status__c, Employment_Type__c, Job_Expectations_Met__c, 
                                                                    Job_Title__c, Still_wanting_work_in_sports_industry__c, Company_Region__c, Postal_Code__c
        FROM Alumni_Employment_History__c 
        WHERE Account_Name__c =: accId];
        
        if(EmploymentHistoryList.size() > 0) {
                for (Alumni_Employment_History__c EL : EmploymentHistoryList) {
                    CareerWrap EmploymentHistoryWrap = new CareerWrap();
                    EmploymentHistoryWrap.Id = EL.Id;
                    EmploymentHistoryWrap.AccountName = EL.Company__r.Name;
                    EmploymentHistoryWrap.AppointmentDate = EL.Appointment_Date__c;
                    EmploymentHistoryWrap.CompanyName = EL.Company_Text__c;
                    EmploymentHistoryWrap.StartDate = EL.Start_Date__c;
                    EmploymentHistoryWrap.EndDate = EL.End_Date__c;
                    EmploymentHistoryWrap.Industry = EL.Industry__c;
                    EmploymentHistoryWrap.CompanyRegion = EL.Company_Region__c;
                    EmploymentHistoryWrap.PostalCode = EL.Postal_Code__c;
                    EmploymentHistoryWrap.EmploymentLevel = EL.Employment_Level__c;
                    EmploymentHistoryWrap.EmploymentStatus = EL.Employment_Status__c;
                    EmploymentHistoryWrap.EmploymentType = EL.Employment_Type__c;
                    EmploymentHistoryWrap.JobExpectationsMet = EL.Job_Expectations_Met__c;
                    EmploymentHistoryWrap.JobTitle = EL.Job_Title__c;
                    EmploymentHistoryWrap.StillWantIndustry = EL.Still_wanting_work_in_sports_industry__c;
                    EmploymentHistoryWrapList.add(EmploymentHistoryWrap);
                    System.debug('--->>>>EmploymentHistoryWrap='+EmploymentHistoryWrap);
                }
                return EmploymentHistoryWrapList;
                //return JSON.serialize(EmploymentHistoryWrapList);
        }
        return null;
    }
    
    @RemoteAction
     global static void saveSingleTheEmpHistory(String accId, String CompanyNameNew, String CompanyRegionNew, String PostalCodeNew,
                                                                                        String StartDateNew, String EndDateNew, String IndustryNew, String EmpLevelNew,
                                                                                        String EmpStatusNew, String EmpTypeNew, String JobTitleNew) {
        
        System.debug('--->>>StartDateNew=' + StartDateNew);
        System.debug('--->>>EndDateNew=' + EndDateNew);
        
        String[] strDate = StartDateNew.split('-');
        Integer IntDate = integer.valueOf(strDate[2]);
        System.debug('--->>>IntDate' + IntDate);
        Integer IntMonth = integer.valueOf(strDate[1]);
        System.debug('--->>>IntMonth' + IntMonth);
        Integer IntYear = integer.valueOf(strDate[0]);
        System.debug('--->>>IntYear' + IntYear);
        Date dStart = Date.newInstance(IntYear, IntMonth, IntDate);
        System.debug('--->>>dStart' + dStart);
        
        String[] strDateEnd = EndDateNew.split('-');
        Integer IntDateEnd = integer.valueOf(strDateEnd[2]);
        System.debug('--->>>IntDateEnd' + IntDateEnd);
        Integer IntMonthEnd = integer.valueOf(strDateEnd[1]);
        System.debug('--->>>IntMonthEnd' + IntMonthEnd);
        Integer IntYearEnd = integer.valueOf(strDateEnd[0]);
        System.debug('--->>>IntYearEnd' + IntYearEnd);
        Date dEnd = Date.newInstance(IntYearEnd, IntMonthEnd, IntDateEnd);
        System.debug('--->>>dEnd' + dEnd);
        
        Alumni_Employment_History__c newEmpHistory = new Alumni_Employment_History__c();
        //System.debug('CompanyNameNew='+CompanyNameNew);
        System.debug('CompanyRegionNew='+CompanyRegionNew);
        System.debug('PostalCodeNew='+PostalCodeNew);
        //System.debug('AppointmentDateNew='+AppointmentDateNew);
        System.debug('IndustryNew='+IndustryNew);
        System.debug('EmpLevelNew='+EmpLevelNew);
        System.debug('EmpStatusNew='+EmpStatusNew);
        System.debug('EmpTypeNew='+EmpTypeNew);
        System.debug('JobTitleNew='+JobTitleNew);
        newEmpHistory.Account_Name__c = accId;
        //newEmpHistory.Company__c = CompanyNameNew;
        newEmpHistory.Company_Text__c = CompanyNameNew;
        newEmpHistory.Start_Date__c = dStart;
        newEmpHistory.End_Date__c = dEnd;
        newEmpHistory.Company_Region__c = CompanyRegionNew;
        newEmpHistory.Postal_Code__c = PostalCodeNew;
        //newEmpHistory.Appointment_Date__c = d;
        newEmpHistory.Industry__c = IndustryNew;
        newEmpHistory.Employment_Level__c = EmpLevelNew;
        newEmpHistory.Employment_Status__c = EmpStatusNew;
        newEmpHistory.Employment_Type__c = EmpTypeNew;
        newEmpHistory.Job_Title__c = JobTitleNew;
        insert newEmpHistory;
    }
    
    @RemoteAction
     global static void updateSingleTheEmpHistory(String accId, String empId, String CompanyNameNew, String CompanyRegionNew,
                                                                                        String PostalCodeNew, String StartDateNew, String EndDateNew, String IndustryNew,
                                                                                        String EmpLevelNew, String EmpStatusNew, String EmpTypeNew, String JobTitleNew) {
        System.debug('--->>>StartDateNew=' + StartDateNew);
        System.debug('--->>>EndDateNew=' + EndDateNew);
        String[] strDate = StartDateNew.split('-');
        Integer IntDate = integer.valueOf(strDate[2]);
        System.debug('--->>>IntDate' + IntDate);
        Integer IntMonth = integer.valueOf(strDate[1]);
        System.debug('--->>>IntMonth' + IntMonth);
        Integer IntYear = integer.valueOf(strDate[0]);
        System.debug('--->>>IntYear' + IntYear);
        Date dStart = Date.newInstance(IntYear, IntMonth, IntDate);
        System.debug('--->>>dStart' + dStart);
        
        String[] strDateEnd = EndDateNew.split('-');
        Integer IntDateEnd = integer.valueOf(strDateEnd[2]);
        System.debug('--->>>IntDateEnd' + IntDateEnd);
        Integer IntMonthEnd = integer.valueOf(strDateEnd[1]);
        System.debug('--->>>IntMonthEnd' + IntMonthEnd);
        Integer IntYearEnd = integer.valueOf(strDateEnd[0]);
        System.debug('--->>>IntYearEnd' + IntYearEnd);
        Date dEnd = Date.newInstance(IntYearEnd, IntMonthEnd, IntDateEnd);
        System.debug('--->>>dEnd' + dEnd);
        
        Alumni_Employment_History__c newEmpHistory = new Alumni_Employment_History__c();
        System.debug('empId='+empId);
        System.debug('CompanyRegionNew='+CompanyRegionNew);
        System.debug('PostalCodeNew='+PostalCodeNew);
        //System.debug('AppointmentDateNew='+AppointmentDateNew);
        System.debug('IndustryNew='+IndustryNew);
        System.debug('EmpLevelNew='+EmpLevelNew);
        System.debug('EmpStatusNew='+EmpStatusNew);
        System.debug('EmpTypeNew='+EmpTypeNew);
        System.debug('JobTitleNew='+JobTitleNew);
        
        newEmpHistory.Id = empId;
        newEmpHistory.Company_Text__c = CompanyNameNew;
        newEmpHistory.Start_Date__c = dStart;
        newEmpHistory.End_Date__c = dEnd;
        newEmpHistory.Account_Name__c = accId;
        //newEmpHistory.Company__c = CompanyNameNew;
        newEmpHistory.Company_Region__c = CompanyRegionNew;
        newEmpHistory.Postal_Code__c = PostalCodeNew;
        newEmpHistory.Industry__c = IndustryNew;
        newEmpHistory.Employment_Level__c = EmpLevelNew;
        newEmpHistory.Employment_Status__c = EmpStatusNew;
        newEmpHistory.Employment_Type__c = EmpTypeNew;
        newEmpHistory.Job_Title__c = JobTitleNew;
        update newEmpHistory;
    }
    
    @RemoteAction
    global static void deleteEmpHistory(String empId) {
        Alumni_Employment_History__c deleteEmp = [SELECT Id FROM Alumni_Employment_History__c WHERE Id =: empId LIMIT 1];
        delete deleteEmp;
    }
        
     @RemoteAction
     global static string getAllSubMenus() {
        List<CareerWrap> submenuWrapList = new List<CareerWrap>();
        List <Sub_Menu__c> submenuList = [SELECT Id, Name, Top_Menu__c, URL__c, Sub_Menu__c, Sub_Menu__r.Name, Sub_Menu__r.Url__c FROM Sub_Menu__c ORDER BY Name];
        for (Sub_Menu__c SM : submenuList){
            CareerWrap submenuWrap = new CareerWrap();
            submenuWrap.Id = SM.Id;
            submenuWrap.Name = SM.Name;
            submenuWrap.TopMenu = SM.Top_Menu__c;
            submenuWrap.url = SM.URL__c;
            submenuWrap.SubMenu = SM.Sub_Menu__c;
            submenuWrap.SubmenuName = SM.Sub_Menu__r.Name;
            submenuWrap.SubMenuUrl = SM.Sub_Menu__r.Url__c;
            submenuWrapList.add(submenuWrap);
        }
        return JSON.serialize(submenuWrapList);
    }
     @RemoteAction
     global static string getAllTopMenus() {
        List<CareerWrap> topmenuWrapList = new List<CareerWrap>();
        List <Top_Menu__c> topmenuList = [SELECT Id, Name, URL__c FROM Top_Menu__c 
        WHERE RecordTypeId in (SELECT Id FROM RecordType WHERE Name = 'Page')
        Order by Number__c];
        for (Top_Menu__c TM : topmenuList){
            CareerWrap topmenuWrap = new CareerWrap();
            topmenuWrap.Id = TM.Id;
            topmenuWrap.Name = TM.Name;
            topmenuWrap.url = TM.URL__c;
            topmenuWrapList.add(topmenuWrap);
        }
        return JSON.serialize(topmenuWrapList);
    }

    @RemoteAction
    global static void createBookingHistoryObj(String book, String account) {
        try {
            Account acc = [SELECT Name FROM Account WHERE Id =: account];
            Booking_History__c bookHistory = new Booking_History__c();
            bookHistory.Name = acc.Name;
            bookHistory.Account__c = account;
            bookHistory.Booking__c = book;
            System.debug('------->>>>>>>>bookHistory' +bookHistory);
            insert bookHistory;
        } catch(Exception e) {
            System.debug('---->>>' +e.getMessage());
        }
    }
    
    @RemoteAction
    global static void createLoginHistoryRecord(String accId) {
        try {
                Login_History__c loginHistory = new Login_History__c();
                Account acc = [SELECT Name FROM Account WHERE Id =: accId];
                loginHistory.Name = acc.Name;
                loginHistory.Account_Name__c = accId;
                loginHistory.Last_Logged_In__c = datetime.now();
                loginHistory.Status__c = 'Login Successfull';
                loginHistory.Status_Reason__c = 'Login is Successfull';
                System.debug('---->>>>loginHistory='+loginHistory);
                insert loginHistory;
        } catch(Exception e) {
                System.debug('-->>>' + e.getMessage());
        }
        
    }
    
    @RemoteAction
    global static void createLoginHistoryRecordFailed(String accId, String reason) {
        try {
                Login_History__c loginHistory = new Login_History__c();
                Account acc = [SELECT Name FROM Account WHERE Id =: accId];
                loginHistory.Name = acc.Name;
                loginHistory.Account_Name__c = accId;
                loginHistory.Status_Reason__c = reason;
                loginHistory.Last_Logged_In__c = datetime.now();
                loginHistory.Status__c = 'Login Failed';
                System.debug('---->>>>loginHistory='+loginHistory);
                insert loginHistory;
        } catch(Exception e) {
                System.debug('-->>>' + e.getMessage());
        }
        
    }
   
    @RemoteAction
    global static string getResourceAttachments() {
        List<CareerWrap> attachmentWrapList = new List<CareerWrap>();
        List<Resources__c> ResourceList = [SELECT Name FROM Resources__c];
         List<Id> ResourceIdList= new List<Id>();
        for(Resources__c resourse : ResourceList) {
            ResourceIdList.add(resourse.Id);
        }        
        List <Attachment> attlist = [SELECT Name, ParentId FROM Attachment WHERE ParentId =: ResourceIdList];
            for(Attachment att : attlist) {
            CareerWrap attachmentWrap = new CareerWrap();
            attachmentWrap.Id = att.Id;
            attachmentWrap.Name = att.Name;
            attachmentWrap.ParentId = att.ParentId;
            attachmentWrapList.add(attachmentWrap);
        }
        return JSON.serialize(attachmentWrapList);
    }
    @RemoteAction
    global static string getAllFiles() {
        List<CareerWrap> fileWrapList = new List<CareerWrap>();
        List<Resources__c> fileList = [SELECT Name FROM Resources__c];
         List<Id> forFileIdList= new List<Id>();
        for(Resources__c resourse1 : fileList) {
            forFileIdList.add(resourse1.Id);
        }        
        List <file__c> fList = [SELECT Name, resource__c, Video_URL__c, Type__c, CreatedDate FROM file__c WHERE resource__c =: forFileIdList AND IsActive__c =: True];
            for(file__c F : fList) {
            CareerWrap fileWrap = new CareerWrap();
            fileWrap.Id = F.Id;
            fileWrap.Name = F.Name;
            fileWrap.CreatedDate = F.CreatedDate;
            fileWrap.Type = F.Type__c;
            fileWrap.resourceId = F.resource__c;
            fileWrap.url = F.Video_URL__c;
            fileWrapList.add(fileWrap);
        }
        return JSON.serialize(fileWrapList);
    }
    
    @RemoteAction
    global static string getfilesAttachments() {
        List<CareerWrap> attachmentWrapList = new List<CareerWrap>();
        List<file__c> ResourceList = [SELECT Name FROM file__c];
         List<Id> ResourceIdList= new List<Id>();
        for(file__c resourse : ResourceList) {
            ResourceIdList.add(resourse.Id);
        }        
        List <Attachment> attlist = [SELECT Name, ParentId FROM Attachment WHERE ParentId =: ResourceIdList];
            for(Attachment att : attlist) {
            CareerWrap attachmentWrap = new CareerWrap();
            attachmentWrap.Id = att.Id;
            attachmentWrap.Name = att.Name;
            attachmentWrap.ParentId = att.ParentId;
            attachmentWrapList.add(attachmentWrap);
        }
        return JSON.serialize(attachmentWrapList);
    }
    
    @RemoteAction
    global static String encrypt(String toBeEncryptedString) {
        LoginEncryption__c settings = LoginEncryption__c.getOrgDefaults();
        Blob secretKey = EncodingUtil.base64Decode(settings.key__c);
        Blob stringToEncrypt = Blob.valueOf(toBeEncryptedString);
        Blob encryption = Crypto.encrypt('AES128', secretKey, secretKey, stringToEncrypt);
        return EncodingUtil.base64Encode(encryption);
    }
    
    @RemoteAction
    global static String decrypt(String conId) {
        Account relatedAccount = NULL;
        try {
            relatedAccount = [SELECT Id, Password__c FROM Account WHERE Id =: conId LIMIT 1];
        } catch (Exception e) {
            System.debug(e.getmessage());
        }
        String encryptedString = relatedAccount.Password__c;
        LoginEncryption__c settings = LoginEncryption__c.getOrgDefaults();
        Blob secretKey = EncodingUtil.base64Decode(settings.key__c);
        Blob stringToBlob = EncodingUtil.base64Decode(encryptedString);
        Blob decryption = Crypto.decrypt('AES128', secretKey, secretKey, stringToBlob);
        return decryption.toString();
    }
    
    @RemoteAction
    global static String findEmailAddress(String EmailId) {
        List<Account> relatedAccount = NULL;
        String returnId = NULL;
        try {
            relatedAccount = [SELECT Id, Password__c,  Student_Status__pc, IsSiteEnable__c, End_Date_at_UCFB__pc FROM Account WHERE PersonEmail =: EmailId AND IsSiteEnable__c =: TRUE];
            System.debug('------>>>>>>relatedAccount = ' + relatedAccount);
            if(relatedAccount.size() > 1) {
                return 'Duplicate';
            } else {
                for(Account acc: relatedAccount) {
                        //if(acc.Student_Status__pc == 'Graduated' && acc.End_Date_at_UCFB__pc.addYears(2) < date.today()){
                                //return 'DateEnd';
                            //} else {
                                System.debug('----->>>>>acc.Student_Status__pc='+acc.Student_Status__pc);
                                System.debug('----->>>>>'+acc.Student_Status__pc == 'Graduated');
                                //System.debug('acc.End_Date_at_UCFB__pc.addYears(2) < Date.today() = '+ acc.End_Date_at_UCFB__pc.addYears(2) < Date.today());
                                System.debug('acc.End_Date_at_UCFB__pc.addYears(2)='+acc.End_Date_at_UCFB__pc.addYears(2));
                                System.debug('Date.today()='+Date.today());
                                if(acc.End_Date_at_UCFB__pc.addYears(2) < Date.today()) {
                                        return 'Expired';
                                } else {
                                        returnId = acc.Id;
                                }
                            //}
                }
                return returnId;
            }
        } catch (Exception e) {
            System.debug('No email found');
        }
        return null;
    }
    
    @RemoteAction
    global static String findUCFBId(String Ucfb) {
        Account relatedAccount = NULL;
        String returnId = NULL;
        try {
            relatedAccount = [SELECT Id, Password__c,  Student_Status__pc, IsSiteEnable__c FROM Account WHERE Student_ID_from_UCAS_File__pc =: Ucfb AND IsSiteEnable__c =: TRUE LIMIT 1];
            //if(relatedAccount.size() > 1) {
                //return 'Duplicate';
            //} else {
                //for(Account acc: relatedAccount) {
                        //if(acc.Student_Status__pc == 'Graduated' && acc.End_Date_at_UCFB__pc.addYears(2) < date.today()){
                                //return 'DateEnd';
                            //} else {
                                        returnId = relatedAccount.Id;
                                    
                            //}
                //}
                return returnId;
            //}
        } catch (Exception e) {
            System.debug('No UCFB Id found');
        }
        return null;
    }
    
    @RemoteAction
    global static String statusOfAccount(String conId) {
        Account relatedAccount = NULL;
        try {
            relatedAccount = [SELECT Id, Student_Status__pc FROM Account WHERE Id =: conId AND IsSiteEnable__c =: TRUE LIMIT 1];
            return relatedAccount.Student_Status__pc;
        } catch (Exception e) {
            System.debug('No UCFB Id found');
        }
        return null;
    }
    
    @RemoteAction
    global static Boolean checkFirstTimeLoginOrNot(String conId) {
        Account relatedAccount = NULL;
        try {
            relatedAccount = [SELECT Id, isFirstTimeLogin__c FROM Account WHERE Id =: conId AND IsSiteEnable__c =: TRUE LIMIT 1];
        } catch (Exception e) {
            System.debug(e.getmessage());
        }
                return relatedAccount.isFirstTimeLogin__c;
    }
    
    @RemoteAction
    global static void setChangePassword(String conId, String newPassword) {
        Account relatedAccount = NULL;
        try {
            relatedAccount = [SELECT Id, isFirstTimeLogin__c, Password__c, isForgetPassword__c FROM Account WHERE Id =: conId AND IsSiteEnable__c =: TRUE LIMIT 1];
            relatedAccount.Password__c = newPassword;
            relatedAccount.isFirstTimeLogin__c = FALSE;
            relatedAccount.isForgetPassword__c = FALSE;
            relatedAccount.isResetPassword__c = FALSE;
            update relatedAccount;
        } catch (Exception e) {
            System.debug(e.getmessage());
        }
    }
    
    @RemoteAction
    global static void setPasswordToDefault(String conId) {
        Account relatedAccount = NULL;
        
        //This code will generate random password
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < 8) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        
        String toBeEncryptedString = randStr;
        LoginEncryption__c settings = LoginEncryption__c.getOrgDefaults();
        Blob secretKey = EncodingUtil.base64Decode(settings.key__c);
        Blob stringToEncrypt = Blob.valueOf(toBeEncryptedString);
        Blob encryption = Crypto.encrypt('AES128', secretKey, secretKey, stringToEncrypt);
        String newDefaultPassword = EncodingUtil.base64Encode(encryption);
        try {
            relatedAccount = [SELECT Id, isFirstTimeLogin__c, Password__c, isForgetPassword__c FROM Account WHERE Id =: conId LIMIT 1];
            relatedAccount.Password__c = newDefaultPassword;
            relatedAccount.tempPassword__c = randStr;
            relatedAccount.isFirstTimeLogin__c = TRUE;
            relatedAccount.isForgetPassword__c = TRUE;
            update relatedAccount;
        } catch (Exception e) {
            System.debug(e.getmessage());
        }
    }
    
    @RemoteAction
    global static String getSessionKey() {
        SessionCheck__c settings = SessionCheck__c.getOrgDefaults();
        return settings.SessionKey__c;
    }
    
    @RemoteAction
    global static String getSessionValue() {
        SessionCheck__c settings = SessionCheck__c.getOrgDefaults();
        return settings.SessionValue__c;
    }
    
    @RemoteAction
    global static void deleteTheReg(String regId, String AccId) {
        Event_Registration__c EventList = [SELECT Id, IsActive__c FROM Event_Registration__c WHERE Guest_Speaker__c =: regId AND Account__c =: AccId AND IsActive__c =: TRUE];
        EventList.IsActive__c = False;
        EventList.Status__c = 'Cancelled';
        update EventList;
    }
    
    @RemoteAction
    global static void deleteTheApp(String apId, String AccId) {
        Job_Application__c ApplicationList = [SELECT Id, IsActive__c FROM Job_Application__c WHERE Position__c =: apId AND Applicant_Name__c =: AccId AND IsActive__c =: TRUE LIMIT 1];
        ApplicationList.IsActive__c = False;
        ApplicationList.Status__c = 'Cancelled';
        update ApplicationList;
    }
    
        @RemoteAction
    global static void deleteTheBook(String bookId, String AccId) {
        Booking__c bookingList = [SELECT Id, IsAttending__c, Email__c, IsAvaialble__c, Reason_for_Meeting__c, Time__c, Account__c FROM Booking__c WHERE Account__c =: AccId AND IsAvaialble__c =: FALSE AND Id =: bookId];
        system.debug('BookingList--------->>>>>>' + bookingList);
        bookingList.IsAvaialble__c = TRUE;
        bookingList.IsAttending__c = FALSE;
        bookingList.Email__c = '';
        bookingList.Reason_for_Meeting__c = '';
        //bookingList.Time__c = '';
        bookingList.Account__c = NULL;
        update bookingList;
    }
    
    @RemoteAction
    global static void deleteTheComp(String apId, String AccId) {
        Course_Registration__c CompList = [SELECT Name,Id, IsActive__c FROM Course_Registration__c WHERE Course_Name__c =: apId AND Account__c =: AccId AND IsActive__c =: TRUE];
        CompList.IsActive__c = False;
        CompList.Status__c = 'Cancelled';
        update CompList;
    }
    
    @RemoteAction
    global static String createApplicationObj(String attName, String attContentType, String attBody ,String appName, String appDesc, String appJnC, String appAcc, String compId) {
        Job_Application__c jobApp = new Job_Application__c();
        jobApp.Job_Description__c = appDesc;
        jobApp.Position__c = appJnC;
        jobApp.Applicant_Name__c = appAcc;
        jobApp.Company__c = compId;
        jobApp.IsActive__c = True;
        jobApp.Status__c = 'Applied';
        insert jobApp;
        Attachment att = new Attachment();
        att.Name = attName;
        att.ContentType = attContenttype;
        //String newBody = EncodingUtil.base64Encode(attBody);
        att.Body = EncodingUtil.base64Decode(attBody);
        //att.body = Blob.valueOf(attBody);
        att.ParentId = jobApp.Id;
        try{
                insert att;
        }
        catch(Exception e){
                System.debug('*****Error while upload the file****' + e.getMessage());
        }
        
        return jobApp.Id;
    }

	@RemoteAction
    global static List<String> getAllTimingsList() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> returnString = new List<String>();
        Schema.DescribeFieldResult fieldResult = Booking__c.Time__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
            returnString.add(f.getValue());
        }
        //return JSON.serialize(returnString);
        system.debug('>>>>>>>>>>>>>>>>>>>>> returnString' + returnString);
        return returnString;
    }

    @RemoteAction
    global static List<String> getAllReasonsList() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> returnString = new List<String>();
        Schema.DescribeFieldResult fieldResult = Booking__c.Reason_for_Meeting__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
                        options.add(new SelectOption(f.getLabel(), f.getValue()));
                        returnString.add(f.getValue());
        }
        return returnString;
    }
    
    public String ReasonOfMeeting { get; set; }
    
    @RemoteAction
    global static List<String> getAllTimingsBooked(String enteredDate, String accId) {
        //Date checkDate = Date.valueOf(enteredDate);
        //Date checkDate = Date.parse(enteredDate);
        String[] myDateOnly = enteredDate.split(' ');
        System.debug('--->>>myDateOnly' + myDateOnly);
        String[] strDate = myDateOnly[0].split('/');
        System.debug('--->>>strDate' + strDate);
        Integer IntDate = integer.valueOf(strDate[0]);
        System.debug('--->>>IntDate' + IntDate);
        Integer IntMonth = integer.valueOf(strDate[1]);
        System.debug('--->>>IntMonth' + IntMonth);
        Integer IntYear = integer.valueOf(strDate[2]);
        System.debug('--->>>IntYear' + IntYear);
        Date d = Date.newInstance(IntYear, IntMonth, IntDate);
        System.debug('--->>>d' + d);
        System.debug('---->>>>enteredDate = ' + enteredDate);
        //String accId = ApexPages.currentPage().getParameters().get('accId');
        System.debug('---->>>>accId = ' + accId);
        Account locOfAcc = [SELECT Current_Location_of_Study__pc FROM Account WHERE Id =: accId LIMIT 1];
        System.debug('---->>>>locOfAcc = ' + locOfAcc);
        String locationOfAcc = locOfAcc.Current_Location_of_Study__pc;
        System.debug('---->>>>locationOfAcc = ' + locationOfAcc);
        List<Booking__c> allSlefBooked = [SELECT Date__c, Time__c FROM Booking__c WHERE Account__c =: accId];
        System.debug('---->>>>allSlefBooked = ' + allSlefBooked);
        List<Booking__c> allBooked = [SELECT Time__c, IsAvaialble__c FROM Booking__c WHERE Date__c =: d AND Location__c =: locationOfAcc AND IsAvaialble__c =: True];
        System.debug('---->>>>allBooked = ' + allBooked);
        List<String> bookedTimingList = new List<String>();
        if(allBooked.size() > 0) {
                for (Booking__c books : allBooked) {
                    if(allSlefBooked.size() > 0) {
                        for(Booking__c book : allSlefBooked) {
                            if(book.Time__c != books.Time__c) {
                                bookedTimingList.add((String)books.Time__c);
                                System.debug('---->>>>bookedTimingList = ' + bookedTimingList);
                            }
                        }
                    } else if(allSlefBooked.size() == 0) {
                        bookedTimingList.add((String)books.Time__c);
                    }
                }
                System.debug('---->>>>bookedTimingList Final = ' + bookedTimingList);       
        }
        
        return bookedTimingList;
    }
    
    @RemoteAction
    global static Integer checkSelectedDateBookings(String selectedDate, String AccId) {
        String[] myDateOnly = selectedDate.split(' ');
        System.debug('--->>>myDateOnly' + myDateOnly);
        String[] strDate = myDateOnly[0].split('/');
        System.debug('--->>>strDate' + strDate);
        Integer IntDate = integer.valueOf(strDate[0]);
        System.debug('--->>>IntDate' + IntDate);
        Integer IntMonth = integer.valueOf(strDate[1]);
        System.debug('--->>>IntMonth' + IntMonth);
        Integer IntYear = integer.valueOf(strDate[2]);
        System.debug('--->>>IntYear' + IntYear);
        Date d = Date.newInstance(IntYear, IntMonth, IntDate);
        System.debug('--->>>d' + d);
        System.debug('---->>>>enteredDate = ' + selectedDate);
        //String AccId = ApexPages.currentPage().getParameters().get('accId');
        System.debug('-->>>AccId =' + AccId);
        Account acc = [SELECT Student_Status__pc FROM Account WHERE Id =: AccId];
        Integer countOfBookings;
        //if(acc.Student_Status__pc == 'Active') {
                countOfBookings = [SELECT count() FROM Booking__c WHERE Date__c =: d AND Account__c =: AccId];
        //} else {
                //countOfBookings = -1;
        //}
        System.debug('--->>>>countOfBookings = ' + countOfBookings);
        return countOfBookings;
    }
    
    public String Bookings {get; set;}
    
    @RemoteAction
    global static void bookMeetingCtrl(String enteredDate, String accId, String selectedTime, String selectedReason) {
        String[] myDateOnly = enteredDate.split(' ');
        System.debug('--->>>myDateOnly' + myDateOnly);
        String[] strDate = myDateOnly[0].split('/');
        System.debug('--->>>strDate' + strDate);
        Integer IntDate = integer.valueOf(strDate[0]);
        System.debug('--->>>IntDate' + IntDate);
        Integer IntMonth = integer.valueOf(strDate[1]);
        System.debug('--->>>IntMonth' + IntMonth);
        Integer IntYear = integer.valueOf(strDate[2]);
        System.debug('--->>>IntYear' + IntYear);
        Date d = Date.newInstance(IntYear, IntMonth, IntDate);
        System.debug('--->>>d' + d);
        System.debug('---->>>>enteredDate = ' + enteredDate);
        //String accId = ApexPages.currentPage().getParameters().get('accId');
        System.debug('---->>>>accId = ' + accId);
        Account locOfAcc = [SELECT Current_Location_of_Study__pc, PersonEmail FROM Account WHERE Id =: accId LIMIT 1];
        System.debug('---->>>>locOfAcc = ' + locOfAcc);
        String locationOfAcc = locOfAcc.Current_Location_of_Study__pc;
        System.debug('---->>>>locationOfAcc = ' + locationOfAcc);
        Booking__c allBooked = [SELECT Email__c, Account__c, IsAttending__c, Reason_for_Meeting__c FROM Booking__c WHERE Date__c =: d AND Location__c =: locationOfAcc AND IsAvaialble__c =: True AND Time__c =: selectedTime LIMIT 1];
        Booking__c newBooking = new Booking__c();
        newBooking = allBooked;
        newBooking.Time__c = selectedTime;
        newBooking.Date__c = d;
        newBooking.Email__c = locOfAcc.PersonEmail;
        newBooking.Location__c = locationOfAcc;
        newBooking.Reason_for_Meeting__c = selectedReason;
        newBooking.Account__c = accId;
        newBooking.IsAvaialble__c = False;
        newBooking.IsAttending__c = TRUE;
        update newBooking;
    }
    
    public List<SelectOption> getTimings() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Booking__c.Time__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
                        options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    
    public List<SelectOption> getReason() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Booking__c.Reason_for_Meeting__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
                        options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        
        return options;
    }
    
    @RemoteAction
    global static String getIndustry() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> returnString = new List<String>();
        Schema.DescribeFieldResult fieldResult = Alumni_Employment_History__c.Industry__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
             options.add(new SelectOption(f.getLabel(), f.getValue()));
             returnString.add(f.getValue());
        }
        
        return JSON.serialize(returnString);
    }
     
     @RemoteAction
     global static String getEmploymentLevel() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> returnString = new List<String>();
        Schema.DescribeFieldResult fieldResult = Alumni_Employment_History__c.Employment_Level__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
             options.add(new SelectOption(f.getLabel(), f.getValue()));
             returnString.add(f.getValue());
        }
        
        return JSON.serialize(returnString);
    }
    
     @RemoteAction
     global static String getEmploymentStatus() {
        List<SelectOption> options = new List<SelectOption>();
         List<String> returnString = new List<String>();
        Schema.DescribeFieldResult fieldResult = Alumni_Employment_History__c.Employment_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
             options.add(new SelectOption(f.getLabel(), f.getValue()));
             returnString.add(f.getValue());
        }
        
        return JSON.serialize(returnString);
     }
     @RemoteAction
     global static String getEmploymentType() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> returnString = new List<String>();
        Schema.DescribeFieldResult fieldResult = Alumni_Employment_History__c.Employment_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
             options.add(new SelectOption(f.getLabel(), f.getValue()));
             returnString.add(f.getValue());
        }
        
        return JSON.serialize(returnString);
    }
    
    @RemoteAction
    global static List<String> getAllIndustry() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> returnString = new List<String>();
        Schema.DescribeFieldResult fieldResult = Alumni_Employment_History__c.Industry__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
             options.add(new SelectOption(f.getLabel(), f.getValue()));
             returnString.add(f.getValue());
        }
        
        return returnString;
    }
     
     @RemoteAction
     global static List<String> getAllEmploymentLevel() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> returnString = new List<String>();
        Schema.DescribeFieldResult fieldResult = Alumni_Employment_History__c.Employment_Level__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
             options.add(new SelectOption(f.getLabel(), f.getValue()));
             returnString.add(f.getValue());
        }
        
        return returnString;
    }
    
     @RemoteAction
     global static List<String> getAllEmploymentStatus() {
        List<SelectOption> options = new List<SelectOption>();
         List<String> returnString = new List<String>();
        Schema.DescribeFieldResult fieldResult = Alumni_Employment_History__c.Employment_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
             options.add(new SelectOption(f.getLabel(), f.getValue()));
             returnString.add(f.getValue());
        }
        
        return returnString;
     }
     @RemoteAction
     global static List<String> getAllEmploymentType() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> returnString = new List<String>();
        Schema.DescribeFieldResult fieldResult = Alumni_Employment_History__c.Employment_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
             options.add(new SelectOption(f.getLabel(), f.getValue()));
             returnString.add(f.getValue());
        }
        
        return returnString;
    }
    
     @RemoteAction
     global static String getJobExpectationsMet() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> returnString = new List<String>();
        Schema.DescribeFieldResult fieldResult = Alumni_Employment_History__c.Job_Expectations_Met__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
             options.add(new SelectOption(f.getLabel(), f.getValue()));
             returnString.add(f.getValue());
        }
        
        return JSON.serialize(returnString);
    }
    
     @RemoteAction
     global static String getStillWantingWork() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> returnString = new List<String>();
        Schema.DescribeFieldResult fieldResult = Alumni_Employment_History__c.Still_wanting_work_in_sports_industry__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
             options.add(new SelectOption(f.getLabel(), f.getValue()));
             returnString.add(f.getValue());
        }
        
        return JSON.serialize(returnString);
    }
    @RemoteAction
     global static String getMailingCountry() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> returnString = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.BillingCountryCode.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
             options.add(new SelectOption(f.getLabel(), f.getValue()));
             returnString.add(f.getValue());
        }
        
        return JSON.serialize(returnString);
    }
    
    @RemoteAction
     global static String getMailingState() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> returnString = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.BillingStateCode.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
             options.add(new SelectOption(f.getLabel(), f.getValue()));
             returnString.add(f.getValue());
        }
        
        return JSON.serialize(returnString);
    }
    
    @RemoteAction
     global static String getAccountLocation() {
        List<SelectOption> options = new List<SelectOption>();
        List<String> returnString = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Current_Location_of_Study__pc.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
             options.add(new SelectOption(f.getLabel(), f.getValue()));
             returnString.add(f.getValue());
        }
        
        return JSON.serialize(returnString);
    }
    
    @RemoteAction
    global static void createReAttachment(String attContentType, String attBody, String jobId) {
        try {
        Attachment att = [SELECT ID FROM Attachment WHERE ParentId =: jobId LIMIT 1];
        delete att;
        Job_Application__c relatedJob = [SELECT Id, Name FROM Job_Application__c WHERE Id =: jobId];
        Attachment newAtt = new Attachment();
        newAtt.Name = relatedJob.Name + ' - CV';
        newAtt.ContentType = attContentType;
        newAtt.Body = EncodingUtil.base64Decode(attBody);
        newAtt.ParentId = jobId;
        insert newAtt;
        
        } catch(Exception e) {
                
                
                System.debug('--->>>>>>>ERROR='+e.getMessage());
        }
    }
    
    @RemoteAction
    global static void saveAccDetails(String AccId, String accPhone, String accOtherPhone, String accFullAddress) {
        
        Account accToUpdate = [SELECT PersonMobilePhone, PersonOtherPhone, Full_Address__c,
                                                        Current_Location_of_Study__pc FROM Account WHERE Id =: AccId];
        
        /*Alumni_Employment_History__c historyToUpdate = [SELECT Appointment_Date__c, Industry__c, Employment_Level__c,Employment_Status__c,
                                                                                                        Employment_Type__c, Job_Expectations_Met__c, Job_Title__c, Still_wanting_work_in_sports_industry__c, Company_Region__c, Postal_Code__c
                                                                                                        FROM Alumni_Employment_History__c WHERE Id =: historyId AND Account_Name__c =:AccId];*/
                
                accToUpdate.PersonMobilePhone = accPhone;
                accToUpdate.PersonOtherPhone = accOtherPhone;
                //accToUpdate.PersonMailingStreet = accStreet;
                //accToUpdate.PersonMailingCity = accCity;
                //accToUpdate.PersonMailingState = accState;
                accToUpdate.Full_Address__c = accFullAddress;
                //accToUpdate.Current_Location_of_Study__pc = accLocation;
                update accToUpdate;

                
    }
    
    @RemoteAction
    global static Integer validateMettingsToday(String accId) {
        List<Booking__c> todayBook = [SELECT Id FROM Booking__c WHERE Account__c =: accId AND CreatedDate >=: Date.today()];
        return todayBook.size();
    }
    
    
}