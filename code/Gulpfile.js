var gulp = require('gulp');
var sass = require('gulp-sass');
var insert = require('gulp-insert');
var shell = require('gulp-shell');
var del = require('del');

gulp.task('styles', function() {
    gulp.src('sass/**/*.scss')
        .pipe(sass().on('error', sass.logError))
        .pipe(insert.prepend("---\n---\n")) // we need jekyll to take the compiled file and add it to the generated site
        .pipe(gulp.dest('./source/css/'));
});

gulp.task('clean-build', del('public/'))

gulp.task('jekyll', shell.task(['jekyll build --source ./source']));

gulp.task('default', function() {
    gulp.watch('sass/**/*.scss', ['styles', 'clean-build', 'jekyll']);
})
