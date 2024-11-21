# Carousel

This package provides a custom implementation of the `CenteredPageView` widget that behaves like the default `PageView`, but with `padEnds: false` while centered elements, and an optional dot indicator.

## Difference

Default `PageView`. Elements align based on scroll position but are not centered.
![Default PageView](https://github.com/user-attachments/assets/312fe08b-6792-4907-99fb-104d01c3bf02)

Package `CenteredPageView`. Items snap to a centered position.
![Centered PageView](https://github.com/user-attachments/assets/d5863f8e-16e6-4c2e-a390-048bea6ab581)

## Features

- A `CenteredPageView` widget that centers items while retaining the default properties of the `PageView`.
- Customizable optional dot indicator below the `CenteredPageView`.

## Usage

Here's how to implement `CenteredPageView` in your Flutter app:

```dart
CenteredPageView.builder(
  itemCount: 9,
  controller: PageController(viewportFraction: 0.8),
  showIndicator: true, // Set to 'false' if you do not want to display the dot indicator
  indicatorStyle: const IndicatorStyle(
      indicatorWidth: 100, unselectedSize: Size(8, 8)),
  itemBuilder: (context, index) => Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(color: Colors.amber),
      child: Align(
        child: Text(
          'Page $index',
          style: const TextStyle(fontSize: 16.0),
        ),
      )),
),
```

Customizing the Dot Indicator

- The `showIndicator` property is a boolean that controls the visibility of the dot indicator.
- The `indicatorStyle` property allows you to customize the appearance of the dot indicator.
