require "bundler"
Bundler.require :default

base = File.dirname(__FILE__)
$:.unshift File.join(base, "lib")

require "share_the_share"

Sinatra::Base.set(:root) { base }
run ShareTheShare::Application

