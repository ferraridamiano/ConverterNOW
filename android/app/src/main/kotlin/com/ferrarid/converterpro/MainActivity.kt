package com.ferrarid.converterpro

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.animation.AnimatorSet
import android.animation.ObjectAnimator
import android.os.Build
import android.os.Bundle
import android.view.View
import android.view.animation.AnticipateInterpolator
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Custom exit animation for the splash screen on Android 12+ (API 31+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            splashScreen.setOnExitAnimationListener { splashScreenView ->
                val iconView = splashScreenView.iconView

                val animatorSet = AnimatorSet()

                // Only animate the icon if it actually exists
                if (iconView != null) {
                    val iconScaleX = ObjectAnimator.ofFloat(iconView, View.SCALE_X, 1f, 1.4f)
                    val iconScaleY = ObjectAnimator.ofFloat(iconView, View.SCALE_Y, 1f, 1.4f)
                    val iconAlpha = ObjectAnimator.ofFloat(iconView, View.ALPHA, 1f, 0f)
                    val viewAlpha = ObjectAnimator.ofFloat(splashScreenView, View.ALPHA, 1f, 0f)
                    animatorSet.playTogether(iconScaleX, iconScaleY, iconAlpha, viewAlpha)
                } else {
                    // Fallback: just fade out the whole splash screen
                    val viewAlpha = ObjectAnimator.ofFloat(splashScreenView, View.ALPHA, 1f, 0f)
                    animatorSet.play(viewAlpha)
                }

                animatorSet.duration = 500L
                animatorSet.interpolator = AnticipateInterpolator()

                animatorSet.addListener(object : AnimatorListenerAdapter() {
                    override fun onAnimationEnd(animation: Animator) {
                        splashScreenView.remove()
                    }
                })

                animatorSet.start()
            }
        }
    }
}
