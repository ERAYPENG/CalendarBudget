//
//  LoadingIndicator.swift
//  CalendarBudget
//
//  Created by ERAY on 2021/3/6.
//

import Foundation
import NVActivityIndicatorView

class LoadingIndicator {

    var activityData: ActivityData?

    init() {
        activityData = ActivityData(type:.ballClipRotatePulse)
        
    }

    func start() {
        if activityData == nil {
            activityData = ActivityData()
        }
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData!, nil)
    }

    func stop() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
}
