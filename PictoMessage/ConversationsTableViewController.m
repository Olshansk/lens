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

#define CELL_HEIGHT 100
#define PAGE_TITLE NSLocalizedString(@"New Message", @"New Message")
#define SEARCH_BAR_HEIGHT 50
#define SEARCH_PLACEHOLDER_TEXT NSLocalizedString(@"Enter a name or phone number...", @"Enter a name or phone number...")
@implementation ConversationsTableViewController {
    NSMutableArray *contactsWithAccounts;
    NSMutableArray *contactsWithoutAccounts;
    UITableView *tableView;
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

    contactsWithAccounts = [[NSMutableArray alloc] init];
    contactsWithoutAccounts = [[NSMutableArray alloc] init];
    
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, PORTRAIT_STATUS_NAV_BAR_HEIGHT, self.view.frame.size.width, SEARCH_BAR_HEIGHT)];
//    [searchBar setBackgroundColor:[UIColor clearColor]];

    UITextField *searchBar = [[UITextField alloc] initWithFrame:CGRectMake(0, PORTRAIT_STATUS_NAV_BAR_HEIGHT, self.view.frame.size.width, SEARCH_BAR_HEIGHT)];
    [searchBar setKeyboardType:UIKeyboardTypeNamePhonePad];
//    [searchBar setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [searchBar setPlaceholder:SEARCH_PLACEHOLDER_TEXT];
    [searchBar setBackgroundColor:[UIColor whiteColor]];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [searchBar bottomLeftY], self.view.frame.size.width, self.view.frame.size.height - searchBar.frame.size.height)];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    
//    [self setEdgesForExtendedLayout:UIExtendedEdgeBottom];
    
    
//    [tableView setTableHeaderView:searchBar];
    
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"logged_in"]) {
        [self loadContacts];
//    }

    [self setTitle:PAGE_TITLE];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[DataSingleton sharedSingleton] background]]];
    
//    [tableView setBackgroundView:];
//    [tableView setContentOffset:CGPointMake(0, 64)];
    
    [self.view addSubview:imageView];
    [self.view addSubview:searchBar];
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    Person *p = [contactsWithAccounts objectAtIndex:indexPath.row];

//    for (Conversation *convo in [[DataSingleton sharedSingleton] conversations]) {
//        if ([[convo reciever] isEqual:p]) {
//            [convoViewController setConversation:convo];
//            [[self navigationController] pushViewController:convoViewController animated:YES];
//            return;
//        }
//    }

    Conversation *convo = [[Conversation alloc] init];

    [convo setReciever:p];
    
    NSDictionary *params = @{AUTH_TOKEN_PARAM: [[DataSingleton sharedSingleton] openUDID], USER_PHONE_PARAM: [[p activePhoneNumbers] objectAtIndex:0], PARAM_PHONE : [[[[DataSingleton sharedSingleton] user] activePhoneNumbers] objectAtIndex:0]};
    NSString *from = CONVERSATION_ROOT;
    
    [NetworkProtocol post:params to:from withSuccessBlock:^(NSDictionary * dict) {
        [convo setConvoID:[dict objectForKey:CONVO_ID_KEY]];
        [convoViewController setConversation:convo];
        [[self navigationController] pushViewController:convoViewController animated:YES];
    }];
    
}

#pragma mark Address Book Fetching

-(void) loadContacts
{
    [self fetchContacts:^(NSArray *contacts) {
        
        contactsWithoutAccounts = [[NSMutableArray alloc] initWithArray:contacts];
        
        NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
        for (Person *person in contacts) {
            for (NSMutableDictionary *dict in [person phoneNumbers]) {
                [phoneNumbers addObject:[dict objectForKey:PHONE_NUMBER]];
            }
        }
        
        NSDictionary *params = @{AUTH_TOKEN_PARAM: [[DataSingleton sharedSingleton] openUDID], PHONES_PARAM: phoneNumbers};
        NSString *from = [NSString stringWithFormat:@"%@",CHECK_PHONES_ROOT];
        
        [NetworkProtocol put:params from:from withSuccessBlock:^(NSDictionary * dict) {
            for (NSDictionary * personDict in [dict objectForKey:KEY_FOR_FRIENDS_WITH_ACCOUNTS]) {
                NSString *phone = [personDict objectForKey:PHONE_KEY];
                for (Person *person in contacts) {
                    for (NSMutableDictionary *phonesDict in [person phoneNumbers]) {
                        if ([[phonesDict objectForKey:PHONE_NUMBER] isEqualToString:phone]) {
                            [[person phoneNumbers] removeObject:phone];
                            [[person activePhoneNumbers] addObject:phone];
                            
                            if ([phonesDict objectForKey:PROFILE_PIC_KEY] != [NSNull null]) {
                                [person setProfilePhoto:[phonesDict objectForKey:PROFILE_PIC_KEY]];
                            }
                            
                            [contactsWithAccounts addObject:person];
                            [contactsWithoutAccounts removeObject:person];
                            goto person_chosen;
                        }
                    }
                }
            person_chosen:;
            }
            [tableView reloadData];

            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"logged_in"];
            
            [[DataSingleton sharedSingleton] setUsersWithAccounts:[[NSMutableArray alloc] initWithArray:contactsWithAccounts]];
            [[DataSingleton sharedSingleton] save];

            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
        }];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

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

static void readAddressBookContacts(ABAddressBookRef addressBook, void (^completion)(NSArray *contacts)) {
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    CFArrayRef people  = ABAddressBookCopyArrayOfAllPeople(addressBook);
    for(int i = 0;i < ABAddressBookGetPersonCount(addressBook); i++)
    {
        
        ABRecordRef ref = CFArrayGetValueAtIndex(people, i);
        
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(ref,kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(ref,kABPersonLastNameProperty);
        
        NSMutableArray *arPhone = [[NSMutableArray alloc] init];
        ABMultiValueRef phones = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
        {
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
            NSString *phoneLabel =(__bridge NSString*) ABAddressBookCopyLocalizedLabel (ABMultiValueCopyLabelAtIndex(phones, j));
            NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
            [temp setObject:phoneNumber forKey:PHONE_NUMBER];
            [temp setObject:phoneLabel forKey:PHONE_LABEL];
            [arPhone addObject:temp];
        }
        
        ABMultiValueRef emails = ABRecordCopyValue(ref, kABPersonEmailProperty);
        NSMutableArray *arEmail = [[NSMutableArray alloc] init];
        for(CFIndex idx = 0; idx < ABMultiValueGetCount(emails); idx++)
        {
            CFStringRef emailRef = ABMultiValueCopyValueAtIndex(emails, idx);
            NSString *strLbl = (__bridge NSString*) ABAddressBookCopyLocalizedLabel (ABMultiValueCopyLabelAtIndex (emails, idx));
            NSString *strEmail_old = (__bridge NSString*)emailRef;
            NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
            [temp setObject:strEmail_old forKey:EMAIL];
            [temp setObject:strLbl forKey:EMAIL_LABEL];
            [arEmail addObject:temp];
        }
        
        Person *p = [[Person alloc] init];
        [p setUserName:[NSString stringWithFormat:@"%@ %@",firstName, lastName]];
        [p setPhoneNumbers:arPhone];
        [p setEmails:arEmail];
        
        [contacts addObject:p];
    }
    completion(contacts);
}



@end
