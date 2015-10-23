module.exports = (grunt)->
  #Load grunt tasks
  grunt.loadNpmTasks 'grunt-gh-pages'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-cssmin'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  #Configure tasks
  grunt.initConfig
    jshint: 
      all: ['src/scripts/**/*.js', 'test/**/*.js']

    jasmine:
      test:
        options :
          specs : 'test/**/*spec.js'
          template: require 'grunt-template-jasmine-requirejs'
          templateOptions: 
            requireConfigFile: 'src/scripts/main.js'
            requireConfig: baseUrl: 'src/scripts' 
          junit : path : 'junit' 

    requirejs: 
      compile: 
        options:
          baseUrl: 'dist/scripts'
          out: 'dist/scripts/main.js'
          name: 'main'
          mainConfigFile: 'dist/scripts/main.js'

    less: 
      development:
        options:
          paths: ['less', 'src/vendor/bootstrap/less']
        files: 'src/css/app.css' : 'src/less/app.less'
    
    cssmin: 
      build:
        src: 'dist/css/app.css'
        dest: 'dist/css/app.css'

    watch: 
      files: "src/less/*"
      tasks: ["less"]

    clean:
      prep:['dist', 'junit', 'src/css']

    copy: 
      build:
        files: [ expand: true, cwd: 'src/', src: ['**'], dest : 'dist' ]

    'gh-pages':
      options:
        base: 'dist'
        user:
          name: 'Bamboo',
          email: 'bamboo@ceh.ac.uk'
      qa:   
        options: branch: 'qa-pages'
        src: '**/*'
      prod: src: '**/*'
 
    connect: 
      development: 
        options: port: 8081, base: 'src'

  grunt.registerTask 'bower-install', ->
    require('bower').commands.install().on('end', do @async)

  grunt.registerTask 'prep', ['clean', 'bower-install']
  grunt.registerTask 'test', ['jshint', 'jasmine']
  grunt.registerTask 'develop', ['connect', 'less', 'watch']
  grunt.registerTask 'build', ['less', 'test', 'copy', 'cssmin', 'requirejs']
  grunt.registerTask 'publish-prod', ['build', 'gh-pages:prod']
  grunt.registerTask 'publish-qa', ['build', 'gh-pages:qa']
  grunt.registerTask 'default', ['prep', 'build'] #register the default task as build
