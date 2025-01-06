// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

let map = null;
let tiles = null;

// Variables for new task view
let task_lat = 0.0;
let task_lon = 0.0;
let markers = [];
let polpoints = [];
let html_polygon = null;
let polygon = null;
let closed = false;
let html_polpoints = [];
let panel_height = null;

// Variables for results list
let marker = null;
let opacity = 0.5;
let edus_radius = 10;
let slider = null;
let slider_value = null;
let slider_edus = null;
let slider_edus_value = null;
let circles = [];
let edus = [];
