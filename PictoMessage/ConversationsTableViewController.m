//
//  ConversationsTableViewController.m
//  PictoMessage
//
//  Created by Daniel Olshansky on 2013-06-01.
//  Copyright (c) 2013 Daniel Olshansky. All rights reserved.
//
#import <AddressBook/AddressBook.h>

#import "ConversationsTableViewController.h"
#import "ConversationViewController.h"
#import "DataSingleton.h"
#import "defs.h"
#import "NetworkProtocol.h"
#import "Person.h"
#import "ConversationsTableViewControllerDefs.h"
#import "Conversation.h"

#import "AccountTableViewCell.h"
#import "UIView+EasyDimensions.h"
#import "NSArray+CoreDataArray.h"

#import "PhoneNumber.h"
#import "Email.h"

#define CELL_HEIGHT 100
#define PAGE_TITLE NSLocalizedString(@"New Message", @"New Message")
#define SEARCH_BAR_HEIGHT 50
#define SEARCH_PLACEHOLDER_TEXT NSLocalizedString(@"Enter a name or phone number...", @"Enter a name or phone number...")

@implementation ConversationsTableViewController {
    NSArray *contactsWithAccounts;
    NSArray *contactsWithoutAccounts;
    UITableView *peopleTableView;
}

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:PAGE_TITLE];
    
    contactsWithAccounts = [[NSMutableArray alloc] init];
    contactsWithoutAccounts = [[NSMutableArray alloc] init];

    UITextField *searchBar = [[UITextField alloc] initWithFrame:CGRectMake(0, PORTRAIT_STATUS_NAV_BAR_HEIGHT, self.view.frame.size.width, SEARCH_BAR_HEIGHT)];
    [searchBar setKeyboardType:UIKeyboardTypeNamePhonePad];
    [searchBar setPlaceholder:SEARCH_PLACEHOLDER_TEXT];
    [searchBar setBackgroundColor:[UIColor whiteColor]];
    
    peopleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [searchBar bottomLeftY], self.view.frame.size.width, self.view.frame.size.height - searchBar.frame.size.height)];
    [peopleTableView setDataSource:self];
    [peopleTableView setDelegate:self];
    [peopleTableView setBackgroundColor:[UIColor clearColor]];
    
    [self loadContacts];
//    [self retrieveAllConversations];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[DataSingleton sharedSingleton] background]]];
    
    [self.view addSubview:imageView];
    [self.view addSubview:searchBar];
    [self.view addSubview:peopleTableView];
}

#define CONVERSATION_RETRIEVAL_KEY @"conversations"
#define CONVERSATION_PHONE_KEY @"phone"

-(void)retrieveAllConversations
{
    AppDelegate *delegate = APP_DELEGATE;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSDictionary *params = @{AUTH_TOKEN_PARAM: [[DataSingleton sharedSingleton] openUDID], PARAM_PHONE : [[DataSingleton sharedSingleton] phoneNumber]};
    NSString *from = CONVERSATION_ROOT;
    
    [NetworkProtocol get:params from:from withSuccessBlock:^(NSDictionary * dictionary) {
        for (NSDictionary *dict in [dictionary objectForKey:CONVERSATION_RETRIEVAL_KEY]) {
            
            NSArray *personArray = [NSArray arrayFromCoreDataWithEntityName:@"Person" andPredicateFormat:[NSString stringWithFormat:@"ANY phonenumbers.phoneNumber == %@", [dict objectForKey:CONVERSATION_PHONE_KEY]]];
            
            if ([personArray count] == 0) {
                [self loadContacts];
                return;
            }
            
            Person *person = [personArray objectAtIndex:0];
            if (person.conversation == nil) {
                Conversation *conversation = [NSEntityDescription insertNewObjectForEntityForName:@"Conversation" inManagedObjectContext:context];
                [conversation setConversationID:[NSString stringWithFormat:@"%@",[dict objectForKey:CONVO_ID_KEY]]];
                [conversation setPerson:person];
                [person setConversation:conversation];
            }
            
        }
        [delegate saveContext];
    }];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [contactsWithAccounts count];
    } else if (section == 1) {
        return [contactsWithoutAccounts count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AccountTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        [cell updateLayoutWithHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath]];
    }
    if (indexPath.section == 0) {
    Person *p = [contactsWithAccounts objectAtIndex:indexPath.row];
    
    [cell setName:[p userName]];
    [cell setProfileImg:[UIImage imageNamed:@"wolf.jpg"]];
    [cell updateData];
    } else {
        Person *p = [contactsWithoutAccounts objectAtIndex:indexPath.row];
        
        [cell setName:[p userName]];
        [cell setProfileImg:[UIImage imageNamed:@"wolf.jpg"]];
        [cell updateData];
        
    }
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerReuseIdentifier = @"TableViewSectionHeaderViewIdentifier";
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerReuseIdentifier];
    if (view == nil) {
        view = [[UIView alloc] init];
    }
    
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:HEADER_VIEW_ALPHA];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [tableView sectionHeaderHeight])];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    
    if (section == 0) {
        [label setText:WITH_ACCOUNT_TABLE_HEADER];
    } else if (section == 1) {
        [label setText:WITHOUT_ACCOUNT_TABLE_HEADER];
    }
    
    [view addSubview:label];
    
    return view;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConversationViewController *convoViewController = [[ConversationViewController alloc] init];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        Person *p = [contactsWithAccounts objectAtIndex:indexPath.row];
        Conversation *conversation;
        AppDelegate *delegate = APP_DELEGATE;
        NSManagedObjectContext *context = [delegate managedObjectContext];

        
        NSArray *array = [NSArray arrayFromCoreDataWithEntityName:@"Conversation" andPredicateFormat:[NSString stringWithFormat: @"person.personID == %@", [p personID]]];
        
        if ([array count] != 0) {
            conversation = [array objectAtIndex:0];
            NSLog(@"Existing conversation with: %@", [conversation conversationID]);
            [convoViewController setConversation:conversation];
            [cell setSelected:NO];
            [[self navigationController] pushViewController:convoViewController animated:YES];
            return;
        }
        
        conversation = [NSEntityDescription insertNewObjectForEntityForName:@"Conversation" inManagedObjectContext:context];

        [conversation setPerson:p];
        [p setConversation:conversation];
    
        NSString *friendPhone = @"";
        for (PhoneNumber *phone in [p phonenumbers]) {
            if ([[phone isActive] boolValue]) {
                friendPhone = [phone phoneNumber];
                break;
            }
        }
    
        NSDictionary *params = @{AUTH_TOKEN_PARAM: [[DataSingleton sharedSingleton] openUDID], USER_PHONE_PARAM: friendPhone, PARAM_PHONE : [[DataSingleton sharedSingleton] phoneNumber]};
        NSString *from = CONVERSATION_ROOT;
    
        [NetworkProtocol post:params to:from withSuccessBlock:^(NSDictionary * dict) {
            [conversation setConversationID:[NSString stringWithFormat:@"%@",[dict objectForKey:CONVO_ID_KEY]]];
            NSLog(@"New conversation with: %@", [conversation conversationID]);
            [delegate saveContext];
            [convoViewController setConversation:conversation];
            [cell setSelected:NO];
            [[self navigationController] pushViewController:convoViewController animated:YES];
        }];
    } else if (indexPath.section == 2) {
        
    }
}

#pragma mark Address Book Fetching

#define ADDRESS_NAME_KEY @"ADDRESS_NAME_KEY"
#define ADDRESS_PHONE_KEY @"ADDRESS_PHONE_KEY"
#define ADDRESS_EMAIL_KEY @"ADDRESS_EMAIL_KEY"
#define ADDRESS_PERSON_KEY @"ADDRESS_PERSON_KEY"

/* Sets up the two arrays for users with existing and non existing account using some filtering of the database. */
 -(void)loadContactsFromCoreData
 {
     NSArray *contacts = [self getAllContacts];
 
    contactsWithAccounts = [contacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"ANY phonenumbers.isActive == YES"]];
    contactsWithoutAccounts = [contacts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"ANY phonenumbers.isActive == NO"]];
 }

/* Returns an array of all the Person objects in the core data databse. */
-(NSArray *)getAllContacts
{
    NSArray *contacts = [NSArray arrayFromCoreDataWithEntityName:@"Person" andPredicateFormat:nil];
    return contacts;
}

-(void)loadContacts
{
    [self fetchContacts:^(NSArray *contacts) {
        
        AppDelegate *delegate = APP_DELEGATE;
        NSManagedObjectContext *context = [delegate managedObjectContext];
        
        NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in contacts) {
            
            NSArray *array = [NSArray arrayFromCoreDataWithEntityName:@"Person" andPredicateFormat:[NSString stringWithFormat: @"personID == %@", [dict objectForKey:ADDRESS_PERSON_KEY]]];
            
            if ([array count] == 0) {
                    [self createUser:dict];
                    for (NSString *phoneNumber in [dict objectForKey:ADDRESS_PHONE_KEY]) {
                        [phoneNumbers addObject:phoneNumber];
                    }
                } else {
                    Person *p = [array objectAtIndex:0];
                    NSArray *personPhoneNumbers = [[p phonenumbers] allObjects];
                    NSArray *personActivePhoneNumbers = [personPhoneNumbers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isActive == YES"]];
                    NSArray *personInactivePhoneNumbers = [personPhoneNumbers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isActive == NO"]];
                    
                    for (NSString *phoneNumber in [dict objectForKey:ADDRESS_PHONE_KEY]) {
                        
                        int activeIndex = [personActivePhoneNumbers indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                            PhoneNumber *checkPhoneNumber = (PhoneNumber *)obj;
                            if ([[checkPhoneNumber phoneNumber] isEqualToString:phoneNumber]) {
                                return YES;
                            }
                            return NO;
                        }];
                        
                        int inactiveIndex = [personInactivePhoneNumbers indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                            PhoneNumber *checkPhoneNumber = (PhoneNumber *)obj;
                            if ([[checkPhoneNumber phoneNumber] isEqualToString:phoneNumber]) {
                                return YES;
                            }
                            return NO;
                        }];
                        
                        if (activeIndex != NSNotFound) {
                            PhoneNumber *number = [personActivePhoneNumbers objectAtIndex:activeIndex];
                            if (![[number isActive] boolValue]) {
                                [phoneNumbers addObject:phoneNumber];
                            }
                        } else if (inactiveIndex != NSNotFound) {
                            PhoneNumber *number = [personInactivePhoneNumbers objectAtIndex:inactiveIndex];
                            if (![[number isActive] boolValue]) {
                                [phoneNumbers addObject:phoneNumber];
                            }
                        } else {
                            PhoneNumber *number = [NSEntityDescription insertNewObjectForEntityForName:@"PhoneNumber" inManagedObjectContext:context];
                            [number setIsActive:@NO];
                            [number setPhoneNumber:phoneNumber];
                            [number setPhonenumberowner:p];
                            [p addPhonenumbersObject:number];
                            
                            [phoneNumbers addObject:phoneNumber];
                        }
                    }
            }
        }
        
        NSDictionary *params = @{AUTH_TOKEN_PARAM: [[DataSingleton sharedSingleton] openUDID], PHONES_PARAM: phoneNumbers};
        NSString *from = [NSString stringWithFormat:@"%@",CHECK_PHONES_ROOT];
        
        [NetworkProtocol put:params from:from withSuccessBlock:^(NSDictionary * dict) {
            for (NSDictionary * personDict in [dict objectForKey:KEY_FOR_FRIENDS_WITH_ACCOUNTS]) {
                
                NSString *phone = [personDict objectForKey:PHONE_KEY];
                
                NSArray *array = [NSArray arrayFromCoreDataWithEntityName:@"PhoneNumber" andPredicateFormat:[NSString stringWithFormat: @"phoneNumber == %@", phone]];
                
                PhoneNumber *phoneNumber = [array objectAtIndex:0];
                [phoneNumber setIsActive:@YES];

            }
            
            AppDelegate *delegate = APP_DELEGATE;
            [delegate saveContext];
            
            [self loadContactsFromCoreData];
            [self retrieveAllConversations];
            [peopleTableView reloadData];
        }];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

/* Creates a new Person record in core data using the dictionaries derived below. Each phone number is 
   initially set to being inactive. */
-(void)createUser:(NSDictionary *)dict
{
    AppDelegate *delegate = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
    NSManagedObjectContext *context = [delegate managedObjectContext];
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
 
    [person setUserName:[dict objectForKey:ADDRESS_NAME_KEY]];

    for (NSString *phone in [dict objectForKey:ADDRESS_PHONE_KEY]) {
        PhoneNumber *number = [NSEntityDescription insertNewObjectForEntityForName:@"PhoneNumber" inManagedObjectContext:context];
        [number setIsActive:@NO];
        [number setPhoneNumber:phone];
        [number setPhonenumberowner:person];
        [person addPhonenumbersObject:number];
    }

    for (NSString *fullEmail in [dict objectForKey:ADDRESS_EMAIL_KEY]) {
        Email *email = [NSEntityDescription insertNewObjectForEntityForName:@"Email" inManagedObjectContext:context];
        [email setEmail:fullEmail];
        [email setEmailOwner:person];
        [person addEmailsObject:email];
    }
    
    [person setPersonID:[dict objectForKey:ADDRESS_PERSON_KEY]];
    
    [delegate saveContext];
}

/* A wrapper method used to retrieve the array of dictionaries of users. This method asks the user
   for permission to access their contact list as well. */
- (void)fetchContacts:(void (^)(NSArray *contacts))success failure:(void (^)(NSError *error))failure {
    CFErrorRef err;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &err);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!granted) {
                failure((__bridge NSError *)error);
            } else {
                readAddressBookContacts(addressBook, success);
            }
        });
    });
}

/* Returns an array of dictionaries of "raw" contacts. Each dictionary contains the name of the person,
   an array of their emails, an array of their phone numbers, and their unique user ID.*/
static void readAddressBookContacts(ABAddressBookRef addressBook, void (^completion)(NSArray *contacts)) {
    CFArrayRef people  = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < ABAddressBookGetPersonCount(addressBook); i++)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        ABRecordRef ref = CFArrayGetValueAtIndex(people, i);
        
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(ref,kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(ref,kABPersonLastNameProperty);
        NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        [dict setValue:name forKey:ADDRESS_NAME_KEY];

        ABMultiValueRef phones = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        NSMutableArray *phonesArray = [[NSMutableArray alloc] init];
        CGFloat numOfPhoneNumbers = ABMultiValueGetCount(phones);
        if (numOfPhoneNumbers == 0)
            continue;
        for(CFIndex j = 0; j < numOfPhoneNumbers; j++)
        {
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
            NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            [phonesArray addObject:phoneNumber];
        }
        [dict setValue:phonesArray forKey:ADDRESS_PHONE_KEY];
        
        ABMultiValueRef emails = ABRecordCopyValue(ref, kABPersonEmailProperty);
        NSMutableArray *emailsArray = [[NSMutableArray alloc] init];
        for(CFIndex idx = 0; idx < ABMultiValueGetCount(emails); idx++)
        {
            CFStringRef emailRef = ABMultiValueCopyValueAtIndex(emails, idx);
            NSString *strEmail_old = (__bridge NSString*)emailRef;
            [emailsArray addObject:strEmail_old];
        }
        [dict setValue:emailsArray forKey:ADDRESS_EMAIL_KEY];
        
        NSInteger uniqueID = ABRecordGetRecordID(ref);
        NSString* stringID = [NSString stringWithFormat:@"%d", uniqueID];
        [dict setValue:stringID forKey:ADDRESS_PERSON_KEY];
        
        [contacts addObject:dict];
    }
    
    completion(contacts);
}



@end
