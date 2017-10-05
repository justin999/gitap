//
//  ShareViewController.swift
//  GitapShareExtension
//
//  Created by Koichi Sato on 2017/09/28.
//  Copyright © 2017 Koichi Sato. All rights reserved.
//

import UIKit
import Social
import Photos

class ShareViewController: SLComposeServiceViewController {
    
//    override func beginRequest(with context: NSExtensionContext) {
//        print(context)
//    }

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.

        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.

        if let extensionContext = self.extensionContext,
            let item = extensionContext.inputItems.first as? NSExtensionItem,
            let attachment = item.attachments?.first as? NSItemProvider {
            print("sharing image: \(item)")
            
            attachment.loadDataRepresentation(forTypeIdentifier: "public.image", completionHandler: { (data, error) in
                if error != nil {
                    print("do somthing to inform error")
                    return
                }

                if data != nil {
                    print("data fetched: \(data)")
                }
            })
        }



        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        let item:SLComposeSheetConfigurationItem = SLComposeSheetConfigurationItem()
        item.title = "repos"
        item.value = "not set"
        item.tapHandler = { () in
            print("tapped handler")
            let reposViewController = UIViewController()
            self.pushConfigurationViewController(reposViewController)
        }
        return [item]
    }
    
    

}
