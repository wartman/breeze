# Breeze

Breeze is a port (more or less) of [Tailwind](https://tailwindcss.com/) into Haxe.

## Usage

Breeze is a css-in-haxe library that works very much like Tailwind, just using macros instead of class names. While it _can_ create and apply css at runtime, it's designed to generate a css file at compile time. This means that Breeze has very little overhead -- it compiles away to class name strings, a few helper functions and nothing else.

Here's a simple example of what Breeze looks like in action:

```haxe
import Breeze;

final box = Breeze.compose(
	Flex.display(),
	Spacing.pad('y', 1),
	Spacing.pad('x', 2),
	Border.radius(3),
	Border.width(1),
	Border.style('solid'),
	Filter.dropShadow('md'),
	Modifier.hover(Filter.dropShadow('xxl')),
	ColorScheme.light(Border.color('black', 0)),
	ColorScheme.dark(Border.color('white', 0)),
	Css.rule('
		--test: #ccc;
		background-color: var(--test);
	')
);
```

> Todo: more details about how all this works.

## Compiler Setup

By default, Breeze will output a file named `styles.css` next to the compiler output. You can configure this with the `-D breeze.output` flag:

```hxml
# Don't output anything:
-D breeze.output=none
# Don't output anything, but generate code for runtime
# styles:
-D breeze.output=runtime
# Output css to the given file name, relative to the
# compiler output path (a `css` extension will be added automatically): 
-D breeze.output=app-styles
# Output css relative to the current working directory
# (a `css` extension will be added automatically): 
-D breeze.output=cwd:assets/styles
# Output css to an absolute path:
-D breeze.output=abs:../project/assets/styles
```
