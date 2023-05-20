import breeze.ClassName;
import breeze.rule.Background;
import breeze.rule.Border;
import breeze.rule.Flex;
import breeze.rule.Grid;
import breeze.rule.Layout;
import breeze.rule.Sizing;
import breeze.rule.Spacing;
import breeze.rule.Transition;
import breeze.rule.Typography;
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
		borderWidth(1),
		borderStyle('solid'),
		borderColor('black', 0),
		breeze.Css.rule('
			--test: #ccc;
			background-color: var(--test);
		')
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
					font('sans'),
					fontSize('base'),
					fontWeight('bold'),
					modifier('hover', bgColor('gray', 50))
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
					bgColor('sky', 500),
					borderStyle('dotted'),
					borderColor('black', 0),
					borderWidth('2px'),
					width('50px'),
					height('50px'),
					animation('bounce'),
					modifier('hover', animation('pulse'), textColor('white'), bgColor('black', 0)),
					display('flex'),
					alignItems('center'),
					justify('center')
				]),
				children: 'weee'
			}),
			new Html<'div'>({
				className: ClassName.ofArray([
					bgColor('black', 0),
					width('50px'),
					height('50px'),
					animation('spin'),
					textColor('white'),
					display('flex'),
					alignItems('center'),
					justify('center')
				]),
				children: 'woo'
			})
		]
	}));
}
