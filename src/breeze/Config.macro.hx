package breeze;

class Config {
	public static function load(?file:String) {
		// @todo: this will load a JSON file relative to the
		// project root. If a file is found, it will be parsed and *merged*
		// with the default Config options (*not* overwritten).
		//
		// This should be run as an initialization macro.
		//
		// Alternatively, the user could just add a custom initialization
		// macro where they manually configure the Config instance.
	}

	public static function instance() {
		static var config:Null<Config> = null;
		if (config == null) config = new Config();
		return config;
	}

	public var includePreflight:Bool = true;
	public var preflight = breeze.core.Preflight.defaultPreflight;
	public final fontFamilies:Map<String, String> = [
		'sans' =>
		'ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji"',
		'serif' => 'ui-serif, Georgia, Cambria, "Times New Roman", Times, serif',
		'mono' => 'ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace'
	];
	public final fontSizes:Map<String, {size:String, lineHeight:String}> = [
		'base' => {size: '1rem', lineHeight: '1.5rem'},
		'xs' => {size: '.75rem', lineHeight: '1rem'},
		'sm' => {size: '.875rem', lineHeight: '1.25rem'},
		'lg' => {size: '1.125rem', lineHeight: '1.75rem'},
		'xl' => {size: '1.25rem', lineHeight: '1.75rem'},
		'xxl' => {size: '1.5rem', lineHeight: '2rem'},
		'3xl' => {size: '1.875rem', lineHeight: '2.25rem'},
		'4xl' => {size: '2.25rem', lineHeight: '2.5rem'},
		'5xl' => {size: '3rem', lineHeight: '1'},
		'6xl' => {size: '3.75rem', lineHeight: '1'},
		'7xl' => {size: '4.5rem', lineHeight: '1'},
		'8xl' => {size: '6rem', lineHeight: '1'},
		'9xl' => {size: '8rem', lineHeight: '1'}
	];
	public final fontWeights = [
		'thin' => '100',
		'extralight' => '200',
		'light' => '300',
		'normal' => '400',
		'medium' => '500',
		'semibold' => '600',
		'bold' => '700',
		'extrabold' => '800',
		'black' => '900'
	];
	public final tracking = [
		'tighter' => '-0.05em',
		'tight' => '-0.025em',
		'normal' => '0em',
		'wide' => '0.025em',
		'wider' => '0.05em',
		'widest' => '0.1em'
	];
	public final leading = [
		'none' => '1',
		'tight' => '1.25',
		'snug' => '1.375',
		'normal' => '1.5',
		'relaxed' => '1.625',
		'loose' => '2'
	];
	public final containerSizes = [
		'sm' => '640px',
		'md' => '768px',
		'lg' => '1024px',
		'xl' => '1280px',
		'xxl' => '1536px',
	];
	public final breakpoints = [
		'sm' => '640px',
		'md' => '768px',
		'lg' => '1024px',
		'xl' => '1280px',
		'xxl' => '1536px'
	];
	public final colors:Map<String, Map<String, String>> = [
		'black' => ['0' => 'rgb(0 0 0)'],
		'white' => ['0' => 'rgb(255 255 255)'],
		'gray' => [
			'50' => 'rgb(249, 249, 249)',
			'100' => 'rgb(244, 244, 245)',
			'200' => 'rgb(228, 228, 231)',
			'300' => 'rgb(212, 212, 216)',
			'400' => 'rgb(161, 161, 171)',
			'500' => 'rgb(113, 113, 122)',
			'600' => 'rgb(82, 82, 91)',
			'700' => 'rgb(63, 63, 70)',
			'800' => 'rgb(39, 39, 42)',
			'900' => 'rgb(24, 24, 27)',
			'950' => 'rgb(19, 19, 22)'
		],
		'sky' => [
			'50' => 'rgb(240, 249, 255)',
			'100' => 'rgb(224, 242, 254)',
			'200' => 'rgb(186, 230, 253)',
			'300' => 'rgb(125, 211, 252)',
			'400' => 'rgb(56, 189, 248)',
			'500' => 'rgb(14, 165, 233)',
			'600' => 'rgb(2, 132, 199)',
			'700' => 'rgb(3, 105, 161)',
			'800' => 'rgb(7, 89, 133)',
			'900' => 'rgb(12, 74, 110)',
			'950' => 'rgb(11, 50, 73)',
		],
		'green' => [
			'50' => 'rgb(240, 253, 244)',
			'100' => 'rgb(220, 252, 231)',
			'200' => 'rgb(187, 247, 208)',
			'300' => 'rgb(134, 239, 172)',
			'400' => 'rgb(74, 222, 128)',
			'500' => 'rgb(34, 197, 94)',
			'600' => 'rgb(22, 163, 74)',
			'700' => 'rgb(21, 128, 61)',
			'800' => 'rgb(22, 101, 52)',
			'900' => 'rgb(20, 83, 45)',
			'950' => 'rgb(12, 49, 27)',
		],
		'red' => [
			'50' => 'rgb(254, 242, 242)',
			'100' => 'rgb(254, 226, 226)',
			'200' => 'rgb(254, 202, 202)',
			'300' => 'rgb(252, 165, 165)',
			'400' => 'rgb(248, 113, 113)',
			'500' => 'rgb(239, 68, 68)',
			'600' => 'rgb(220, 38, 38)',
			'700' => 'rgb(185, 28, 28)',
			'800' => 'rgb(153, 27, 27)',
			'900' => 'rgb(127, 29, 29)',
			'950' => 'rgb(80, 20, 20)',
		],
		// @todo: more
	];
	public final animations:Map<String, String> = [
		'spin' => '1s linear infinite',
		'ping' => '1s cubic-bezier(0, 0, 0.2, 1) infinite',
		'pulse' => '2s cubic-bezier(0.4, 0, 0.6, 1) infinite',
		'bounce' => '1s infinite'
	];
	public final keyframes:Map<String, Map<String, String>> = [
		'spin' => ['from' => 'transform: rotate(0deg)', 'to' => 'transform: rotate(360deg)'],
		'ping' => ['75%, 100%' => 'transform: scale(2); opacity: 0'],
		'pulse' => ['0%, 100%' => 'opacity: 1', '50%' => 'opacity: .5'],
		'bounce' => [
			'0%, 100%' => 'transform: translateY(-25%); animation-timing-function: cubic-bezier(0.8, 0, 1, 1)',
			'50%' => 'transform: translateY(0); animation-timing-function: cubic-bezier(0, 0, 0.2, 1)'
		]
	];

	public function new() {}
}
