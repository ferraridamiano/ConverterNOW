<div align="center">

# Converter NOW

[<img src="https://img.shields.io/github/contributors/ferraridamiano/ConverterNOW?style=flat-square"
    alt="Contributors"
    height="30">](https://github.com/ferraridamiano/ConverterNOW/graphs/contributors)
[<img src="https://img.shields.io/static/v1?style=for-the-badge&message=PWA&color=5A0FC8&logo=PWA&logoColor=FFFFFF&label="
    alt="Open web app"
    height="30">](https://converter-now.web.app)
[<img src="https://img.shields.io/static/v1?style=for-the-badge&message=PayPal&color=00457C&logo=PayPal&logoColor=FFFFFF&label="
    alt="Donate paypal"
    height="30">](https://www.paypal.me/DemApps)

<img src="fastlane/metadata/android/en-US/images/phoneScreenshots/1.jpeg" width="140"> <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/2.jpeg" width="140"> <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/3.jpeg" width="140"> <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/4.jpeg" width="140"> <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/5.jpeg" width="140">
</div>

## Why Converter NOW

A few years ago I noticed that most of the unit converters on the digital stores were ugly, not immediately usable, with ads and tracking software. I thought it would be a  good idea to develop Converter NOW in order to solve all these problems!

🚀 It is made to be **easy**, **fast** and **immediately** useable: just start typing and immediately you have the real-time conversion  with all the other units of measurement

🖌️ It is **customizable**: the units can be reorganized according to your priorities and your use case

🔢 It integrates a **Calculator** that let you do the calculations in every page

💰 Currency conversions are **updated daily**

⚫⚪ **Choose your favourite theme**: dark or white theme

📱🖥️ **Full Smartphone, Tablet and Web app support**

💯 It is **free**, **no ads**, **no analytics**, **no permissions** (just Internet to update currency conversions). And first of all it is **open source**!

## Installation


### Android

Install the app from the app stores:

[<img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png"
    alt="Get it on Google Play"
    height="72">](https://play.google.com/store/apps/details?id=com.ferrarid.converterpro)
[<img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png"
    alt="Get it on F-Droid"
    height="72">](https://f-droid.org/packages/com.ferrarid.converterpro)

Otherwise, if you want to compile the code you first need to [install flutter](https://docs.flutter.dev/get-started/install), then you have to disable the signing option in [`android/app/build.gradle`](https://github.com/ferraridamiano/ConverterNOW/blob/master/android/app/build.gradle#L70) (just comment that line). Then you can type `flutter build apk --split-per-abi` to compile the code. You can find the output in `build/app/outputs/apk/release` folder.

### Linux

Install the app from the app stores:

[<img src="https://flathub.org/assets/badges/flathub-badge-en.png"
    alt="Download on Flathub"
    height="55">](https://flathub.org/apps/details/io.github.ferraridamiano.ConverterNOW)
[<img src="https://snapcraft.io/static/images/badges/en/snap-store-black.svg"
    alt="Get it from the Snap Store"
    height="55">](https://snapcraft.io/converternow)

Otherwise, if you want to compile the code, you first need to [install flutter](https://docs.flutter.dev/get-started/install), then type `flutter build linux`. You can find the output in `build/linux/x64/release/bundle`.

### Windows

Install the app from the app store:

[<img src="https://getbadgecdn.azureedge.net/images/English_L.png"
    alt="Get it from the Microsoft Store"
    height="60">](https://www.microsoft.com/store/apps/9P0Q79HWJH72)

Otherwise, if you want to compile the code, you first need to [install flutter](https://docs.flutter.dev/get-started/install), then type `flutter build windows`. You can find the output in `build/windows/runner/Release`.

### Web
You can reach the PWA [here]().

Otherwise, if you want to compile the code, you first need to [install flutter](https://docs.flutter.dev/get-started/install), then type `flutter build web`. You can find the output in `build/web`.

### iOS and MacOS
The app is not tested against iOS and MacOS, but you should be able to compile it even for these platforms. You first need to [install flutter](https://docs.flutter.dev/get-started/install), then generate the platform specific code and then compile them.