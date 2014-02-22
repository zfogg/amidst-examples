module.exports = (grunt) ->

  require("load-grunt-tasks") grunt

  require("time-grunt") grunt


  grunt.initConfig
    amidst:

      app:   "client"
      srv:   "server"

      tmp:   ".tmp"
      dist:  "public"


    express:
      options:
        cmd: "coffee"

      dev:
        options:
          script: "amidst.coffee"
          node_env: "development"
          port: process.env.PORT or 8000

      prod:
        options:
          script: "amidst.coffee"
          node_env: "production"
          port: process.env.PORT or 80


    prettify:
      dist:
        expand: true
        cwd:  "<%= amidst.dist %>"
        src:  "**/*.html"
        dest: "<%= amidst.dist %>"

    watch:
      views_templates:
        files: [
          "<%= amidst.app %>/**/*.jade",
          "!<%= amidst.app %>/index.jade"
        ]
        tasks: [ "newer:jade:templates" ]
      views_index:
        files: [ "<%= amidst.app %>/index.jade" ]
        tasks: [ "newer:jade:index" ]

      scripts:
        files: ["<%= amidst.app %>/**/*.coffee"]
        tasks: ["newer:coffee:dist"]

      styles:
        files: ["<%= amidst.app %>/**/*.sass"]
        tasks: [ "compass:dev", "autoprefixer" ]

      livereload_css:
        options: livereload: true
        files: [ "<%= amidst.tmp %>/**/*.css" ]

      livereload_else:
        options: livereload: true
        files: [
          "<%= amidst.dist %>/index.html"
          "<%= amidst.tmp %>/**/*.html"
          "<%= amidst.tmp %>/**/*.js"
        ]

      express:
        files: [ "<%= amidst.srv %>/**/*.coffee", "amidst.coffee" ]
        tasks: ["express:dev"]
        options:
          livereload: true
          nospawn:    true

      css:
        files: ["<%= amidst.app %>/**/*.css"]
        tasks: [ "newer:copy:styles_tmp", "autoprefixer" ]

      gruntfile: files: ["Gruntfile.{js,coffee}"]


    clean:
      dist:
        files: [
          dot: true
          src: [
            "<%= amidst.tmp %>/*"
            "<%= amidst.dist %>/*"
          ]
        ]


    jade:
      index:
        expand: true
        cwd:    "<%= amidst.app %>"
        src:    [ "index.jade" ]
        dest:   "<%= amidst.dist %>"
        ext:    ".html"
      templates:
        expand: true
        cwd:    "<%= amidst.app %>"
        src:    [ "**/*.jade", "!index.jade" ]
        dest:   "<%= amidst.tmp %>"
        ext:    ".html"


    autoprefixer:
      options: browsers: ["last 1 version"]
      dist:
        expand: true
        cwd:    "<%= amidst.tmp %>"
        src:    [ "**/*.css" ]
        dest:   "<%= amidst.tmp %>"


    coffee:
      dist:
        options: sourceMap: false
        files: [
          expand: true
          cwd:  "<%= amidst.app %>"
          src:  "**/*.coffee"
          dest: "<%= amidst.tmp %>"
          ext: ".js"
        ]
      dev:
        options:
          sourceMap: true
          sourceRoot: ""
        files: "<%= coffee.dist.files %>"


    compass:
      options:
        sassDir:                 "<%= amidst.app %>"
        cssDir:                  "<%= amidst.tmp %>"
        imagesDir:               "<%= amidst.app %>"
        javascriptsDir:          "<%= amidst.app %>"
        fontsDir:                "<%= amidst.app %>"
        importPath:              "components"
        httpImagesPath:          "/images"
        httpFontsPath:           "/fonts"
        relativeAssets:          false
        assetCacheBuster:        false

      prod: options: debugInfo: false
      dev:  options: debugInfo: true
      watch:
        debugInfo: false
        watch:     true


    rev:
      dist:
        src: [
          "<%= amidst.dist %>/**/*.js"
          "<%= amidst.dist %>/**/*.css"
          "<%= amidst.dist %>/**/*.{png,jpg,jpeg,gif,webp,svg}"
          "!<%= amidst.dist %>/**/opengraph.png"
        ]


    useminPrepare:
      options: dest: "public"
      html: "<%= amidst.dist %>/index.html"


    usemin:
      options: assetsDirs: "<%= amidst.dist %>"
      html: [ "<%= amidst.dist %>/**/*.html" ]
      css:  [ "<%= amidst.dist %>/**/*.css" ]


    ngmin:
      dist:
        expand: true
        cwd:  "<%= amidst.tmp %>"
        src:  "**/*.js"
        dest: "<%= amidst.tmp %>"


    copy:
      styles_tmp:
        expand: true
        cwd:  "<%= amidst.app %>"
        src:  "**/*.css"
        dest: "<%= amidst.tmp %>"
      components_dist:
        expand: true
        src:  [ "components/**" ]
        dest: "<%= amidst.dist %>"
      app_dist:
        expand: true
        cwd: "<%= amidst.app %>"
        dest: "<%= amidst.dist %>"
        src: [
          "*.{ico,txt}"
          "images/**/*"
          "fonts/**/*"
        ]


    concurrent:
      dist1_dev: [
        "compass:dev"
        "coffee:dev"
        "copy:styles_tmp"
      ]
      dist1: [
        "jade"
        "compass:prod"
        "coffee:dist"
        "copy:styles_tmp"
      ]
      dist2: [
        "ngmin"
        "autoprefixer"
      ]
      dist3: [
        "copy:app_dist"
        "copy:components_dist"
      ]
      watch:
        options: logConcurrentOutput: true
        tasks: [
          "watch"
          "compass:watch"
        ]


    ngtemplates:
      amidstExamples:
        cwd:  "<%= amidst.tmp %>"
        src:  [ "**/*.html", "!index.html" ]
        dest: "<%= amidst.dist %>/scripts/templates.js"
        options:
          usemin: "scripts/main.js"



  grunt.registerTask "build", [
    "clean"

    "concurrent:dist1"

    "prettify"
    "useminPrepare"

    "concurrent:dist2"

    "ngtemplates"
    "concat:generated"

    "cssmin:generated"
    "uglify:generated"

    "usemin"

    "concurrent:dist3"
  ]


  grunt.registerTask "express-keepalive", -> @async()


  grunt.registerTask "serve", (target) ->
    if target is "dist"
      return grunt.task.run [
        "build"
        "express:prod"
        "express-keepalive"
      ]
    else
      return grunt.task.run [
        "clean"

        "jade"
        "concurrent:dist1_dev"

        "prettify"

        "autoprefixer"
        "useminPrepare"

        "concurrent:dist2"

        "express:dev"

        "concurrent:watch"
      ]


  grunt.registerTask "default", [
    "build"
  ]

