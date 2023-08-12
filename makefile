git:
    git add .
    git commit -m "$m"
    git push -u origin master
build-dev:
    git pull
    flutter build apk --debug
build:
    git pull
    flutter build apk