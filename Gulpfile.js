var gulp = require('gulp');
var sass = require('gulp-sass');
var insert = require('gulp-insert');
var shell = require('gulp-shell');
var del = require('del');

gulp.task('styles', function() {
    gulp.src('sass/**/*.sass')
        .pipe(sass().on('error', sass.logError))
        .pipe(insert.prepend("---\n---\n")) // we need jekyll to take the compiled file and add it to the generated site
        .pipe(gulp.dest('./source/css/'));
});

gulp.task('clean-build', function() { return del(['public/']) })

gulp.task('jekyll', shell.task(['jekyll build --source ./source']));

gulp.task('live', function() {
    gulp.watch('sass/**/*.sass', ['styles']);
    gulp.watch('source/**/*', ['clean-build', 'jekyll']);
});

gulp.task('default', ['styles', 'clean-build', 'jekyll', 'live']);
