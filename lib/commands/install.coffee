fs                 = require("fs")
Chalk              = require("chalk")
GameServer         = require("../server_builder")
{ Command, flags } = require('@oclif/command')
{ execSync }       = require 'child_process'

class InstallCommand extends Command
  run: ->
    { flags } = this.parse(InstallCommand)
    try
      jsonConfig = JSON.parse(fs.readFileSync(flags.file))
      flags.config = jsonConfig
    catch e
      this.error(Chalk.red.bold("Error parsing config file: #{e}"))
      process.exit
    
    flags.path = "/home/#{flags.config.meta.user}/#{flags.config.meta.game}-server"
    this.log "server will be installed to #{flags.path}"
    execSync("mkdir -p /home/#{flags.config.meta.user}/.config/systemd/user")
    GameServer.install(flags)

InstallCommand.description = "install a dedicated game server as a daemon"

InstallCommand.flags = {
  file:   flags.string( {char: 'f', description: 'path to the config file'}),
  dryrun: flags.boolean({char: 'd', description: 'test installing a server without actually installing it'}),
}

module.exports = InstallCommand
