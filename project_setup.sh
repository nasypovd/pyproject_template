#!/bin/bash

VERSIONS="
    3.6
    3.7
    3.8
    3.9
"

VERSION=$1

echo $VERSIONS | grep -w -q $VERSION || {
    echo Unsupported python version $VERSION
    echo Supported versions: $VERSIONS
    exit 1
}

PYTHON_VERSION=python$VERSION

PYTHON=$(which $PYTHON_VERSION) || {
    echo Could not find $PYTHON_VERSION - is it installed?
    exit 1
}

ENVIRONMENT_DIR=.env$VERSION

$PYTHON -m venv $ENVIRONMENT_DIR \
&& . ./$ENVIRONMENT_DIR/bin/activate \
&& python -m pip install --upgrade pip \
&& python -m pip install -r requirements-dev.txt -c constraints.txt \
&& python -m pip install -r requirements.txt -c constraints.txt

grep -w -q $ENVIRONMENT_DIR .gitignore || echo /$ENVIRONMENT_DIR >> .gitignore
sed -i s/'$ENVIRONMENT_IF_NOT_SET'/$ENVIRONMENT_DIR/ .vscode/settings.json

echo Done
echo Restart the shell to activate environment
