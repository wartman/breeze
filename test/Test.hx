import styles.*;

using Breeze;

function main() {
	var itemStyle:ClassName = [
		Spacing.pad('y', 1),
		Spacing.pad('x', 2),
		Border.radius(3),
		Border.width(1),
		Border.style('solid'),
		ColorScheme.light(Border.color('black', 0)),
		ColorScheme.dark(Border.color('white', 0)),
		Filter.dropShadow('md'),
		Modifier.hover(Border.style('dotted'), Filter.dropShadow('xxl')),
		Breakpoint.viewport('lg',
			Modifier.hover(Border.style('solid'), Filter.dropShadow('xl')),
			Container.box(3),
			Container.box(5)
		),
		Css.rule('
			--test: #ccc;
			background-color: var(--test);
		')
	];
	trace(itemStyle);
}
