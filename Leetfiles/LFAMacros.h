//
//  LFAMacros.h
//  Leetfiles
//
//  Created by Guillermo Moran on 1/23/15.
//  Copyright (c) 2015 Fr0st Development. All rights reserved.
//

#import "Keychain.h"
#import "LFAConnector.h"
#import "UAObfuscatedString.h"


#define LFA_KEYCHAIN_USER [KeychainManager getStringForKey:Obfuscate.l.e.e.t.f.i.l.e.s.u.s.e.r]
#define LFA_KEYCHAIN_PASS [KeychainManager getStringForKey:Obfuscate.l.e.e.t.f.i.l.e.s.p.a.s.s]

#define LFA_IS_LOGGED_IN [LFAConnector isLoggedIn]

#define keyForUser(user,pass) [LFAConnector userAPIKeyForUsername:user Password:pass]
#define isValidLogin(apiKey) [LFAConnector isValidAPIKey:apiKey]

#define internetAvailable [LFAConnector isConnectedToTheInternet]

#define F_STORAGE @"f_limit"
#define F_STORAGE_USED @"f_limit_used"
#define I_STORAGE @"i_limit"
#define I_STORAGE_USED @"i_limit_used"
#define P_LIMIT @"p_limit"
#define P_LIMIT_USED @"p_limit_used"


