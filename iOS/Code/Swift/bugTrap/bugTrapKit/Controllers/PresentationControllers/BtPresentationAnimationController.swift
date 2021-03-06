//
//  BtPresentationAnimationController.swift
//  bugTrap
//
//  Created by Colby L Williams on 11/19/14.
//  Copyright (c) 2014 bugTrap. All rights reserved.
//

import UIKit

class BtPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

	let isPresenting :Bool
    let duration :NSTimeInterval = 0.5

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting

        super.init()
    }


    // ---- UIViewControllerAnimatedTransitioning methods

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning)  {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext)
        }
        else {
            animateDismissalWithTransitionContext(transitionContext)
        }
    }


    // ---- Helper methods

    func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
		if let presentedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) {
			if let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey) {

				if let containerView = transitionContext.containerView() {

					// Position the presented view off the top of the container view
					presentedControllerView.frame = transitionContext.finalFrameForViewController(presentedController)
					presentedControllerView.center.y -= containerView.bounds.size.height

					containerView.addSubview(presentedControllerView)

					// Animate the presented view to it's final position
					UIView.animateWithDuration(self.duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .AllowUserInteraction, animations: {
						presentedControllerView.center.y += containerView.bounds.size.height
						}, completion: {(completed: Bool) -> Void in
							transitionContext.completeTransition(completed)
					})
				}
			}
		}
    }

    func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
		if let presentedControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey) {
			if let containerView = transitionContext.containerView() {

				// Animate the presented view off the bottom of the view
				UIView.animateWithDuration(self.duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .AllowUserInteraction, animations: {
					presentedControllerView.center.y += containerView.bounds.size.height
					}, completion: {(completed: Bool) -> Void in
						transitionContext.completeTransition(completed)
				})
			}
		}
    }
}