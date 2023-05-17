import breeze.ClassName;
import breeze.rule.Background;
import breeze.rule.Border;
import breeze.rule.Flex;
import breeze.rule.Grid;
import breeze.rule.Layout;
import breeze.rule.Spacing;
import breeze.variant.Breakpoint;
import breeze.variant.Pseudo;
import js.Browser;
import pine.html.Html;
import pine.html.client.Client;

function main() {
	var itemStyle:ClassName = [
		pad('y', 1),
		pad('x', 2),
		borderRadius(3),
		borderStyle('solid'),
		borderColor('black', 0),
		breeze.Css.rule('--test: #ccc; background-color: var(--test)')
	];

	mount(Browser.document.getElementById('root'), () -> new Html<'div'>({
		className: ClassName.ofArray([container('md'), breakpoint('lg', container('lg')), margin('x', 'auto')]),
		children: [
			new Html<'div'>({
				className: ClassName.ofArray([
					display('grid'),
					gridColumns(2),
					breakpoint('sm', gridColumns(3)),
					breakpoint('lg', gridColumns(4)),
					gap(3),
					breakpoint('sm', modifier('hover', bgColor('slate', 50)))
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
		]
	}));
}
