git:
    git add .
    git commit -m "$m"
    git push -u origin master
build-dev:
    flutter build apk --debug
build:
    flutter build apk