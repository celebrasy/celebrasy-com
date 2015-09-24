# Celebrasy

[![Build Status](https://travis-ci.org/celebrasy/celebrasy-com.svg?branch=master)](https://travis-ci.org/celebrasy/celebrasy-com)
[![Code Climate](https://codeclimate.com/github/celebrasy/celebrasy-com/badges/gpa.svg)](https://codeclimate.com/github/celebrasy/celebrasy-com)
[![Test Coverage](https://codeclimate.com/github/celebrasy/celebrasy-com/badges/coverage.svg)](https://codeclimate.com/github/celebrasy/celebrasy-com/coverage)

### System dependencies
``` bash
brew install chromedriver
```

### Initial Setup

``` bash
git clone git@github.com:celebrasy/celebrasy-com.git
cd celebrasy-com
bundle
rake db:create db:migrate db:seed:all
RACK_ENV=test rake db:create db:migrate
bin/rspec && bin/cucumber
foreman start
open http://localhost:3000/leagues/1/teams
```

### Docker Locally

* [Docker Toolbox](https://www.docker.com/toolbox)

```
docker build -t celebrasy:{local-version} .
docker run -d -p 8080:3000 --name celebrasy celebrasy:3
curl $(docker-machine ip default):8080
```
