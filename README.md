# neon-ios-framework

## General Information
A dynamic Cocoa Touch iOS framework wrapping the [neon](http://www.webdav.org/neon/) WebDAV library.

Original neon source code can be found on the neon web page.

Contains binaries of neon and its dependencies build for iOS basing on the following source code versions:
- [neon](http://www.webdav.org/neon/): 0.30.1
- [expat](http://expat.sourceforge.net/): 2.2.0  
- [libssl](https://www.openssl.org/): 1.0.2h
- [zlib](http://www.zlib.net/): 1.2.8

They were built for iOS using the (slightly updated) compile script available at: https://github.com/bygreencn/Neon-iOS-static

The iOS project contains an aggregate target named **Neon-Universal** that builds a fat version of the framework containing 
both the device (arm7, arm64) and simulator (i386, x86_64) architectures. The simulator architectures have to be stripped 
before submitting your app to the AppStore using `lipo`.

## Licensing
This code is licensed using [LGPL](https://www.gnu.org/copyleft/lgpl.html). This is because neon itself is using LGPL.

Licensing of other components:
- neon: [LGPL](https://www.gnu.org/copyleft/lgpl.html)
- expat: [MIT License](https://opensource.org/licenses/MIT) 
- libssl: [OpenSSL License](https://www.openssl.org/source/license.txt)
- zlib: [zlib License](http://www.zlib.net/zlib_license.html)

