# CYRTextView

by **Illya Busigin**

- Visit my blog at [http://illyabusigin.com/](http://illyabusigin.com/)
- Follow [@illyabusigin on Twitter](http://twitter.com/illyabusigin)

Purpose
--------------

CYRTextView is a UITextView subclass that implements a variety of features that are relevant to a syntax or code text view. There are many subclasses of UITextView out there with the release of TextKit but none that are specifically tailred towards a code/syntax view. CYRTextView aims to change this. Features include:
- Regular expression based text highlighting with support for multiple text attributes for each expression
- Line numbers
- Gesture based navigation


Requirements
-----------------------------

iOS 7.0 or later (**with ARC**) for iPhone, iPad and iPod touch


Installation
---------------

To use CYRTextView, just drag the class files into your project and add the CoreText framework. You can create CYRTextView instances programatically, or create them in Interface Builder by dragging an ordinary UITextView into your view and setting its class to CYRTextView.

If you are using Interface Builder, to set the custom properties of CYRTextView (ones that are not supported by regular UIViews) either create an IBOutlet for your view and set the properties in code, or use the User Defined Runtime Attributes feature in Interface Builder (introduced in Xcode 4.2 for iOS 5+).


Example
---------------

CYRTextView includes an example project that demonstrates how to subclass CYRTextView to provide highlighting behavior for multiple attributes with a default set of normal, bold, and italic fonts.
