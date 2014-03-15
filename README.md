MapKitDemo
==================

Purpose
-------

Based on [Superpin](http://getsuperpin.com)'s Airports demo application.

This demo showcases three distinct features:

* Dynamic `MKAnnotationView` Subclasses
* Animated Clustering of `MKAnnotationViews` (using [`ARClusteredMapView`](https://github.com/alexrepty/ARClusteredMapView))
* Customised Selection Behaviour for `MKAnnotationViews`

Bug reports and/or pull requests welcome.

Usage
-----

Clone/download and open using Xcode.

Caveats
-------

* This is a demo app to showcase a few techniques for enhancing the use of MapKit, nothing more.
* The clustering is using an extremely slow algorithm, especially compared to something like [Superpin](http://getsuperpin.com). It will work for a few hundred annotations at best.

Scope
-----

Developed and tested using Xcode 5.1 and iOS 7.1