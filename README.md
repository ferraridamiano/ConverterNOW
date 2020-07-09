# Converter NOW

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/DemApps)

### Why Converter NOW

Converter NOW is an effective unit and currencies converter

🚀 It is made to be **easy**, **fast** and **immediate** to use: just start typing and immediately you have the real-time conversion  with all the other units of measurement

🖌️ It is **customizable**: the units can be reorganized according to your priorities and your use

🔢 It integrates a **Calculator** that let you do the calculations in every page

💰 Currencies conversions are **daily updated**

⚫⚪ **Choose your favourite theme**: dark and white theme

📱🖥️ **Full Smartphone, Tablet and Web app support**

💯 It is **free**, **no ads**, **no analytics**, **no permission** (just internet to update currencies conversions). And first of all it is **open source**!

🔗 [Play Store link](https://play.google.com/store/apps/details?id=com.ferrarid.converterpro)

🔗 [Web App link](https://ferraridamiano.github.io/ConverterNOW/)

### Screenshots

<img src="screenshots/SS_android_01.jpg" width="160"> <img src="screenshots/SS_android_02.jpg" width="160"> <img src="screenshots/SS_android_03.jpg" width="160"> <img src="screenshots/SS_android_04.jpg" width="155">

<img src="screenshots/SS_web_01.png" width="645">

The upper 4 screenshots show the main screen of the app on an android phone. The screenshot below shows how easy the app adapts on large screens in a PWA.

### Why I made Converter NOW

Few years ago I noticed that most of the unit converters on the digital stores were ugly, not immediate to be used, with tons of useless tools. I tought it would be a  good idea to develope a unit converter app that solve all this problems.

That year (2018) I first heard of Flutter, it still was in beta, but I decided to build it with this modern framework anyway, just to learn more. My friend Giovanni made the app logo for me and I launched it on the Play Store.

The project is not well structured. I made it to learn more on programming. **It is not perfect but I hope that with your help we can improve it!**

How can you improve it? Open issues (or feature requests), send pull requests, fork, star, share, donate to this project. Or you can just tell me this app is useful for you. 

### Structure of the project

<img src="images/graph01.png" width="645">

### Conversion algorithm

I imagined a conversion as a tree graph. Here I reported part of the graph of the length conversion:

<img src="images/graph02.png" width="300">

As you can see, all units depends by other units by 1 (or more) costant. Most of the conversion between two units x and y can be done with one of these structures:

<img src="http://www.sciweavers.org/tex2img.php?eq=y%20%3D%20ax%2Bb&bc=White&fc=Black&im=jpg&fs=12&ff=arev&edit=0" width="90" height="19" />

<img src="http://www.sciweavers.org/tex2img.php?eq=y%3D%5Cfrac%7Ba%7D%7Bx%7D%2Bb&bc=White&fc=Black&im=jpg&fs=12&ff=arev&edit=0" width="83" height="40" />

The first one is the most common linear conversion (the costant help with faraday-celsius conversion). The second one is used in fuel conversion like km/l  to l/100 km.

It can also be defined other types of custom conversion such between different numeral system (bynary-octal-decimal-exadecimal).

Once a *textFormField* is selected the unit node in the graph has the property *selectedNode* equals to true (and all other *selectedNode* in every other node are marked as false). When the user changes the value of the *textFormField* the conversion propagates from the node which the user has interact with to all other nodes. Once a node is converted the *convertedNode* property of the node is setted to true.
