guard :rspec, cmd: "rspec --color", all_on_start: false do
  watch(/^spec\/(.+)_spec\.rb$/)
  watch(/^providers\/(.+)\.rb$/) { |m| "spec/#{m[1]}_provider_spec.rb" }
  watch(/^recipes\/(.+)\.rb$/)   { |m| "spec/#{m[1]}_spec.rb" }
  watch("spec/spec_helper.rb")   { "spec" }
end

guard :rubocop, all_on_start: false, keep_failed: false do
  watch(/.+\.rb$/)
  watch(/(?:.+\/)?\.rubocop\.yml$/) { |m| File.dirname(m[0]) }
end
