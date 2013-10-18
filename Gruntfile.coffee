module.exports = (grunt)->
	require('load-grunt-tasks')(grunt)
	require('time-grunt')(grunt)

	myConf =
		build: 'build'
		version: '0.2.0'

	grunt.initConfig
		myConf: myConf
#		clean: ['build/*']
#			build:
#				files: [{
##					expand: true
##					flatten: true
#					dot: true
#					src: ['<%= myConf.build %>/*']
#				}]

		coffee:
			options:
				bare: true
			build:
				files: [{
						expand: true,
						src: 'oktell-voice.coffee',
						dest: '<%= myConf.build %>',
						ext: '.js'
				}]
		concat:
			build:
				options:
					banner: "/*\n * Oktell-voice.js\n * version <%= myConf.version %>\n * http://js.oktell.ru/js/voice/\n */\n\n"
				files: [
					{
						src: [
							'jssip-0.3.7.js',
							'oktell-voice.js'
						]
						dest: '<%= myConf.build %>/oktell-voice.js'
					}
				]
		uglify:
			build:
				files: {
					'<%= myConf.build %>/oktell-voice.min.js': [
						'<%= myConf.build %>/oktell-voice.js'
					]
				}

		replace:
			build:
				src: ['oktell-voice.*']
				overwrite: true
				replacements: [{
					from: /okVoice.version = '[0-9\.]+'/g,
					to: "okVoice.version = '<%= myConf.version %>'"
				}]
			bower:
				src: ['bower.json']
				overwrite: true
				replacements: [{
					from: /"version": "[0-9\.]+",/,
					to: '"version": "<%= myConf.version %>",'
				}]



	grunt.registerTask 'build', [
		'replace',
		'coffee:build',
		'concat:build',
		'uglify:build'
	]

	grunt.registerTask 'default', [
		'build'
	]
