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

[<img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png"
    alt="Get it on Google Play"
    height="60">](https://play.google.com/store/apps/details?id=com.ferrarid.converterpro)
[<img src="https://fdroid.gitlab.io/artwork/badge/get-it-on.png"
    alt="Get it on F-Droid"
    height="60">](https://f-droid.org/packages/com.ferrarid.converterpro)
[<img src="https://getbadgecdn.azureedge.net/images/English_L.png"
    alt="Get it from the Microsoft Store"
    height="60">](https://www.microsoft.com/store/apps/9P0Q79HWJH72)
[<img src="https://snapcraft.io/static/images/badges/en/snap-store-black.svg"
    alt="Get it from the Snap Store"
    height="55">](https://snapcraft.io/converternow)

<img src="fastlane/metadata/android/en-US/images/phoneScreenshots/1.jpeg" width="140"> <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/2.jpeg" width="140"> <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/3.jpeg" width="140"> <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/4.jpeg" width="140"> <img src="fastlane/metadata/android/en-US/images/phoneScreenshots/5.jpeg" width="140">
</div>

## Why Converter NOW

Converter NOW is an effective unit and currency converter

🚀 It is made to be **easy**, **fast** and **immediately** useable: just start typing and immediately you have the real-time conversion  with all the other units of measurement

🖌️ It is **customizable**: the units can be reorganized according to your priorities and your use case

🔢 It integrates a **Calculator** that let you do the calculations in every page

💰 Currency conversions are **updated daily**

⚫⚪ **Choose your favourite theme**: dark or white theme

📱🖥️ **Full Smartphone, Tablet and Web app support**

💯 It is **free**, **no ads**, **no analytics**, **no permissions** (just Internet to update currency conversions). And first of all it is **open source**!

## Why I made Converter NOW

A few years ago I noticed that most of the unit converters on the digital stores were ugly, not immediately usable, with tons of useless tools. I thought it would be a  good idea to develop a unit converter app that solve all this problems.

That year (2018) I first heard of Flutter. It still was in beta, but I decided to build it with this modern framework anyway, just to learn more. My friend Giovanni made the app logo for me and I launched it on the Play Store.

The project is not well structured. I made it to learn more about programming. **It is not perfect but I hope that with your help we can improve it!**

How can you improve it? Just star the repo and take a look at [contributing file](https://github.com/ferraridamiano/ConverterNOW/blob/master/CONTRIBUTING.md).

## Installation
You can either install this app from the main app stores or compile it from the source code.

**If you want to directly install this app for your platform check the direct links at the top of this README**.

If you choose the second option you have first to [install flutter](https://docs.flutter.dev/get-started/install) and have all the tools specific for the target platform (e.g. Android studio for Android, Visual Studio for Windows etc.). Make sure everything is right with  `flutter doctor`. Then, clone this project and `cd` to the directory. Type `flutter pub get` to get all the dependencies and generate the code for the translations.

### Android
First, you have to disable the signing option in [`android/app/build.gradle`](https://github.com/ferraridamiano/ConverterNOW/blob/master/android/app/build.gradle#L70) (just comment that line). Then you can type `flutter build apk --split-per-abi` to compile the code. You can find the output in `build/app/outputs/apk/release` folder.

### Linux
Type `flutter build linux` to compile the code. You can find the output in `build/linux/x64/release/bundle`.

### Windows
A compiled installer for Windows is already availavble in the [release section](https://github.com/ferraridamiano/ConverterNOW/releases).

Otherwise, type `flutter build windows` to compile the code. You can find the output in `build/windows/runner/Release`.

### Web
Type `flutter build web` to compile the code. You can find the output in `build/web`.

### Other platforms
You should be able to run this app also on iOS and MacOS, however I've not tested it. You can try and let me know.
