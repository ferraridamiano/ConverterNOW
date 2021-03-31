# Welcome

We invite you to join our team! Everyone is welcome to contribute code via pull requests and filing issues on GitHub. You can contribute in different ways. Do you think you are not capable to contribute? I will prove you are wrong. Let's get started!

## Translating the app

Right now the app is translated in English, Italian, Portuguese, French, Norwegian and German. If you know other languages and wants to help internationalizing take a look at the most updated instruction [here](https://github.com/ferraridamiano/ConverterNOW/issues/2). Than, if you want you can also translate the PlayStore/F-droid app page. You can find the page to translate [here](https://github.com/ferraridamiano/ConverterNOW/tree/master/fastlane/metadata/android/en-US). If you have some question please contact me via e-mail or submit a new issue. That's all, I will take care of the rest. Thank you!

## Design a new logo

If you think you are able to do a better app icon you are welcome to open a new issue with your proposal. Than I can tell you how you can merge you idea to this project. Thank you!

## Submit a PR

If you feel confident with Flutter coding, you can help me improving this app by submitting a PR. But first, let me explain you how this project is organized.

### Project structure

The project uses [provider](https://github.com/rrousselGit/provider) for state management and it helps separate the UI from the model. Right now there are two models: [AppModel.dart](https://github.com/ferraridamiano/ConverterNOW/blob/master/lib/models/AppModel.dart) contains the basic logic of the app (which page is selected, in which order, etc.) and [Conversions.dart](https://github.com/ferraridamiano/ConverterNOW/blob/master/lib/models/Conversions.dart) contains the logic of the conversion section (retrieve currencies rates from the Internet, in which order are the units of measurement, etc.). You might say: "Why don't you just make one model?", the answer is: because I plan to also make a [tools section](https://github.com/ferraridamiano/ConverterNOW/issues/6) and so it is more organized.

### Add new units

If you want to add new units I wrote a [wiki page](https://github.com/ferraridamiano/ConverterNOW/wiki/Add-a-new-unit-of-measurement), it is a step by step guide.

## What if I am too lazy?

You should exit from your comfort zone and find out what it feels to submit a PR and merge it to an open source project! When you do it you feel like a little bit of this project is also yours and all the people that use this app will enjoy your contributions! But if you are too too lazy you can contribute with a small [PayPal donation](https://www.paypal.com/paypalme/DemApps) to let the developer see your interest. Thank you!

