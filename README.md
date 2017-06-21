pic2shop-client
===============

Android and iOS client apps for the mobile barcode scanners *pic2shop* ® and
*pic2shop PRO*.

**This is not a barcode scanner.** This code demonstrates how to call pic2shop
from another app and how to retrieve the result.


About pic2shop and pic2shop PRO
-------------------------------

**Pic2shop** is a free barcode scanner app available for iOS® and Android®.
It reads UPC-A, UPC-E, EAN-13, EAN-8 and QR codes. The app also
display comparison shopping results for UPC and EAN.

**Pic2shop PRO** is a paid app available for iOS and Android.  In addition to the
barcode symbologies supported by pic2shop, it reads Code 39, Code 128, Code 93, ITF(Interleaved 2 of 5), Standard 2 of 5 (aka Code 25 or Ind2of5), and Codabar (aka USD-4, NW-7). After each scan, the app
displays a user-defined url with the barcode string as parameter in the embedded
web browser.

[Pic2shop] [1] and [pic2shop PRO] [2] are developed by [Vision Smarts] [3].


Why use pic2shop as external scanner?
-------------------------------------

In contrast with most barcode scanner apps and open source libraries, pic2shop can
read UPCs and EANs on all devices, including those without autofocus. Pic2shop and
pic2shop PRO can quickly decode the "blurry" barcodes captured by the iPod® Touch,
the iPad®, the iPad3 front camera and the many Android devices without autofocus.
To decode the other barcode formats, all the bars need to be visible.

It can also be faster and easier to implement a call to an external scanner, as
shown in this project, than to integrate a full-fledged scanner library.


Contents
--------

`iOS/` Xcode project with sample iOS app. The call to pic2shop and callback use
the iOS custom URL scheme mechanism.

`Android/` Eclipse project with sample Android app. The call to pic2shop uses the
Android Intent mechanism.


Functionalities
---------------

* Checks whether pic2shop and/or pic2shop PRO are installed
* Offers to install them if necessary
* Displays a selection of barcode formats supported by the apps currently
installed
* Calls pic2shop or pic2shop PRO to perform the scan
* Receives and displays the barcode string


Trademarks
----------

IPHONE, IPOD and IPAD are trademarks of Apple Inc., registered in the U.S. and
other countries. 
IOS is a trademark or registered trademark of Cisco in the U.S. and other
countries. 
ANDROID is a trademark of Google Inc. 

[1]: http://www.pic2shop.com                  "pic2shop"
[2]: http://www.pic2shop.com/pro_version.html "pic2shop PRO"
[3]: http://www.visionsmarts.com              "Vision Smarts"


