require "bundler/setup"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "zero"

Zero.db = ENV["MONGOHQ_URL"] || "zerop_development"

run Zero::App

