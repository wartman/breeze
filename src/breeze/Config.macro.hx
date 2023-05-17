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
		'slate' => ['50' => '#f8fafc', '100' => '#f1f5f9', '200' => '#e2e8f0']
	];

	public function new() {}
}
