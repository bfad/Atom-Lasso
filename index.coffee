module.exports =
  activate: ->
    atom.commands.add 'atom-workspace', "language-lasso:check_syntax": => @check_syntax()

  check_syntax: ->
    editor = atom.workspace.getActiveTextEditor()
    editor.buffer.save()
    fs = require 'fs'
    lassocPath = '/usr/bin/lassoc'
    if !(fs.existsSync(lassocPath))
        alert('Lasso does not appear to be installed on this system; cannot validate syntax')
    else
        require("child_process").execFile(lassocPath, [editor.buffer.file.path, '-n', '-o', '/dev/null'],
          (error, stdout, stderr) ->
            if(stderr and stderr.length > 0)
              parsed = stderr.match(/line: (\d+), col: (\d+)\s*$/)
              if(parsed)
                row    = parseInt(parsed[1]) - 1
                col    = parseInt(parsed[2]) - 1
                editor.setCursorBufferPosition([row, col])

              alert(stderr)
            else
              alert('No problems found')
        )
