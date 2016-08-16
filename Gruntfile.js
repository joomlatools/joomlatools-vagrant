module.exports = function(grunt) {

    // load time-grunt and all grunt plugins found in the package.json
    require( 'load-grunt-tasks' )( grunt );

    // Customise the browser used by BrowserSync, example: `grunt --canary`
    var browser = 'default';
    if(grunt.option('canary')){ browser = 'Google Chrome Canary'; };

    grunt.initConfig({

        // Checks if your NPM or Bower dependencies are out of date
        versioncheck: {
            target: {
                options: {
                    hideUpToDate : false
                }
            }
        },

        // Sass
        sass: {
            dist: {
                files: {
                    'puppet/modules/scripts/files/scripts/assets/css/dashboard.css': 'puppet/modules/scripts/files/scripts/assets/css/dashboard.scss',
                }
            }
        },

        // Autoprefixer
        autoprefixer: {
            options: {
                browsers: ['last 2 versions']
            },
            files: {
                expand: true,
                flatten: true,
                src: 'puppet/modules/scripts/files/scripts/assets/css/*.css',
                dest: 'puppet/modules/scripts/files/scripts/assets/css/'
            }
        },

        browserSync: {
            dev: {
                bsFiles: {
                    src : 'puppet/modules/scripts/files/scripts/assets/css/*.css'
                },
                options: {
                    proxy: "joomla.box/joomlatools-vagrant/puppet/modules/scripts/files/scripts/",
                    port: 5666, // JOOM on phone keypad
                    watchTask: true, // < VERY important
                    notify: false,
                    browser: browser
                }
            }
        },

        // Watch
        watch: {
            css: {
                files: 'puppet/modules/scripts/files/scripts/assets/**/*.*',
                tasks: ['sass', 'autoprefixer'],
                options: {
                    interrupt: false,
                    atBegin: true
                }
            }
        }
    });

    grunt.registerTask('default', ['versioncheck', 'browserSync', 'watch']);
};
