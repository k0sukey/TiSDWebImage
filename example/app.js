// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var win = Ti.UI.createWindow({
	backgroundColor: '#fff'
});
win.open();

// TODO: write your module tests here
var TiSDWebImage = require('be.k0suke.tisdwebimage');
Ti.API.info("module is => " + TiSDWebImage);

Ti.API.info("module exampleProp is => " + TiSDWebImage.exampleProp);
TiSDWebImage.exampleProp = "This is a test value";

var progress = Ti.UI.createProgressBar({
	top: 20,
	width: Ti.UI.FILL,
	min: 0,
	max: 100,
	value: 0
});
win.add(progress);
progress.show();

var image = TiSDWebImage.createView({
	width: 259,
//	width: Ti.UI.FILL,
	height: 203,
//	height: Ti.UI.FILL,
	image: 'http://www.appcelerator.com/wp-content/uploads/titanium_sdk_blue.png',
	hires: true,
	options: TiSDWebImage.CACHE_MEMORY_ONLY
});
win.add(image);

image.addEventListener('progress', function(e){
	if (e.expected > 0) {
		progress.applyProperties({
			value: Math.round(e.received / e.expected * 100)
		});
	}
});

image.addEventListener('completed', function(e){
	console.log(e);
});

image.addEventListener('error', function(e){
	console.log('error');
});