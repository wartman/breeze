import js.Browser;
import pine.html.Html;
import pine.html.client.Client;

using Breeze;

function main() {
	var itemStyle:ClassName = [
		Spacing.pad('y', 1),
		Spacing.pad('x', 2),
		Border.radius(3),
		Border.width(1),
		Border.style('solid'),
		Border.color('black', 0),
		ColorScheme.dark(Border.color('white', 0)),
		Filter.dropShadow('md'),
		Modifier.hover(Filter.dropShadow('xxl')),
		Css.rule('
			--test: #ccc;
			background-color: var(--test);
		')
	];

	mount(Browser.document.getElementById('root'), () -> new Html<'div'>({
		className: ClassName.ofArray([
			Layout.container('md'),
			Breakpoint.markContainer('box', 'inline-size'),
			Breakpoint.viewport('lg', Layout.container('lg')),
			ColorScheme.dark(Background.color('gray', 500)),
			Spacing.margin('x', 'auto')
		]),
		children: [
			new Html<'div'>({
				className: ClassName.ofArray([
					Grid.display(),
					Grid.columns(2),
					Breakpoint.viewport('sm', Grid.columns(3)),
					Breakpoint.viewport('lg', Grid.columns(4)),
					Flex.gap(3),
					Typography.font('sans'),
					Typography.fontSize('base'),
					Typography.fontWeight('bold'),
					Modifier.hover(Background.color('gray', 50))
				]),
				children: [
					new Html<'div'>({
						className: itemStyle,
						children: 'woo'
					}),
					new Html<'div'>({
						className: itemStyle,
						children: 'woo'
					}),
					new Html<'div'>({
						className: itemStyle,
						children: 'woo'
					}),
					new Html<'div'>({
						className: itemStyle,
						children: 'yay'
					})
				]
			}),
			new Html<'div'>({
				className: ClassName.ofArray([
					// Background.color('sky', 500),
					Border.style('dotted'),
					Border.color('black', 0),
					Border.color('top', 'red', 300),
					Border.color('bottom', 'rgb(0,0,0)'),
					Border.width('2px'),
					Sizing.width('50px'),
					Sizing.height('50px'),
					Transition.animation('bounce'),
					Breakpoint.container('box', '400px', Background.color('red', 300)),
					Modifier.hover(Transition.animation('pulse'), Typography.textColor('white', 0), Background.color('black', 0)),
					Layout.display('flex'),
					Flex.alignItems('center'),
					Flex.justify('center')
				]),
				children: 'weee'
			}),
			new Html<'div'>({
				className: ClassName.ofArray([
					Background.color('black', 0),
					Sizing.width('50px'),
					Sizing.height('50px'),
					Transition.animation('spin'),
					Typography.textColor('rgba(255,255,255,0.5)'),
					Flex.display(),
					Flex.alignItems('center'),
					Flex.justify('center')
				]),
				children: 'woo'
			})
		]
	}));
}
