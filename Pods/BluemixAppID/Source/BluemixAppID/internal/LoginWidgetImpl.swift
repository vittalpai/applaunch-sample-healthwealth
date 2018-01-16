/* *     Copyright 2016, 2017 IBM Corp.
 *     Licensed under the Apache License, Version 2.0 (the "License");
 *     you may not use this file except in compliance with the License.
 *     You may obtain a copy of the License at
 *     http://www.apache.org/licenses/LICENSE-2.0
 *     Unless required by applicable law or agreed to in writing, software
 *     distributed under the License is distributed on an "AS IS" BASIS,
 *     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *     See the License for the specific language governing permissions and
 *     limitations under the License.
 */


import Foundation

public class LoginWidgetImpl: LoginWidget {

    var oauthManager:OAuthManager
    init(oauthManager:OAuthManager) {
        self.oauthManager = oauthManager
    }

    public func launch(accessTokenString: String? = nil, delegate: AuthorizationDelegate) {
        self.oauthManager.authorizationManager?.launchAuthorizationUI(accessTokenString: accessTokenString, authorizationDelegate: delegate)
    }
    
    public func launchSignUp(_ delegate: AuthorizationDelegate) {
        self.oauthManager.authorizationManager?.launchSignUpAuthorizationUI(authorizationDelegate: delegate)
    }
    
    public func launchChangePassword(_ delegate: AuthorizationDelegate) {
        self.oauthManager.authorizationManager?.launchChangePasswordUI(authorizationDelegate: delegate)
    }
    
    public func launchChangeDetails(_ delegate: AuthorizationDelegate) {
        self.oauthManager.authorizationManager?.launchChangeDetailsUI(authorizationDelegate: delegate)
    }
    
    public func launchForgotPassword(_ delegate: AuthorizationDelegate) {
        self.oauthManager.authorizationManager?.launchForgotPasswordUI(authorizationDelegate: delegate)
    }

}
