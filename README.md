# CityZones Application Server

CityZones Application Server is a web interface and back-end application for CityZones Maps-service: https://github.com/jpjust/cityzones-maps-service

The web interface works as a client for the user, so the user can configure an AoI to reqeuest a RiskZones classification. The Maps-service workers will periodically request a task from the CityZones Application Server to perform it locally and then send the results back. The web interface can then present the results to the user.

## Dependencies

* Ruby 3.1.2 (if your system's Ruby version is different, we recommend using `rbenv` to install the proper version)

## How to deploy

First of all, clone this repository into your server folder. After cloning, `cd` into the cloned repository and follow these steps:

First, install all dependencies.

`bundle install`

Copy `.env.example` file and set the configuration for your server. Pay attention the the database configuration.

`cp .env.example .env`

Run migration scripts to create database tables and populate them with default values.

`bundle exec rake db:migrate`

To run CityZones Web you will need Phusion Passenger WSGI enabled in your server. Follow your HTTP daemon instructions to setup Passenger and finish the deployment.

## Admin account

CityZones has an admin account. Email: `admin`, password: `admin`. Use this account to register workers and get their API keys.
