# Liquid Loader

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Liquid Loader is a Flutter plugin that creates animated liquid effects inside custom-shaped bottles. It supports various bottle shapes (spherical, triangular, and rectangular) with dynamic animations for the liquid and waves. The package also provides animated bubbles, glossy effects, and customizable colors to make the liquid effect look more realistic.

## License

This package is licensed under the BSD-3-Clause License. See the [LICENSE](LICENSE) file for more details.

## Features

- Animated liquid waves in custom-shaped bottles.
- Bubbles with random movements inside the bottle.
- Glossy overlay effect for a shiny liquid appearance.
- Supports different bottle shapes: spherical, triangular, and rectangular.
- Fully customizable colors for the liquid, border, and cap.
- Easy to use and integrate into any Flutter app.

## Installation

To install the `liquid_loader` package, add the following dependency in your `pubspec.yaml` file:

## Example

      LiquidLoader(
         liquidColor: Colors.green, // Custom green liquid
         borderColor: Colors.red,   // Red border
         capColor: Colors.orange,   // Orange cap
         liquidLevel: 0.8,          // 80% liquid level
         shape: Shape.triangle,     // Triangular bottle shape
         text: '80%',               // Display text inside the bottle
         textStyle: TextStyle(color: Colors.black, fontSize: 18),
      )



## Parameters

- width: The width of the loader (in pixels).
- height: The height of the loader (in pixels).
- liquidColor: The color of the liquid inside the bottle.
- borderColor: The color of the bottle's border.
- capColor: The color of the cap on the bottle.
- liquidLevel: The level of liquid inside the bottle (0.0 to 1.0).
- text: Optional text to display inside the bottle.
- textStyle: Optional styling for the text inside the bottle.
- shape: The shape of the bottle. It can be Shape.circle, Shape.triangle, or Shape.rectangle.
- hideCap: If set to true, the cap will be hidden

## Contribution

We welcome contributions to this package! If you find bugs or want to suggest improvements, feel free to open an issue or submit a pull request on GitHub.

## Contact
For any inquiries, please reach out to mfarooqiqbal143@gmail.com


### Key Sections:

1. **Introduction**: Provides a description of the package and its features.
2. **License**: Specifies the BSD-3-Clause license for the package.
3. **Features**: Lists key features of the package.
4. **Installation**: Provides steps for installing the package in a Flutter project.
5. **Usage**: Gives an example of how to use the `LiquidLoader` widget with customizable parameters.
6. **Customization**: Explains how to further customize the liquid loader's appearance and behavior.
7. **Example Application**: Provides instructions on running the example app.
8. **Contribution**: Encourages contributions and provides instructions on how to contribute.
9. **Contact**: Provides contact details for inquiries.
10. **Footer**: Shows the author’s name with a nice touch.

This `README.md` provides all necessary information to help users get started with your `liquid_loader` package and integrate it into their apps. Let me know if you need further adjustments or additions!


Made with ❤️ by Muhammad Farooq Iqbal

```yaml
dependencies:
  liquid_loader: any
