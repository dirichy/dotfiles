#!/usr/bin/env lua
hypr = {}
hypr.window = require("window")
hypr.monitor = require("system.monitor")
hypr.event = require("event")
hypr.cmd = require("util").cmd
hypr.dispatch = require("util").dispatch
hypr.debounce = require("util").debounce
require("ipcuv")
