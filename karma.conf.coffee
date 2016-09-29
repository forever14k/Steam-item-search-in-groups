# Karma configuration
# Generated on Wed Sep 28 2016 23:18:23 GMT+0300 (RTZ 2 (зима))

module.exports = (config) ->
  config.set
    basePath: ''
    frameworks: [ 'jasmine' ]
    files: [
      'temp/js/libs/jquery.js',
      'temp/js/libs/*.js',
      'temp/js/templates/*.js',
      'temp/js/templates/**/*.js',
      'temp/js/scripts/*.js'
      'temp/js/scripts/types/*.js'
      'temp/js/scripts/views/*.js'
      'temp/js/scripts/actions/*.js'
      'temp/js/scripts/reducers/**/*.js'
      'tests/**/*.coffee'
    ]
    exclude: [
      'temp/js/scripts/state.js'
      'temp/js/scripts/index.js'
    ]
    preprocessors: '**/*.coffee': [ 'coffee' ]
    reporters: [ 'verbose', 'kjhtml' ]
    port: 9876
    colors: true
    logLevel: config.LOG_INFO
    autoWatch: true
    browsers: [
      'Chrome'
      # 'CromeWithoutSecurity'
      # 'PhantomJS'
    ]
    customLaunchers:
      'CromeWithoutSecurity':
        base: 'Chrome'
        flags: [ '--disable-web-security' ]
    useIframe: false
    singleRun: false
    concurrency: Infinity
