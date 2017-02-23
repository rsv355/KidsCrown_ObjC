//
//  KidsCrownUrlSchema.h
//  Kids Crown
//
//  Created by Webmyne Systems Inc.
//  Copyright (c) 2016 Webmyne Systems Inc. All rights reserved.
//

#ifndef Kids_Crown_KidsCrownUrlSchema_h
#define Kids_Crown_KidsCrownUrlSchema_h


#define Kids_Crown_BASEURL @"http://ws-srv-net.in.webmyne.com/Applications/KidsCrown/KidsCrownWS_V01/Services/"

//#define Kids_Crown_BASEURL @"http://ws.kidscrown.in/Services/"

#define USERLOGIN @"%@/User.svc/json/UserLogin/%@/%@"

#define FORGETPASSWORD @"User.svc/json/ForgotPassword"

#define USERREGISTRATION @"User.svc/json/UserRegistration"

#define FETCH_CURRENT_PRICING @"Master.svc/json/FetchCurrentPricing"

#define FETCH_CURRENT_PRICING_FORMOBILE @"Master.svc/json/FetchCurrentPricingForMobile?ProductId="

#define FETCHDETAIL @"%@User.svc/json/FetchUserProfile/%@"

#define FETCH_DISCOUNT @"Order.svc/json/GetRecentDiscount"

#define UPDATE @"User.svc/json/UpdateUserProfile"

#define LoginWithSocialMedia @"%@User.svc/json/LoginWithSocialMedia/%@/%@"

#define SignUpWithSocialMedia @"User.svc/json/SignUpWithSocialMediaWithMobileOS"

#define LoginWithFacebook @"User.svc/json/LoginWithSocialMedia"

#define FETCT_SHIPPING_ADDRESS @"Master.svc/json/FetchShippingAddresses?UserId="

#define PostShippingAddress @"Master.svc/json/AddNewShippingAddress"


#define badgeColor [UIColor colorWithRed:238.0f/255.0f green:150.0f/255.0f blue:33.0f/255.0f alpha:1.0f]

//http://ws-srv-net.in.webmyne.com/Applications/KidsCrown/KidsCrownWS_V01/Services/User.svc/json/UserRegistration

#define FETCH_ORDER @"Order.svc/json/FetchOrdersApp?UserId="

#define PLACE_ORDER @"Order.svc/json/PlaceOrder"


#define INTRO_KIT_ID @"14"

#define ASSORTED_KIT_ID @"15"



///// NEW WEB SERVICES


// -> FOR DEVELOPING

//#define NEW_BASE_URL @"http://ws-srv-net.in.webmyne.com/Applications/KidsCrown_V03/WCF/Services/"


// -> FOR TESTING

//#define NEW_BASE_URL @"http://ws-srv-net/Applications/KidsCrown_V03_Testing/wcf/Services/"

// -> FOR LIVE

#define NEW_BASE_URL @"http://wcf.kidscrown.in/Services/"




#define ABOUT_US @"Home.svc/json/GetAboutUsDetail"

#define CONTACT_US @"Home.svc/json/GetPageDetails"

#define FETCH_ALL_PRODUCT_DETAIL @"Product.svc/json/GetProducts"

#define NEW_LOGIN_SIGNUP_URL @"User.svc/json/LoginSignup"

#define UPDATE_PROFILE_DETAIL @"User.svc/json/UpdateUserProfile"

#define NEW_FETCH_ORDER_HISTORY @"Product.svc/json/OrderHistory/"

#define NEW_PLACE_ORDER @"Product.svc/json/PlaceOrder"

#define FETCH_PROFILE_DETAIL @"User.svc/json/UserProfile/"

#define CHECK_APP_VERSION @"User.svc/json/GetDeviceInfo/"

#define NEW_FORGET_PASSWORD @"User.svc/json/ForgotPassword/"

#define NEW_FETCH_STATELIST @"Product.svc/json/GetStateList"



#endif
