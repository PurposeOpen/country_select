#!/usr/bin/env rake
require "bundler/gem_tasks"

module Bundler
  class GemHelper
    def rubygem_push(path)
      gem_server = 'http://gems.purpose.com'
      sh "stickler config --add --server #{gem_server} --upstream https://rubygems.org"
      sh "stickler push #{path}"
      Bundler.ui.confirm "Pushed #{name} #{version} to #{gem_server}"
    end

    def git_push
      perform_git_push " origin #{version_tag}"
      Bundler.ui.confirm "Pushed tag #{version_tag}"
    end
  end
end
