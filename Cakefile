fs                = require 'fs'
{spawn, execFile} = require 'child_process'


# select tests to be executed

selected_tests    = {
  base: true
}

active_tests = []

if selected_tests.base
  active_tests.push 'test/base/objset_test.coffee'


css_sources       = ['styl/main.styl']
css_target        = 'public/css'

# binaries
bin_coffee = "./node_modules/.bin/coffee"
bin_mocha  = "./node_modules/.bin/mocha"
bin_stylus = "./node_modules/.bin/stylus"

# ANSI Terminal Colors
bold  = '\x1B[0;1m'
red   = '\x1B[0;31m'
green = '\x1B[0;32m'
reset = '\x1B[0m'

option '-w', '--watch', 'continually build upon change'
option '-C', '--coffee-arg [ARG*]', 'pass extra arguments to coffee'
option '-r', '--reporter [STYLE]', 'set test reporter to be used by mocha'
option '-M', '--mocha-arg [ARG*]', 'pass extra arguments to mocha'

run_proc = (name, cmd, args) ->
  proc = spawn cmd, args
  proc.stdout.on 'data', (data) -> console.log data.toString().trim()
  proc.stderr.on 'data', (data) -> console.error data.toString().trim()
  proc.on 'exit', (code, signal) =>
    if code is 0
      console.log "#{green}#{name} has completed#{reset}"
    else
      console.error "#{red}#{name} has failed#{reset}"

task 'build', 'compile coffee and sass', (options) ->
  watch_args  = if options.watch then ['-w'] else []
  coffee_args = if options["coffee-arg"] then options["coffee-arg"].join(' ') else []

  server_args = watch_args.concat(['-o', 'lib', '--compile'])
  server_args = server_args.concat(coffee_args)
  server_args = server_args.concat(['src'])
  run_proc 'compiling server code', bin_coffee, server_args

  client_args = watch_args.concat(['--join', 'public/js/ride2go.js', '--compile', '--bare'])
  client_args = client_args.concat(coffee_args)
  client_args = client_args.concat(['src/client/ride2go.coffee', 'src/client/autocomplete.coffee'])
  run_proc 'compiling client code', bin_coffee, client_args

  stylus_args = watch_args.concat(['-o', css_target])
  stylus_args = stylus_args.concat(css_sources)
  run_proc 'stylesheet building', bin_stylus, stylus_args

task "test", "run all tests", (options) ->
  watch_args = if options.watch then ['--watch'] else []
  mocha_args = if options['mocha-arg'] then options['mocha-arg'].join(' ') else []

  test_args  = watch_args.concat(['--compilers', 'coffee:coffee-script'])
  test_args  = test_args.concat(['--colors', '--reporter',  options.reporter || 'spec'])
  test_args  = test_args.concat(['--ui', 'bdd', '-G'])
  test_args  = test_args.concat(['--require', 'coffee-script'])
  test_args  = test_args.concat(['--require', 'test/test_helper.coffee'])
  test_args  = test_args.concat(mocha_args)
  test_args  = test_args.concat(active_tests)
  test_env   = Object.create(process.env)
  test_env['NODE_ENV'] = 'test'
  test_opts  = { 'cwd': undefined, 'env': test_env }
  execFile bin_mocha, test_args, test_opts, (err, output) ->
    console.log output
    throw err if err
