Router.configure({
  layoutTemplate: 'layout'
});

Router.map(function() {
	this.route('home', {
		path: '/',
		template: 'grid'
	});
	return this.route('config', {
		path: '/?hash=:config',
		template: 'grid'
	});
});